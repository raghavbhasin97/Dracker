import AVFoundation
import UIKit

class QRScanner: UIViewController {
    weak var home: Home?
    var session: AVCaptureSession!
    var preview: AVCaptureVideoPreviewLayer!
    let kSoundCode_Tink = 1057
    
    let navigation_title: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont.boldSystemFont(ofSize: 20)
        title.text = "Scan Code"
        return title
    }()
    
    let box: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let qr_frame = UIImageView(image: #imageLiteral(resourceName: "scanner_frame"))
        view.addSubview(qr_frame)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: qr_frame)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: qr_frame)
        return view
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        session.startRunning()
    }
    
    fileprivate func setup_navigation() {
        navigationItem.titleView = navigation_title
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = UIColor.black
    }
    
    fileprivate func setup_session() {
        session = AVCaptureSession()
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        let input: AVCaptureDeviceInput
        do {
            input = try AVCaptureDeviceInput(device: device)
        } catch {
            return
        }
        if (session.canAddInput(input)) {
            session.addInput(input)
        } else {
            scan_failed()
            return
        }
        let output = AVCaptureMetadataOutput()
        if (session.canAddOutput(output)) {
            session.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [.qr]
        } else {
            scan_failed()
            return
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_navigation()
        setup_session()
        //Add session layer to capture code
        preview = AVCaptureVideoPreviewLayer(session: session)
        preview.frame = view.layer.bounds
        preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(preview)
        session.startRunning()
        view.addSubview(box)
        let padding: CGFloat = 20.0
        let width = view.frame.width - (2*padding)
        let y_axis = (view.frame.height - width)/2 - (navigationController?.navigationBar.frame.height)!
        box.frame = CGRect(x: padding, y: y_axis, width: width, height: width)
        view.bringSubview(toFront: box)
    }
    
    fileprivate func convert_to_dictionary(result: String) -> [String : Any]? {
        let data = result.data(using: .utf8)
        var dictionary: [String: Any]?
        do {
            dictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
        } catch {
            session.stopRunning()
            present_error_alert_with_handler_and_message(message: .invalid_qr, target: self) {[unowned self] (_) in
                self.session.startRunning()
            }
            return nil
        }
        return dictionary
    }
}

//MARK: QRCode metadata decode
extension QRScanner: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            if UserDefaults.standard.bool(forKey: "sound") {
                AudioServicesPlaySystemSound(SystemSoundID(kSoundCode_Tink))
            }
            scan_succeeded(code: stringValue)
        }
        dismiss(animated: true)
    }
    
    func scan_failed() {
        present_alert_error(message: .device_not_supported, target: self)
        session = nil
    }
    
    func scan_succeeded(code: String) {
        session.stopRunning()
        let decrypted = code.decrypt()
        if decrypted == nil {
            session.stopRunning()
            present_error_alert_with_handler_and_message(message: .invalid_qr, target: self) {[unowned self] (_) in
                self.session.startRunning()
            }
            return
        }
        let data = convert_to_dictionary(result: decrypted!)
        if data == nil { return }
        //Setup Controller to transition to and the values
        let controller = AddTransaction()
        controller.dahsboard = home?.Homecomponent
        controller.others_uid = data?["uid"] as? String
        controller.others_name = data?["name"] as? String
        let phone = data?["phone"] as? String
        controller.phone_button.setTitle("@" + phone!, for: .normal)
        navigationController?.pushViewController(controller, animated: true)
    }
}
