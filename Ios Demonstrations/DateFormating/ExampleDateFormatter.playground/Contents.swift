import UIKit

var str = "Hello, playground"

class DefaultDateFormatter: StaticDateFormatterInterface {
    static var value: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }()
}
 
struct Article : Decodable {
  var id : Int
  var title : String
  var createdAt : CustomDecodeableDate<DefaultDateFormatter>
  var source : String
  var description : String
  var favorite : Bool
  var heroImage : String
  var link : String
}
struct Articles : Codable {
  struct Article : Codable {
    var id : Int
    var title : String
    var createdAt : CustomDecodeableDate<DefaultDateFormatter>
    var source : String
    var description : String
    var favorite : Bool
    var heroImage : URL
    var link : URL
  }
  var articles : [Article]
}

if let path = Bundle.main.path(forResource: "articles", ofType: "json") {
  let jsonData = Data(contentsOf: URL(fileURLWithPath: path))
  let decoder = JSONDecoder()
  decoder.keyDecodingStrategy = .convertFromSnakeCase
  let object = try decoder.decode(Articles.self, from: jsonData)
  for art in object.articles {
    print(art.createdAt)
  }
}

func print(_ obj: CustomDecodeableDate<DefaultDateFormatter>) {
    switch obj {
    case .error(let error): print("Error: \(error)")
    case .value(let date): print("Value: \(date)")
    }
}
