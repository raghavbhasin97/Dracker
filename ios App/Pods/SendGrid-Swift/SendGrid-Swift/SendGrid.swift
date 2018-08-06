//
//  SendGrid.swift
//  SendGrid-Swift
//
//  Created by Anthony Picciano on 1/12/18.
//  Copyright © 2018 Anthony Picciano. All rights reserved.
//

import Foundation

public struct SendGrid {
    
    private let apiKey: String
    private let mailSendURL = URL(string: "https://api.sendgrid.com/v3/mail/send")!
    
    public init(withAPIKey apiKey: String) {
        self.apiKey = apiKey
    }
    
    @discardableResult public func send(email: SendGridEmail, completion: @escaping ((SendGridResponse?, Error?) -> ())) -> URLSessionDataTask {
        var request = URLRequest(url: mailSendURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = email.jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var sendGridResponse: SendGridResponse?
            var responseError = error
            
            if let data = data {
                sendGridResponse = SendGridResponse(data: data)
            }
            
            if let errors = sendGridResponse?.errors, errors.count > 0, responseError == nil {
                let code = (response as? HTTPURLResponse)?.statusCode ?? 400
                responseError = NSError(domain: "SendGrid", code: code, userInfo: [NSLocalizedDescriptionKey: errors[0].message])
            }
            
            completion(sendGridResponse, responseError)
        }
        
        task.resume()
        
        return task
    }
    
}
