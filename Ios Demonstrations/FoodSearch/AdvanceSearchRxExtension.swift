//
//  AdvanceSearchRxExtension.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/24/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Moya
import Moya_ModelMapper
import RxOptional

extension AdvancedSearchViewController {
  var latestSearchText : Observable<String>  {
    return self.searchBar
        .rx.text
        .orEmpty
        .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        .distinctUntilChanged()
  }
  @objc func executeSearch() {
    let provider: MoyaProvider<FoodSearch> = MoyaProvider<FoodSearch>()
    let disposeBag = DisposeBag()
    let foods = provider.rx.request(FoodSearch.getFoodWithQuery(self.searchBar.text ?? "")).map(to: FoodQueryResult.self).asObservable()
    foods.flatMap { item -> Observable<[SimpleRecipe]> in
      return Observable.from(optional: item.results)
    }.bind(to: self.resultsCollectionView.rx.items) { (collectionView, row, element) in
      let indexPath = IndexPath(row: row, section: 0)
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "*", for:indexPath) as? SearchCollectionViewCell {
        cell.titleView.text = element.title
        return cell
      } else {
        let fail = collectionView.dequeueReusableCell(withReuseIdentifier: "*", for: indexPath)
         return fail
      }
   }.disposed(by: disposeBag)
  }
  @objc func setupRx() {
    let disposeBag = DisposeBag()
    let provider: MoyaProvider<FoodSearch> = MoyaProvider<FoodSearch>()
    let foods = latestSearchText.observeOn(MainScheduler.instance).flatMapLatest { name -> Observable<FoodQueryResult> in

        DispatchQueue.main.async {
          if(self.resultsCollectionView.alpha == 0) {
            self.resultsCollectionView.alpha = 0;
            UIView.animate(withDuration: 0.15) {
              self.resultsCollectionView.alpha = 1
              self.clearButton.isHidden = true
            }
            self.searchButton.isSelected = true
          }
        }

      return provider.rx.request(FoodSearch.getFoodWithQuery(name)).map(to: FoodQueryResult.self).asObservable()
      }
    foods.flatMapLatest { item -> Observable<[SimpleRecipe]> in
      return Observable.from(optional: item.results)
    }.bind(to: self.resultsCollectionView.rx.items) { (collectionView, row, element) in
      let indexPath = IndexPath(row: row, section: 0)
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "*", for:indexPath) as? SearchCollectionViewCell {
        cell.titleView.text = element.title
        return cell
      } else {
        let fail = collectionView.dequeueReusableCell(withReuseIdentifier: "*", for: indexPath)
         return fail
      }
   }.disposed(by: disposeBag)
 }
//       .disposed(by: self.disposeBag)
//     tableView
//         .rx.itemSelected
//         .subscribe(onNext: { indexPath in
//          beers.subscribe(onNext: { beers in
//            let thisBeer = beers[indexPath.row]
//            let beervc = BeerViewer(beer: thisBeer)
//            self.present(beervc, animated: true) {
//              if self.searchBar.isFirstResponder == true {
//                  self.view.endEditing(true)
//              }
//            }
//          })
//         })
//      .disposed(by: disposeBag)
  
}
