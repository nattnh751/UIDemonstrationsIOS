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
    
  let provider: MoyaProvider<GitHub>
  let repositoryName: Observable<String>

  internal func findIssues(repository: Repository) -> Observable<[Issue]> {
    return self.provider
    .rx
    .request(GitHub.issues(repositoryFullName: repository.fullName))
    .filterSuccessfulStatusCodes()
    .debug()
    .map(to: Issue.self).asObservable().toArray().asObservable()
  }
  
  internal func findRepository(repository: String) -> Observable<Repository> {
    return self.provider
    .rx
    .request(GitHub.repo(fullName: repository))
    .filterSuccessfulStatusCodes()
    .debug()
    .map(to: Repository.self).asObservable()
  }

  func trackIssues() -> Observable<[Issue]> {
    return repositoryName
        .observeOn(MainScheduler.instance)
        .flatMapLatest { name -> Observable<Repository> in
            print("Name: \(name)")
          return self.findRepository(repository: "apple/swift")
        }
        .flatMapLatest { repository -> Observable<[Issue]> in
            print("Repository: \(repository.fullName)")
            return self.findIssues(repository: repository)
          
      }.asObservable()
  }
}
