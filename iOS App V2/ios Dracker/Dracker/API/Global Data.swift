import Foundation
import UIKit

var settledTransactions: [Settled] = []
var unsettledTransactions: [Unsettled] = []
var credit: Double = 0
var debit: Double = 0
var imageCache = NSCache<AnyObject, UIImage>()
var Configrations =  Bundle.main.infoDictionary?["Data"] as! [String: [String: String]]
let buckets = Configrations["S3"]!
let sgAPI = Configrations["SendGrid"]!
let api = Configrations["API"]!
var currentUser: AuthUser!
var dataCache = NSCache<AnyObject, AnyObject>()
var overview: [OverviewItem] = []
var fundings: [FundingSource] = []
