//
//  SeachVC.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/14/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import Moya_ModelMapper
import RxOptional

public class SeachVC: UIViewController {
    let disposeBag = DisposeBag() // Bag of disposables to release them when view is being deallocated
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var provider: MoyaProvider<BeerSearch>!

  var latestRepositoryName : Observable<String>  {
    return searchBar
        .rx.text
        .orEmpty
        .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        .distinctUntilChanged()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "beerCell")
    setupRx()
  }
  
  func setupRx() {
    provider = MoyaProvider<BeerSearch>()
    let beers = latestRepositoryName
    .observeOn(MainScheduler.instance)
    .flatMapLatest { name -> Observable<[Beer]> in
      return self.provider.rx.request(BeerSearch.getBeer(name)).map(to: [Beer].self).asObservable()
    }
    beers.bind(to: tableView.rx.items) { tableView, row, item in
                                     let cell = tableView.dequeueReusableCell(withIdentifier: "beerCell", for: IndexPath(row: row, section: 0))
                                     cell.textLabel?.text = item.name
                                     return cell
                                 }
       .disposed(by: self.disposeBag)
     tableView
         .rx.itemSelected
         .subscribe(onNext: { indexPath in
          beers.subscribe(onNext: { beers in
            let thisBeer = beers[indexPath.row]
            let beervc = BeerViewer(beer: thisBeer)
            self.present(beervc, animated: true) {
              if self.searchBar.isFirstResponder == true {
                  self.view.endEditing(true)
              }
            }
          })
         })
      .disposed(by: disposeBag)
  }
}
