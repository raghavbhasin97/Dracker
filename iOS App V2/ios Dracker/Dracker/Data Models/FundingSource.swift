import Foundation

struct FundingSource {
    var name: String
    var institution: String
    var url: String
    var isDefault: Bool
    
    init(source: [String: Any]) {
        self.name = source["name"] as! String
        self.institution = source["institution"] as! String
        self.url = source["url"] as! String
        self.isDefault = source["is_default"] as! Bool
    }
    
    init(name: String, institution: String, url: String, isDefault: Bool) {
        self.name = name
        self.institution = institution
        self.url = url
        self.isDefault = isDefault
    }
}
