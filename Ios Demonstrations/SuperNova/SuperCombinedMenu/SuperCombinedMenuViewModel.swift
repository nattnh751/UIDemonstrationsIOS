//
//  SuperCombinedMenuViewModel.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 6/22/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import CoreData

/*
 Protocol declarations used by viewcontroller and coordinator
 */
protocol SuperCombinedMenuViewModelControllerDelegate { //stuff that is used by the view controller should be declared here, anything else should be fileprivate in the actual class definition
  //data
  var items: Observable<[SectionModel<ModusCategory, CategoryType>]> { get }
  var carouselItems: Observable<[CarouselItem]> { get}

  // Events
  func syncData()
}

/*
  View Model Class Declaration
 */
class SuperCombinedMenuViewModel {

  private let categoryCells = BehaviorRelay<[SectionModel<ModusCategory, CategoryType>]>(value: [])
  private let carouselCells = BehaviorRelay<[CarouselItem]>(value: [])

  let disposeBag = DisposeBag()

  let categorySort = {(item1: SectionModel<ModusCategory, CategoryType>, item2: SectionModel<ModusCategory, CategoryType>) -> Bool in
    return item1.model.indexValue < item2.model.indexValue
  }
  
  func mapToCell(_ categories : [ModusCategory]) -> [SectionModel<ModusCategory, CategoryType>] {
    return categories.compactMap { SectionModel(model: $0, items: [.normal(cellViewModel: CategoryViewModel(parent: $0))]) }.sorted(by: self.categorySort)
  }
  
  func syncData() {
    // load cells from core data into the behavior relay
    if let observer = ModusCategory.getTopLevelCatsAsObservable(AppDataRoomService.sharedInstance().uiContext) {
      observer.subscribe(
        onNext: { [weak self] cats in
          guard cats.count > 0 else {
              self?.categoryCells.accept([])
              return
          }
          if let nilSAfeSelf = self {
            nilSAfeSelf.categoryCells.accept(nilSAfeSelf.mapToCell(cats))
          }
        },
        onError: { [weak self] error in
            self?.categoryCells.accept([])
        }).disposed(by: disposeBag)
    }
    if let carouselObserver = getCarouselCellsAsObservable() {
      carouselObserver.subscribe(
        onNext: { [weak self] carousels in
          self?.carouselCells.accept(carousels)
        },
        onError: { [weak self] error in
            self?.carouselCells.accept([])
        }).disposed(by: disposeBag)
    }
  }
  func getCarouselCellsAsObservable() -> Observable<[CarouselItem]>? {
    return Observable.create { observer -> Disposable in
      // this will switch to a database fetch
      let items = [
        CarouselItem(image: UIImage(named: "img0033")!, headerText: "Test Header One", subText: "This is a description that I am writing as a demonstration of a longer description for whatever this item may be", firstButton: CarouselButton(title: "Google", url: URL(string: "https://www.google.com")!), secondButton: nil),
        CarouselItem(image: UIImage(named: "img0033")!, headerText: "Test Header Two", subText: "This is a description that I am writing as a demonstration of a longer description for whatever this item may be", firstButton: CarouselButton(title: "Google", url: URL(string: "https://www.google.com")!), secondButton: nil),
        CarouselItem(image: UIImage(named: "img0033")!, headerText: "Test Header Three", subText: "This is a description that I am writing as a demonstration of a longer description for whatever this item may be", firstButton: CarouselButton(title: "Go Modus", url: URL(string: "https://www.gomodus.com")!), secondButton: CarouselButton(title: "Google", url: URL(string: "https://www.google.com")!))
      ]
      observer.onNext(items)
      return Disposables.create()
    }
  }
  
}

// view model extension implementing the callback methods for the view controller
extension SuperCombinedMenuViewModel : SuperCombinedMenuViewModelControllerDelegate {
  var items: Observable<[SectionModel<ModusCategory, CategoryType>]> {
    get {
      return categoryCells.asObservable()
    }
  }
  var carouselItems: Observable<[CarouselItem]> {
    get {
      return carouselCells.asObservable()
    }
  }
}

extension ModusCategory {
  static func getTopLevelCats( _ ctx : NSManagedObjectContext ) -> [ModusCategory]? {
    if let acc = AppDataRoomService.sharedInstance().session.selectedAccount {
      if let cats = acc.selectedContentGroup.rootCategories {
        let array = Array(cats) as! [AppDataRoom.ModusCategory]
        return array
      }
    }
    return nil
  }
  
  static func getTopLevelCatsAsObservable( _ ctx : NSManagedObjectContext ) -> Observable<[ModusCategory]>? {
    if let topLevelCategories = getTopLevelCats(ctx) {
      return Observable.create { observer -> Disposable in
        observer.onNext(topLevelCategories)
        return Disposables.create()
      }
    }
    return nil
  }
}
