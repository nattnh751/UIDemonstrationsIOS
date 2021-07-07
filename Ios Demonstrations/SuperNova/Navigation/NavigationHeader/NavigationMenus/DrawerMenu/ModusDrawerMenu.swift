//
//  ModusDrawerMenu.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 6/29/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol ModusDrawerMenuDelegate {
  func closeDrawer()
  func showViewController(_ viewController: UIViewController)
  func shouldShowNotificationIndicator(_ show: Bool)
}

class ModusDrawerMenu: UIViewController {
  var delegate : ModusDrawerMenuDelegate?
  var viewModel : ModusDrawerMenuViewModel?
  static let tableViewCellID: String = "navigationTableViewCell";
  let tableViewCellHeight: CGFloat = 50.0;
  @IBOutlet weak var settingsLabel: UIButton!
  @IBOutlet weak var helpCenterLabel: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var logoutLabel: UIButton!
  
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
      model.navigationActions.bind(to: tableView.rx.items(cellIdentifier: ModusDrawerMenu.tableViewCellID, cellType: NavigationActionTableViewCell.self)) { (_, element, cell) in
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
          self.delegate?.showViewController(vm.controller)
        case .error(let message):
          print(message)
        case .empty:
          print("empty")
        }
      }).disposed(by: disposeBag)
    }
  }
  
  @IBAction func doLogout(_ sender: Any) {
    if let navigator = self.navigationController as? ModusNavigationController {
      navigator.logout()
    }
  }
  @IBAction func showHelpCenter(_ sender: Any) {
    if let navigator = self.navigationController as? ModusNavigationController {
      if let url = URL(string: "https://support.gomodus.com/hc/en-us") {
        navigator.open(url)
      }
    }
  }
  
  @IBAction func showSettings(_ sender: Any) {
    self.delegate?.showViewController(Updates())
  }
  
  func setupTableView() {
    tableView.register(UINib(nibName: "NavigationActionTableViewCell", bundle: nil), forCellReuseIdentifier: ModusDrawerMenu.tableViewCellID)
    self.tableView.rowHeight = tableViewCellHeight
  }
  
  @IBAction func closeMenu(_ sender: Any) {
    if let del = delegate {
      del.closeDrawer()
    }
  }

}
