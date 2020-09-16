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
  var issueTrackerModel: IssueTrackerModel!

  var latestRepositoryName : Observable<String>  {
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
    provider = MoyaProvider<BeerSearch>()
    issueTrackerModel = IssueTrackerModel();
    let result = issueTrackerModel.findBeer(query: "")
//    provider.rx.request(BeerSearch.getBeer("Movember")).map(to: [Beer].self).subscribe { event in
//              switch event {
//              case .success(let user):
//                  print(user)
//              case .error(let error):
//                  print(error)
//              }
//      }

    latestRepositoryName
       .observeOn(MainScheduler.instance)
       .flatMapLatest { name -> Observable<[Beer]> in
           print("Name: \(name)")
         return self.provider.rx.request(BeerSearch.getBeer(name)).map(to: [Beer].self).asObservable()
       }.bind(to: tableView.rx.items) { tableView, row, item in
                                     let cell = tableView.dequeueReusableCell(withIdentifier: "beerCell", for: IndexPath(row: row, section: 0))
                                     cell.textLabel?.text = item.name

                                     return cell
                                 }
       .disposed(by: self.disposeBag)
    
//    observer.map { objects in
//      print(objects)
//    }
    //            print("Repository: \(repository.fullName)")
    //            return self.findIssues(repository: repository)
//      observer.bind(to: tableView.rx.items) { tableView, row, item in
//                   let cell = tableView.dequeueReusableCell(withIdentifier: "beerCell", for: IndexPath(row: row, section: 0))
//                   cell.textLabel?.text = item.fullName
//
//                   return cell
//               }
//              .disposed(by: disposeBag)
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
