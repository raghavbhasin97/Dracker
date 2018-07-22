import UIKit

let states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
var settled_transactions: [Settled] = []
var unsettled_transactions: [Unsettled] = []
var friends: [Friends] = []

var credit: Double = 0.0
var debit: Double = 0.0

let cache = NSCache<AnyObject, AnyObject>()

//MARK: Constants
let seconds_in_day = 86400.0
let kPasscodeTransformScale:CGFloat = 30.0
