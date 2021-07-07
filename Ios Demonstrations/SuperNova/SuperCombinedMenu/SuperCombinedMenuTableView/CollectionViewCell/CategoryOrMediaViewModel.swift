//
//  CategoryOrMediaListObject.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 6/22/21.
//

import Foundation

enum CategoryOrMediaType  : Equatable {
  
  case normal(cellViewModel: CategoryOrMediaViewModel)
  case error(message: String)
  case empty
  
  static func == (lhs: CategoryOrMediaType, rhs: CategoryOrMediaType) -> Bool {
    let sameType = type(of: lhs) != type(of:rhs)
    if let leftViewModel = getCategoryOrMediaViewModelOrNil(type: lhs) {
      if let rightViewModel = getCategoryOrMediaViewModelOrNil(type: rhs) {
        if(sameType && (leftViewModel.getItemId() == rightViewModel.getItemId())) {
          return true
        }
      }
    }
    return false
  }
  
  public static func getCategoryOrMediaViewModelOrNil(type : CategoryOrMediaType) -> CategoryOrMediaViewModel? {
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

class CategoryOrMediaViewModel {
  var media : Media?
  var category : ModusCategory?
  
  init(med: Media?, cat : ModusCategory?) {
    self.media = med
    self.category = cat
  }
  
  func getItemId() -> Int {
    if let med = self.media {
      return Int( med.mediaIdValue)
    }
    if let cat = self.category {
      return Int(cat.categoryIdValue)
    }
    return 0
  }
  
}
