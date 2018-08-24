import Foundation

/**
 * A struct to hold the information for a Bank Account.
 - is_default: Is this the default payment source for settling transactions.
 - name: Name of the Bank Account.
 - institution: Name of the Bank Institution with which the account is linked.
 - url: Dwolla resource for this bank account to create transfers
 */

struct Account {
    let name: String
    let institution: String
    let url: String
    var is_default: Bool
}
