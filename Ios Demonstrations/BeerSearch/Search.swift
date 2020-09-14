//
//  Search.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/14/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class Search: UIViewController {
  var shownCities = [String]() // Data source for UITableView
  let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"] // Our mocked API data source
  let disposeBag = DisposeBag() // Bag of disposables to release them when view is being deallocated
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    searchBar
    .rx.text // Observable property thanks to RxCocoa
    .orEmpty // Make it non-optional
    .subscribe(onNext: { [unowned self] query in // Here we will be notified of every new value
        self.shownCities = self.allCities.filter { $0.hasPrefix(query) } // We now do our "API Request" to find cities.
        self.tableView.reloadData() // And reload table view data.
    }).disposed(by: disposeBag)
  }


}

extension Search : UITableViewDelegate,UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shownCities.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "cityPrototypeCell", for: indexPath)
         cell.textLabel?.text = shownCities[indexPath.row]
         
         return cell
  }
}
