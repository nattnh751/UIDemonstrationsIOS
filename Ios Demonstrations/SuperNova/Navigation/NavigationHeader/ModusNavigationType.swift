//
//  ModusNavigationType.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 6/30/21.
//

import Foundation

enum ModusNavigationType : Equatable  {
  case normal(cellViewModel: ModusNavigationViewModel)
  case error(message: String)
  case empty
  
  static func == (lhs: ModusNavigationType, rhs: ModusNavigationType) -> Bool {
    let sameType = type(of: lhs) != type(of:rhs)
    if let leftViewModel = getModusNavigationViewModelOrNil(type: lhs) {
      if let rightViewModel = getModusNavigationViewModelOrNil(type: rhs) {
        if(sameType && (leftViewModel.localizationKey == rightViewModel.localizationKey)) {
          return true
        }
      }
    }
    return false
  }
  
  public static func getModusNavigationViewModelOrNil(type : ModusNavigationType) -> ModusNavigationViewModel? {
    switch type {
    case .normal(let viewmodel):
      return viewmodel
    case .error(_):
      return nil
    case .empty:
      return nil
    }
  }
}

class ModusNavigationViewModel {
  var controller : UIViewController
  var localizationKey : String
  var icon : UIImage?
  var selected = true
  var notificationCount = 0
  init(controller: UIViewController, localizationKey : String, icon : UIImage?, notificationCount: Int?) {
    self.controller = controller
    self.localizationKey = localizationKey
    self.icon = icon
    if let notifications = notificationCount {
      self.notificationCount = notifications
    }
  }
  
  func localizedTitle() -> String {
    return AppDataRoomService.sharedInstance()?.session.selectedLanguage.localize(localizationKey) ?? "Hiya Buddy"
  }
}
