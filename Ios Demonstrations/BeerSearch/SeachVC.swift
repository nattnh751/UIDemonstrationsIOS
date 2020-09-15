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

public class SeachVC: UIViewController {

   var shownCities = [String]() // Data source for UITableView
    let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"] // Our mocked API data source
    let disposeBag = DisposeBag() // Bag of disposables to release them when view is being deallocated
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
  public override func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "beerCell")
      tableView.dataSource = self
      searchBar
      .rx.text // Observable property thanks to RxCocoa
      .orEmpty // Make it non-optional
      .debounce(.milliseconds(500), scheduler: MainScheduler.instance) // Wait 0.5 for changes.
      .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
      .filter { !$0.isEmpty } // If the new value is really new, filter for non-empty query.
      .subscribe(onNext: { [unowned self] query in // Here we will be notified of every new value
          self.shownCities = self.allCities.filter { $0.hasPrefix(query) } // We now do our "API Request" to find cities.
          self.tableView.reloadData() // And reload table view data.
      }).disposed(by: disposeBag)
    }
}

extension SeachVC : UITableViewDelegate,UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shownCities.count
  }
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "beerCell", for: indexPath)
         cell.textLabel?.text = shownCities[indexPath.row]
         return cell
  }
}
