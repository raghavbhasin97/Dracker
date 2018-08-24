import Foundation

/**
 * A struct to hold the configurations for the Change Voew Controller. This helps create the controller and make it reusable.
 - title: First line of text or the main title of page.
 - image: Image associated with the change action.
 - button: Text to be displayed on the button.
 - placeholder: Placeholder for the text field.
 - isSecure: Is the text field secure.
 - action: A function refrence that returns true on success(navigates back) and false on failure (stays on the same page). Used to perform the change action and switch back to parent. The function takes in the text of textfield as an argument.
 */
struct Configuration {
    var title: String
    var image: String
    var button: String
    var placeholder: String
    var isSecure: Bool
    var action: (String) -> Bool
}
