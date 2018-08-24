import UIKit
import Alamofire
import AWSS3

//Get current user's transaction data
func fetch_data(user_id: String, completion: @escaping () -> Void) {
    make_api_call(parameters: [:], api_endpoint: nil, method: .get, custom_endpoint: Endpoints.base + "/users/\(user_id)") { (data) in
        if data.isFailure {
            completion()
            return
        }
        let result = data.value as! [String: Any]
        let settled = result["settled"] as! [[String: Any]]
        settled_transactions = []
        for transaction in settled {
            //Decode the parameters
            let is_debt = transaction["is_debt"] as! Bool
            let amount = transaction["amount"] as! String
            let description = transaction["description"] as! String
            let name = transaction["name"] as! String
            
            let new_transaction = Settled(is_debt: is_debt, amount: amount, description: description, name: name)
            settled_transactions.append(new_transaction)
        }

        let unsettled = result["unsettled"] as! [[String: Any]]
        unsettled_transactions = []
        for transaction in unsettled {
            //Decode the parameters
            let is_debt = transaction["is_debt"] as! Bool
            let amount = transaction["amount"] as! String
            let description = transaction["description"] as! String
            let name = transaction["name"] as! String
            let tagged_image = transaction["tagged_image"] as! String
            let time = transaction["time"] as! String
            let uid = transaction["uid"] as! String
            let phone = transaction["phone"] as! String
            let transaction_id = transaction["transaction_id"] as! String
            let notification_identifier = transaction["notification_identifier"] as? String
            
            let new_transaction = Unsettled(is_debt: is_debt, amount: amount, description: description, name: name, tagged_image: tagged_image, time: time, uid: uid, phone: phone, notification_identifier: notification_identifier, transaction_id: transaction_id)
            unsettled_transactions.append(new_transaction)
        }
        credit = result["credit"] as! Double
        debit = result["debit"] as! Double
        completion()
    }
}

//Get current user's Friends_data
func fetch_friends(user_id: String, completion: @escaping () -> Void) {
    make_api_call(parameters: [:], api_endpoint: nil, method: .get, custom_endpoint: Endpoints.friends + "/\(user_id)") { (data) in
        if data.isFailure {
            completion()
            return
        }
        friends = []
        let result = data.value as! [String: [String: Any]]

        for (uid, value) in result {
            let transactions = value["transactions"] as! [[String: Any]]
            var transaction_list: [Friends_Data] = []
            for transaction in transactions {
                let is_debt = transaction["is_debt"] as! Bool
                let amount = transaction["amount"] as! String
                let description = transaction["description"] as! String
                let name = transaction["name"] as! String
                let time = transaction["time"] as? String
                let settelement_time = transaction["settelement_time"] as? String
                
                let new_transaction = Friends_Data(is_debt: is_debt, amount: amount, description: description, name: name, time: time, settelement_time: settelement_time)
                transaction_list.append(new_transaction)
            }
            
            let phone = value["phone"] as! String
            let amount = value["amount"] as! Double
            let name = value["name"] as! String
            
            let new_friend = Friends(transactions: transaction_list, amount: amount, phone: phone, name: name, uid: uid)
            friends.append(new_friend)
        }
        completion()
    }
}

//Get user's data
func get_user_data(phone: String, completion: @escaping ((Result<Any>) -> Void)) {
    make_api_call(parameters: ["phone": phone], api_endpoint: Endpoints.user_data, method: .get, custom_endpoint: nil, completion: completion)
}

func remove_funding_source(phone: String, url: String, completion: @escaping ((Result<Any>) -> Void)) {
    make_api_call(parameters: ["phone": phone, "url": url], api_endpoint: Endpoints.bank_account, method: .delete, custom_endpoint: nil, completion: completion)
}

func set_default_account(phone: String, url: String) {
    make_api_call(parameters: ["phone": phone, "url": url], api_endpoint: Endpoints.default_account, method: .put, custom_endpoint: nil, completion: nil)
}

func get_accounts(phone: String, completion: @escaping ((Result<Any>) -> Void)) {
    make_api_call(parameters: ["phone": phone], api_endpoint: Endpoints.bank_account, method: .get, custom_endpoint: nil, completion: completion)
}

