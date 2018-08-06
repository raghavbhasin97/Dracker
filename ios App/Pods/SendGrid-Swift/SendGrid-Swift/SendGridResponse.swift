//
//  SendGridResponse.swift
//  SendGrid-Swift
//
//  Created by Anthony Picciano on 1/12/18.
//  Copyright © 2018 Anthony Picciano. All rights reserved.
//

import Foundation

// To parse the JSON, add this file to your project and do:
//
//   let sendGridResponse = SendGridResponse(json)!

import Foundation

public struct SendGridResponse: Codable {
    public let errors: [SGError]
}

public struct SGError: Codable {
    public let message: String
    public let field, help: String?
}

// MARK: Convenience initializers

extension SendGridResponse {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(SendGridResponse.self, from: data) else { return nil }
        self = me
    }
    
    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }
    
    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }
    
    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension SGError {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(SGError.self, from: data) else { return nil }
        self = me
    }
    
    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }
    
    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }
    
    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
