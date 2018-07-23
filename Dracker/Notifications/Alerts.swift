import Foundation
import UIKit

//MARK: Messages
enum error_messages: String {
    case duplicate_phone = "Phone number is already associated with an existing account."
    case identity_unverified = "There was an error validating your identity."
    case incorrect_email = "Email entered is invalid."
    case incorrect_password = "Password entered is invalid."
    case incorrect_login =  "Provided credentials are incorrect - please try again."
    case unverified_email = "Your email has not been verified yet."
    case reset_email = "An email has been sent with reset information."
    case account_not_found = "We didn't find any accounts for this email."
    case incorrect_phone = "Phone number entered is invalid."
    case incorrect_name = "A valid name is needed to register."
    case incorrect_profile = "You didn't select a profile picture."
    case duplicate_account = "An account already exists for this email."
    case account_created = "Account successfully created."
    case no_internet = "Device is not connected to the internet."
    case long_description = "Description is too long, keep it simple. Get creative 😜"
    case invalid_amount = "Amount entered is invalid."
    case phone_first = "Select payer/recipient before proceeding."
    case phone_not_registered = "Phone number is not registered."
    case empty_description = "Please say a few words about this transaction."
    case debt_with_self = "You cann't add a transaction with yourself."
    case incorrect_code = "Confirmation code does not match."
    case password_reset_successful = "Password has been reset."
    case error_reset = "An error has occured."
    case error_reset_email = "Provided email is associated with another account."
    case email_reset_successful = "Email has been reset, please confirm the new email."
    case incorrect_passcode = "Passcode entered is inavlid"
    case incorrect_frequency = "Frequency entered is invalid."
    case invalid_qr = "Invalid QR Code."
    case device_not_supported = "Your device does not support scanning QR code."
    case touchid_not_enabled = "Touch ID must be enabled to set a passcode."
    case phone_not_match = "Phone number does not match with the one in records."
    case funding_error = "There was an error connecting to your bank account"
    case cannot_settle = "This transaction can not be settled at this time."
}

//MARK: Create Alert
fileprivate func create_alert(message: String, title: String, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController
{
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: handler))
    return alert
}

//MARK: Image Picker
func image_picker_action_sheet(controller: UIViewController, picker: UIImagePickerController, action1: String, action2: String, camera: UIImagePickerControllerCameraDevice, first_responder: UITextField? = nil)  -> UIAlertController {
    let actions = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    actions.addAction(UIAlertAction(title: action1, style: .default, handler: { (_) in
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        controller.present(picker, animated: true, completion: nil)
    }))
    actions.addAction(UIAlertAction(title: action2, style: .default, handler: { (_) in
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.cameraDevice = camera
        controller.present(picker, animated: true, completion: nil)
    }))
    actions.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        first_responder?.becomeFirstResponder()
    }))
    return actions
}

//MARK: Alerts with view controller

func present_alert_error(message: error_messages, target: UIViewController){
    execute_on_main {
        let alert = create_alert(message: message.rawValue, title: "Aw, Snap!")
        target.present(alert, animated: true)
    }
}

func present_alert_success(message: error_messages, target: UIViewController){
    execute_on_main {
        let alert = create_alert(message: message.rawValue, title: "Success!")
        target.present(alert, animated: true)
    }
}

func present_alert_with_handler_and_message(message: error_messages, target: UIViewController ,handler: ((UIAlertAction) -> Void)? = nil) {
    execute_on_main {
        let alert = create_alert(message: message.rawValue, title: "Success", handler: handler)
        target.present(alert, animated: true)
    }
}

func present_error_alert_with_handler_and_message(message: error_messages, target: UIViewController ,handler: ((UIAlertAction) -> Void)? = nil) {
    execute_on_main {
        let alert = create_alert(message: message.rawValue, title: "Aw, Snap!", handler: handler)
        target.present(alert, animated: true)
    }
}

