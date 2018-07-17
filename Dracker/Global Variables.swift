import UIKit


var settled_transactions: [Settled] = []
var unsettled_transactions: [Unsettled] = []
var friends: [Friends] = []

var credit: Double = 0.0
var debit: Double = 0.0

let cache = NSCache<AnyObject, AnyObject>()

//MARK: Constants
let seconds_in_day = 86400.0
let kPasscodeTransformScale:CGFloat = 30.0
