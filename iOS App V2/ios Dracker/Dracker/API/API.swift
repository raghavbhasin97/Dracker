import Foundation
import Alamofire
import SendGrid_Swift
import AWSS3

let apiUrl = api["url"]! + "/" + api["stage"]!
let headers = ["x-api-key" : api["key"]!]


func parseUserData(data: [String: Any]) {
    if(data.count == 0) { return }
    if let unsettled = data["unsettled"] as? [[String: Any]] {
        unsettledTransactions = []
        unsettled.forEach { (item) in
            unsettledTransactions.append(Unsettled(data: item))
        }
    }
    
    if let settled = data["settled"] as? [[String: Any]] {
        settledTransactions = []
        settled.forEach { (item) in
            settledTransactions.append(Settled(data: item))
        }
    }

    if let creditValue = data["credit"] as? Double {
        credit = creditValue
    }
    
    if let debitValue = data["debit"] as? Double {
        debit = debitValue
    }
}

func parseOverviewData(data: [String: Any]) {
    overview = []
    data.forEach { (uid, value) in
        if let value = value as? [String: Any] {
            let phone = value["phone"] as! String
            let name = value["name"] as! String
            let amount = value["amount"] as! Double
            overview.append(OverviewItem(uid: uid, name: name, phone: phone, amount: amount))
        }
    }
}

func parseFundingSources(data: [[String: Any]]) {
    fundings = []
    for source in data {
        fundings.append(FundingSource(source: source))
    }
}

func getUserTransactions(_ uid: String, _ completion: (([String: Any]) -> Void)? = nil) {
    
    let url = apiUrl + "/transaction/" + uid
    Alamofire.request(url, method: .get, parameters: [:], encoding: URLEncoding.queryString, headers: headers).responseJSON { (res) in
        guard let response = res.result.value as? [String: Any] else {
            completion?([:])
            return
        }
        completion?(response)
    }
}

func getOverview(_ uid: String, _ completion: (([String: Any]) -> Void)? = nil) {
    let url = apiUrl + "/summary/" + uid
    Alamofire.request(url, method: .get, parameters: [:], encoding: URLEncoding.queryString, headers: headers).responseJSON { (res) in
        guard let response = res.result.value as? [String: Any] else {
            completion?([:])
            return
        }
        completion?(response)
    }
}

func getUserData(phone: String, _ completion: (([String: Any]) -> Void)? = nil) {
    
    let url = apiUrl + "/users/user"
    Alamofire.request(url, method: .get, parameters: ["phone": phone], encoding: URLEncoding.queryString, headers: headers).responseJSON { (res) in
        guard let response = res.result.value as? [String: Any] else {
            completion?([:])
            return
        }
        completion?(response)
    }
    
}

func getUsers(params: [String: Any], completion: (([[String: String]]) -> Void)? = nil) {
    let url = apiUrl + "/users/"
    var isQuery = true
    if(params["phone"] != nil ) {
        isQuery = false
        if let response = dataCache.object(forKey: "phone" as AnyObject) {
            completion?(response as! [[String : String]])
            return
        }
    } else {
        let query = params["search"]!
        if let response = dataCache.object(forKey: query as AnyObject) {
            completion?(response as! [[String : String]])
            return
        }
    }
    
    Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.queryString, headers: headers).responseJSON { (res) in
        guard let response = res.result.value as? [[String: String]] else {
            completion?([])
            return
        }
        let key = isQuery ? params["search"]! : "phone"
        dataCache.setObject(response as AnyObject, forKey: key as AnyObject)
        completion?(response)
    }
}

func deleteTransaction(id: String, payee: String , _ completion: (() -> Void)? = nil) {
    let url = apiUrl + "/transaction/delete/"
    if let body = getBody(params: ["transaction_id": id, "payer_uid": currentUser.uid, "payee_uid": payee]) {
        Alamofire.request(url, method: .put, parameters: [:], encoding: body, headers: headers).responseJSON { (res) in
            completion?()
            
        }
    }
}

func settleTransaction(id: String, payer: String , _ completion: ((Int) -> Void)? = nil) {
    let url = apiUrl + "/transaction/settle/"
    if let body = getBody(params: ["transaction_id": id, "payee_uid": currentUser.uid, "payer_uid": payer, "time": Date().formatDate(option: .full)]) {
        Alamofire.request(url, method: .put, parameters: [:], encoding: body, headers: headers).responseJSON { (res) in
            guard let code = res.value as? Int else {
                completion?(400)
                return
            }
            completion?(code)
            
        }
    }
}

func uploadTransactionImage(key: String, data: NSURL, confirmationBlock: (() -> Void)? = nil , progress: ((Int64, Int64, Int64) -> Void)? = nil) {
    uploadImage(key: key, bucket: buckets["transactions"]!, data: data, confirmationBlock: confirmationBlock, progress: progress)
}

