//
//  SendGridEmail.swift
//  SendGrid-Swift
//
//  Created by Anthony Picciano on 1/12/18.
//  Copyright © 2018 Anthony Picciano. All rights reserved.
//

import Foundation

public struct SendGridEmail: Codable {
    let personalizations: [SGPersonalization]
    let from: SGAddress
    let replyTo: SGAddress?
    let subject: String
    let content: [SGContent]
    
    enum CodingKeys: String, CodingKey {
        case personalizations, from
        case replyTo = "reply_to"
        case subject, content
    }
    
    public init(personalizations: [SGPersonalization],
                from: SGAddress,
                replyTo: SGAddress? = nil,
                subject: String,
                content: [SGContent]) {
        self.personalizations = personalizations
        self.from = from
        self.replyTo = replyTo
        self.subject = subject
        self.content = content
    }
}

public enum SGContentType: String, Codable {
    case plain = "text/plain"
    case html = "text/html"
}

public struct SGContent: Codable {
    let type: SGContentType
    let value: String
    
    public init(type: SGContentType,
                value: String) {
        self.type = type
        self.value = value
    }
}

public struct SGAddress: Codable {
    let email: String
    let name: String?
    
    public init(email: String,
                name: String? = nil) {
        self.email = email
        self.name = name
    }
}

public struct SGPersonalization: Codable {
    let to: [SGAddress]
    let cc: [SGAddress]?
    let bcc: [SGAddress]?
    let subject: String?
    
    public init(to: [SGAddress],
                cc: [SGAddress]? = nil,
                bcc: [SGAddress]? = nil,
                subject: String? = nil) {
        self.to = to
        self.cc = cc
        self.bcc = bcc
        self.subject = subject
    }
}

// MARK: Convenience initializers

extension SendGridEmail {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(SendGridEmail.self, from: data) else { return nil }
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

extension SGContent {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(SGContent.self, from: data) else { return nil }
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

extension SGAddress {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(SGAddress.self, from: data) else { return nil }
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

extension SGPersonalization {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(SGPersonalization.self, from: data) else { return nil }
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

