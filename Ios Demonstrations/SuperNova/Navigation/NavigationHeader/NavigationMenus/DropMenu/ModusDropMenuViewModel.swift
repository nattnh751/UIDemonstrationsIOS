//
//  ModusDropMenuViewModel.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 7/1/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol ModusDropMenuControllerDelegate {
  var navigationActions: Observable<[ModusNavigationType]> { get }
}

class ModusDropMenuViewModel {
  private let navigations = BehaviorRelay<[ModusNavigationType]>(value: [])
  let disposeBag = DisposeBag()
  let actions : [ModusNavigationType]
  
  init(items : [ModusNavigationType]) {
    self.actions = items
    syncData()
  }
  
  func syncData() {
    navigations.accept(actions)
  }
  
}
// view model extension implementing the callback methods for the view controller
extension ModusDropMenuViewModel : ModusDropMenuControllerDelegate {
  // this is where the actual logic navigation from controller to coordinator happens "navBarPlusClicked" is an example of that
  var navigationActions: Observable<[ModusNavigationType]> {
    get {
      return navigations.asObservable()
    }
  }
}
