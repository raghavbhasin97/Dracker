import Foundation

enum ErrorMessage: String {
    case invalidLogin = "Something went wrong while trying to authenticate you. Please check the provided credentials."
    case wrongPassword = "The password is invalid. Please check the password provided."
    case userNotFound = "There is no user record corresponding to this email. The user doesn't exist or may have been deleted."
    case passwordReset = "We have successfully sent you a password reset link. Pleae check yor inbox for the reset link."
    case errorAddingNote = "Something went wrong while sending the note."
    case successAddingNote = "We have successfull forwarded your note."
    case unverifiedEmail = "Please verify your email address before proceeding."
    case couldNotSettle = "This transaction couldn't be settled at this time. Make sure you have a valid funding source linked to your account"
    case transactionAddError = "Something went wrong while trying to add this transaction."
    case passwordUpdateFailed = "Something went wrong while trying to update your password."
    case emailUpdateFailed = "Something went wrong while trying to update your email."
    case sourceLinkFailed = "Something went wrong while attaching a new funding source."
    case sourceDeleteFailed = "Something went wrong while trying to delete the funding source."
    case defaultSourceDeleteFailed = "Unable to remove the default funding source."
}
