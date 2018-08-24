import Foundation

/**
 * A struct to hold the information for a Friend.
 - amount: Amount of for this friend.
 - phone: Phone of this friend.
 - name: Name of this friend.
 - uid: Unique identification of this friend.
 - transactions: A list of transaction for this friend. (Settled and Unsettled)
 */
struct Friends {
    let transactions: [Friends_Data]
    let amount: Double
    let phone: String
    let name: String
    var uid: String?
}

/**
 * A struct to hold the information for a transactions. Could be settled of unsettled.
 - is_debt: If the transaction was a debt or not
 - amount: Amount for this transaction
 - description:  Description for this transaction
 - name: Name of the person involved in this transaction.
 - time: Time of creating the transaction. (optional)
 - settelement_time: Time of settlement. (optional)
 */
struct Friends_Data {
    let is_debt: Bool
    let amount: String
    let description: String
    let name: String
    let time: String?
    let settelement_time: String?
}