func uploadProfileImage(key: String, data: NSURL, confirmationBlock: (() -> Void)? = nil, progress: ((Int64, Int64, Int64) -> Void)? = nil) {
    uploadImage(key: key, bucket: buckets["profiles"]!, data: data, confirmationBlock: confirmationBlock, progress: progress)
}


func addTransaction(params: [String: Any], completion: ((String?) -> Void)? = nil) {
    let url = apiUrl + "/transaction/add/"
    if let body = getBody(params: params) {
        Alamofire.request(url, method: .post, parameters: [:], encoding: body, headers: headers).responseJSON { (res) in
            guard let id = res.value as? String else {
                completion?(nil)
                return
            }
            completion?(id)
        }
    }
}

func updateEmail(email: String, completion: ((Bool) -> Void)? = nil) {
    let url = apiUrl + "/users/update/"
    if let body = getBody(params: ["old_email": currentUser.email, "new_email": email]) {
        Alamofire.request(url, method: .post, parameters: [:], encoding: body, headers: headers).responseJSON { (res) in
            guard let data = res.value as? [String: Any] else {
                completion?(false)
                return
            }
            guard let message = data["message"] as? String  else {
                completion?(false)
                return
            }
            completion?(message == "SUCCESS")
        }
    }
}


func getFindingSources(phone: String, completion: (([[String: Any]]) -> Void)? = nil) {
    let url = apiUrl + "/users/funding-sources"
    Alamofire.request(url, method: .get, parameters: ["phone": phone], encoding: URLEncoding.queryString, headers: headers).responseJSON { (res) in
        guard let result = res.value as? [String: Any] else {
            completion?([])
            return
        }
        guard let list = result["list"] as? [[String:Any]] else {
            completion?([])
            return
        }
        completion?(list)
    }
}


func addFundingSource(params: [String: Any],  completion: ((Bool, String?) -> Void)? = nil) {
     let url = apiUrl + "/users/funding-sources"
    if let body = getBody(params: params) {
        Alamofire.request(url, method: .post, parameters: [:], encoding: body, headers: headers).responseJSON { (res) in
            guard let response = res.value as? [String: Any] else {
                completion?(false, nil)
                return
            }
            guard let code = response["message"] as? String else {
                completion?(false, nil)
                return
            }
            completion?(code == "SUCCESS", response["url"] as? String)
        }
    }
}

func deleteFundingSource(fundungUrl: String, completion: ((Bool) -> Void)? = nil) {
    let url = apiUrl + "/users/funding-sources"
    let params = ["url": fundungUrl, "phone": currentUser.phone]
    Alamofire.request(url, method: .delete, parameters: params, encoding: URLEncoding.queryString, headers: headers).responseJSON { (res) in
        guard let response = res.value as? [String: Any] else {
            completion?(false)
            return
        }
        guard let code = response["message"] as? String else {
            completion?(false)
            return
        }
        completion?(code == "SUCCESS")
    }
}

func setDefaultFundingSource(sourceURL: String, completion: ((Bool) -> Void)? = nil) {
    let url = apiUrl + "/users/funding-sources/default"
    if let body = getBody(params: ["url": sourceURL, "phone": currentUser.phone]) {
        Alamofire.request(url, method: .put, parameters: [:], encoding: body, headers: headers).responseJSON { (res) in
            guard let response = res.value as? [String: Any] else {
                completion?(false)
                return
            }
            guard let code = response["message"] as? String else {
                completion?(false)
                return
            }
            completion?(code == "SUCCESS")
        }
    }
}

func sendEmail(email: String, text: String, subject: String, completion: ((Bool) -> Void)? = nil) {
    let sendGrid = SendGrid(withAPIKey: sgAPI["key"]!)
    let content = SGContent(type: .html, value: text)
    let from = SGAddress(email: "no-reply@dracker.com")
    let personalization = SGPersonalization(to: [ SGAddress(email: email)])
    let subject = subject
    let email = SendGridEmail(personalizations: [personalization], from: from, subject: subject, content: [content])
    sendGrid.send(email: email) { (response, error) in
        if error != nil {
            completion?(false)
        } else {
            completion?(true)
        }
    }
}

private func uploadImage(key: String, bucket: String, data: NSURL, confirmationBlock: (() -> Void)? = nil, progress: ((Int64, Int64, Int64) -> Void)? = nil) {
    let request = AWSS3TransferManagerUploadRequest()
    request?.bucket = bucket
    request?.body = data as URL
    request?.key = key
    request?.contentType = "image/jpeg"
    request?.acl = .publicRead
    request?.uploadProgress = progress
    let client = AWSS3TransferManager.default()
    client.upload(request!).continueWith { (_) -> Any? in
        confirmationBlock?()
    }
}

