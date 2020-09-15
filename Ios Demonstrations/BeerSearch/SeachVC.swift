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
    var provider: MoyaProvider<GitHub>!
  var latestRepositoryName: Observable<String> {
        return searchBar
            .rx.text
            .orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
  
  public override func viewDidLoad() {
      super.viewDidLoad()
    setupRx()
      tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "beerCell")
//      tableView.dataSource = self
    }
  func setupRx() {
    provider = MoyaProvider()
    
         // Here we tell table view that if user clicks on a cell,
         // and the keyboard is still visible, hide it
         tableView
             .rx.itemSelected
             .subscribe(onNext: { indexPath in
                 if self.searchBar.isFirstResponder == true {
                     self.view.endEditing(true)
                 }
             })
          .disposed(by: disposeBag)
  }
}

//extension SeachVC : UITableViewDelegate,UITableViewDataSource {
//  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return shownCities.count
//  }
//  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//     let cell = tableView.dequeueReusableCell(withIdentifier: "beerCell", for: indexPath)
//         cell.textLabel?.text = shownCities[indexPath.row]
//         return cell
//  }
//}
