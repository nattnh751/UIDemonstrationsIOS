//
//  CategoryViewModel.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 6/22/21.
//

import Foundation
import RxSwift
import RxCocoa

enum CategoryType : Equatable {
  
  case normal(cellViewModel: CategoryViewModel)
  case error(message: String)
  case empty
  
  static func == (lhs: CategoryType, rhs: CategoryType) -> Bool { // equatable in case we wanted them to be unique to gartment names but that wasn't required so I skipped it
    if let leftViewModel = getCategoryViewModelOrNil(type: lhs) {
      if let rightViewModel = getCategoryViewModelOrNil(type: rhs) {
        if(leftViewModel.parentCategory.categoryIdValue == rightViewModel.parentCategory.categoryIdValue) {
          return true
        }
      }
    }
    return false
  }
  
  //helper function to make getting the viewmodel easier if this view model is in error
  public static func getCategoryViewModelOrNil(type : CategoryType) -> CategoryViewModel? {
    switch type {
    case .normal(let viewmodel):
      return viewmodel //this returns every item except for the item that needs to be updated and re added
    case .error(_):
      return nil
    case .empty:
      return nil
    }
  }
}

protocol CategoryViewModelControllerDelegate { //stuff that is used by the view controller should be declared here, anything else should be fileprivate in the actual class definition
  //data
  var items: Observable<[CategoryOrMediaType]> { get }

}

class CategoryViewModel {
  var parentCategory : ModusCategory
  private let medias = BehaviorRelay<[CategoryOrMediaType]>(value: [])
  let disposeBag = DisposeBag()

  init(parent : ModusCategory) {
    self.parentCategory = parent
    syncData()
  }
  
  let categorySort = {(item1: ModusCategory, item2: ModusCategory) -> Bool in
    return item1.indexValue < item2.indexValue
  }
  
  func syncData() {
    // load cells from core data into the behavior relay
    if let observer = self.getMediasAsObservable() {
      observer.subscribe(
        onNext: { [weak self] medias in
          guard medias.count > 0 else {
            self?.medias.accept([.empty])
              return
          }
          if let nilSAfeSelf = self {
            nilSAfeSelf.medias.accept(nilSAfeSelf.mapToCell(medias)) //need to add a view model
          }
        },
        onError: { [weak self] error in
          self?.medias.accept([.error(message: "Loading subitems failed, check database")])
        }).disposed(by: disposeBag)
    }
  }
  
  func mapToCell(_ items : [Any]) -> [CategoryOrMediaType] {
    return items.compactMap {
      if let cat = $0 as? ModusCategory {
        return .normal(cellViewModel: CategoryOrMediaViewModel(med: nil, cat: cat))
      } else {
        if let media = $0 as? Media {
          return .normal(cellViewModel: CategoryOrMediaViewModel(med: media, cat: nil))
        } else {
          return .error(message: "unroceognized object")
        }
      }
    }
  }
  
  func getMediasAsObservable() -> Observable<[Any]>? {
    var medias = self.parentCategory.mediasList
    medias?.append(contentsOf: Array(self.parentCategory.subcategories.sorted(by: self.categorySort)))
    if let finalItems = medias {
      return Observable.create { observer -> Disposable in
        observer.onNext(finalItems)
        return Disposables.create()
      }
    }
    return nil
  }
}
// view model extension implementing the callback methods for the view controller
extension CategoryViewModel : CategoryViewModelControllerDelegate { // this is where the actual logic navigation from controller to coordinator happens "navBarPlusClicked" is an example of that
  var items: Observable<[CategoryOrMediaType]> {
    get {
      return medias.asObservable()
    }
  }
}
