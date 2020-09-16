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

enum GitHub {
    case userProfile(username: String)
    case repos(username: String)
    case repo(fullName: String)
    case issues(repositoryFullName: String)
}

extension GitHub: TargetType {
  var headers: [String : String]? {
    return ["Content-Type": "application/json"]
  }
  
  var baseURL: URL { return URL(string: "https://api.github.com")! }
  var path: String {
      switch self {
      case .repos(let name):
          return "/users/\(name.URLEscapedString)/repos"
      case .userProfile(let name):
          return "/users/\(name.URLEscapedString)"
      case .repo(let name):
          return "/repos/\(name)"
      case .issues(let repositoryName):
          return "/repos/\(repositoryName)/issues"
      }
  }
  var method: Moya.Method {
      return .get
  }
  var parameters: [String: Any]? {
      return nil
  }
  var sampleData: Data {
      return Data()
  }
  var task: Task {
    return .requestPlain
  }
  var parameterEncoding: ParameterEncoding {
      return JSONEncoding.default
  }
}