func put_funding_source(token: String, account_id: String, phone: String, name: String, institution_name: String, completion: ((Result<Any>) -> Void)? = nil) {
    let parameters = ["phone" : phone, "account_id" : account_id, "token" : token, "name": name, "institution_name": institution_name]
    make_api_call(parameters: parameters, api_endpoint: Endpoints.bank_account, method: .put, custom_endpoint: nil, completion: completion)
}

func post_delete_transaction(parameters: [String: String], completion: ((Result<Any>) -> Void)? = nil) {
    make_api_call(parameters: parameters, api_endpoint: Endpoints.delete_transaction, method: .get, custom_endpoint: nil, completion: completion)
}

func post_settle_transaction(parameters: [String: String], completion: ((Result<Any>) -> Void)? = nil) {
    make_api_call(parameters: parameters, api_endpoint: Endpoints.settle_transaction, method: .get, custom_endpoint: nil, completion: completion)
}

func update_email(parameters: [String: String], completion: @escaping ((Result<Any>) -> Void)) {
    make_api_call(parameters: parameters, api_endpoint: Endpoints.update_email, method: .put, custom_endpoint: nil, completion: completion)
}

func put_transaction(parameters: [String: String], completion: @escaping ((Result<Any>) -> Void)) {
    make_api_call(parameters: parameters, api_endpoint: Endpoints.add_transaction, method: .put, custom_endpoint: nil, completion: completion)
}

//Get list of users
func get_users(completion: ((Result<Any>) -> Void)? = nil) {
    make_api_call(parameters: [:], api_endpoint: Endpoints.users_list, method: .get, custom_endpoint: nil, completion: completion)
}

//Get list of users
func get_users_search(search: String, completion: ((Result<Any>) -> Void)? = nil) {
    make_api_call(parameters: ["search": search], api_endpoint: Endpoints.users_list, method: .get, custom_endpoint: nil, completion: completion)
}

//Get list of users
func get_users_phone(phone: String, completion: ((Result<Any>) -> Void)? = nil) {
    make_api_call(parameters: ["phone": phone], api_endpoint: Endpoints.users_list, method: .get, custom_endpoint: nil, completion: completion)
}

func create_user(phone: String, password: String, email: String, name: String, address: String, city: String, state: String, zip: String, birthdate: Date, ssn: String, completion: ((Result<Any>) -> Void)? = nil) {
    let parameters = ["phone" : phone, "password" : password, "email" : email, "name" : name, "street": address, "city": city, "state": state, "zip": zip, "ssn": ssn, "birthdate": birthdate.as_string(format: .birthdate)]
    make_api_call(parameters: parameters, api_endpoint: Endpoints.add_user, method: .put, custom_endpoint: nil, completion: completion)
}

func get_transaction(parameter: [String: String], completion: ((Result<Any>) -> Void)? = nil) {
    make_api_call(parameters: parameter, api_endpoint: Endpoints.get_transaction, method: .get, custom_endpoint: nil, completion: completion)
}

fileprivate func make_api_call(parameters: [String: String], api_endpoint: String?, method: HTTPMethod, custom_endpoint: String? = nil, completion: ((Result<Any>) -> Void)? = nil) {
    let headers = ["x-api-key" : Dracker_API_KEY]
    let endpoint = custom_endpoint == nil ? api_endpoint: custom_endpoint
    var encoding: ParameterEncoding = URLEncoding.default
    if method == .put {
        encoding = URLEncoding(destination: .queryString)
    }
    Alamofire.request(endpoint!, method: method, parameters: parameters, encoding:  encoding, headers: headers).responseJSON { response in
        completion?(response.result)
    }
}


//MARK: Image Search API

func search_images_call(search_term: String, completion: ((Result<Any>) -> Void)? = nil)  {
    Alamofire.request(External_Endpoints.image_search, method: .get, parameters: ["q" : search_term], encoding:  URLEncoding.default, headers: ["Ocp-Apim-Subscription-Key" : Search_Key]).responseJSON { response in
        completion?(response.result)
    }
}


func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        completion(data, response, error)
        }.resume()
}

//MARK: S3
func upload_to_S3(key: String, data: NSURL, bucket: AWSConstants) {
    let request = AWSS3TransferManagerUploadRequest()
    request?.bucket = bucket.rawValue
    request?.body = data as URL
    request?.key = key
    request?.contentType = "image/jpeg"
    request?.acl = .publicRead
    let client = AWSS3TransferManager.default()
    client.upload(request!)
}

