import UIKit

/**
 * A Struct to hold the information for Settled Transactions. A Settled Transaction contains the minimal information about it, since it has been payed off.
 - is_debt: If the transaction was a debt or not
 - amount: Amount for this transaction
 - description:  Description for this transaction
 - name: Name of the other person in this transaction.
 */
struct Settled {
    let is_debt: Bool
    let amount: String
    let description: String
    let name: String
}

/**
 * A Struct to hold the information for Unsettled Transactions. An Unsettled Transaction contains all the information about it that would be necessary to settle it.
 - is_debt: If the transaction was a debt or not
 - amount: Amount for this transaction
 - description:  Description for this transaction
 - name: Name of the other person in this transaction.
 - tagged_image: The image that was tagged with this transaction, could be a bill, some nice image of the web or just nothing (recognised by the value "noImage").
 - time: Time of creating the transaction
 - uid: Unique identifier associated with the other person.
 - phone: Phone associated with the other person.
 - transaction_id: A unique identification string associated with this transaction (a uuid4-hex).
 - notification_identifier: Identifier for the local notification created (can be null if notifications are turned off).
 */
struct Unsettled {
    let is_debt: Bool
    let amount: String
    let description: String
    let name: String
    let tagged_image: String
    let time: String
    let uid: String
    let phone: String
    var notification_identifier: String?
    var transaction_id: String
}
