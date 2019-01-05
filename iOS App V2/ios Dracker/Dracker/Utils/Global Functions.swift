import Foundation

func getBody(params: [String: Any]) -> String? {
    let jsonData = try! JSONSerialization.data(withJSONObject: params)
    let jsonString = String(data: jsonData, encoding: .utf8)
    return jsonString
}

func generateUID() -> String{
   return UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
}
