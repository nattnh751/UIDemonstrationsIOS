//
//  githubEndpoint.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/15/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import Foundation
import Moya

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

enum BeerSearch {
    case getBeer(String)
}

extension BeerSearch: TargetType {

    var baseURL: URL { return URL(string: "https://api.punkapi.com/v2/")! }
    var method: Moya.Method { return .get }
    var headers: [String : String]? { return nil }
    var task: Task { return .requestPlain }
  
//    var parameters: [String: Any]? {
//         switch self {
//
//         case .getBeer(let query):
//          return ["beer_name" : query]
//         }
//     }
  
    var path: String {
      return "beers"
        
    }
    
    var sampleData: Data {
        return Data()
    }
}
