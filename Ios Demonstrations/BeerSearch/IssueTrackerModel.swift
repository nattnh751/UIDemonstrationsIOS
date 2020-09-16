//
//  IssueTrackerModel.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/15/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift
 
public struct IssueTrackerModel {
    
  let provider = MoyaProvider<GitHub>()
  private static let shared = IssueTrackerModel()
  init() {}

//  internal func findIssues(repository: Repository) -> Single<[Issue]> {
//           return provider
//           .rx
//            .request(GitHub.issues(repositoryFullName: "(repository.url?)!"))
//           .filterSuccessfulStatusCodes()
//           .debug()
//            .map(to: [Issue].self)
//         
//  }
//  
  func findRepository(repository: String) -> Single<User> {
    return provider.rx.request(GitHub.repo(repository)).map(to: User.self, keyPath: "owner")

  }
//  
//  func trackIssues() -> Observable<[Issue]> {
//    return repositoryName
//        .observeOn(MainScheduler.instance)
//        .flatMapLatest { name -> Observable<Repository> in
//            print("Name: \(name)")
//          return self.findRepository(repository: name)
//        }
//        .flatMapLatest { repository -> Observable<[Issue]> in
//            print("Repository: \(repository.fullName)")
//            return self.findIssues(repository: repository)
//          
//    }.catchErrorJustReturn([])
//  }
}
