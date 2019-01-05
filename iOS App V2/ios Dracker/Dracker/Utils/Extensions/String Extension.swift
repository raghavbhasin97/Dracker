import Foundation
import Alamofire

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
    func toDate() -> Date {
        let format = DateFormatter()
        format.dateFormat = DateFormats.full.rawValue
        let date = format.date(from: self)
        return date!
    }
    
    func nameHandle() -> String {
        var handle = "@" + prefix(1).uppercased() + self.lowercased().dropFirst()
        handle = handle.replacingOccurrences(of: " ", with: "-")
        return handle
    }
    
}
