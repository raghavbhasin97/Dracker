import UIKit
import SendGrid_Swift
import Firebase

func send_note_email(email: String, name: String, photo: String, title: String, note: String) {
    let current_name = (Auth.auth().currentUser?.displayName)!
    let html = get_note_email(name: name, photo: photo, transaction_title: title, note: note, current_name: current_name)
    let subject = "\(current_name) added a note"
    send_email(email: email, text: html, subject: subject)
}

func send_email(email: String, text: String, subject: String) {
    let sendGrid = SendGrid(withAPIKey: SendGridAPI_key)
    let content = SGContent(type: .html, value: text)
    let from = SGAddress(email: "no-reply@dracker.com")
    let personalization = SGPersonalization(to: [ SGAddress(email: email)])
    let subject = subject
    let email = SendGridEmail(personalizations: [personalization], from: from, subject: subject, content: [content])
    sendGrid.send(email: email) { (response, error) in
        if let error = error {
            NSLog("Error sending email: \(error.localizedDescription)")
        }
    }
}
