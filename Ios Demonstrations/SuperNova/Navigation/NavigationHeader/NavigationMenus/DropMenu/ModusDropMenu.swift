//
//  ModusDropMenuViewController.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 7/1/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol ModusDropMenuDelegate {
  func closeDrop()
  func insertViewController(_ viewController: ModusNavigationViewModel)
}

class ModusDropMenu: UIViewController {
  var delegate : ModusDropMenuDelegate?
  var viewModel : ModusDropMenuViewModel?
  static let tableViewCellID: String = "dropMenuTableViewCell";
  let tableViewCellHeight: CGFloat = 50.0;
  @IBOutlet weak var tableView: UITableView!
  
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    bindView()
    bindViewModel()
  }
  
  func bindView() {
    setupTableView()
  }
  
  func bindViewModel() {
    bindTableViewToViewModel()
    viewModel?.syncData()
  }
  
  func bindTableViewToViewModel() {
    if let model = viewModel {
      model.navigationActions.bind(to: tableView.rx.items(cellIdentifier: ModusDropMenu.tableViewCellID, cellType: ModusDropMenuTableViewCell.self)) { (_, element, cell) in
        switch element {
        case .normal(let viewModel) :
          cell.model = viewModel
          break
        case .error(message: let message):
          print(message)
          break
        case .empty:
          break
        }
      }.disposed(by: disposeBag)
      self.tableView.rx.modelSelected(ModusNavigationType.self).subscribe(onNext: { item in
        switch item {
        case .normal(let vm):
          self.delegate?.insertViewController(vm)
        case .error(let message):
          print(message)
        case .empty:
          print("empty")
        }
      }).disposed(by: disposeBag)
    }
  }

  func setupTableView() {
    tableView.register(UINib(nibName: "ModusDropMenuTableViewCell", bundle: nil), forCellReuseIdentifier: ModusDropMenu.tableViewCellID)
    self.tableView.rowHeight = tableViewCellHeight
  }
  
  @IBAction func closeMenu(_ sender: Any) {
    if let del = delegate {
      del.closeDrop()
    }
  }

}
