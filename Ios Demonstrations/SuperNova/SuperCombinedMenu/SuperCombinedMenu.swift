//
//  SuperCombinedMenu.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 6/22/21.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class SuperCombinedMenu: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet var headerContainer: UIView!
  
  let model : SuperCombinedMenuViewModel?
  let disposeBag = DisposeBag()
  static let tableViewCellID: String = "tableViewCell";
  let tableViewCellHeight: CGFloat = 110.0;
  var carousel : CarouselView?
  var dataSource : RxTableViewSectionedReloadDataSource<SectionModel<ModusCategory, CategoryType>>?
  
  @objc init() {
    self.model = SuperCombinedMenuViewModel()
    super.init(nibName: "SuperCombinedMenu", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.model = SuperCombinedMenuViewModel()
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    bindViewModel()
    bindView()
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if let car = carousel {
      car.setNeedsLayout()
      car.carouselCollectionView.reloadData()
    }
  }

  func bindView() {
    setupTableView()
    if let viewModel = model {
      carousel = CarouselView(frame: self.headerContainer.frame, del: self)
      carousel!.itemsObservable = viewModel.carouselItems
      carousel!.fixInView(self.headerContainer)
    }
  }
  
  func bindViewModel() {
    bindTableViewToViewModel()
    model?.syncData()
  }
  
  func getModusNavigationController() -> ModusNavigationController? {
    if let nav = self.navigationController as? ModusNavigationController {
      return nav
    }
    return nil
  }
  
  func bindTableViewToViewModel() {
    if let viewModel = model {
      self.tableView.delegate = nil
      self.tableView.dataSource = nil
      dataSource = RxTableViewSectionedReloadDataSource<SectionModel<ModusCategory, CategoryType>>(
          configureCell: { (_, tv, indexPath, element) in
            if let cell = tv.dequeueReusableCell(withIdentifier: SuperCombinedMenu.tableViewCellID) as? SuperCombinedMenuTableViewCell {
              cell.delegate = self
              switch element {
              case .normal(let vm):
                cell.viewModel = vm
              case .error(let message):
                print(message)
              case .empty:
                print("empty")
              }
              return cell
            }
            return tv.dequeueReusableCell(withIdentifier: SuperCombinedMenu.tableViewCellID) ?? UITableViewCell()
          }
      )
      viewModel.items.bind(to: tableView.rx.items(dataSource: dataSource!)).disposed(by: self.disposeBag)
      self.tableView.rx.setDelegate(self).disposed(by: disposeBag)

    }
  }
}

extension SuperCombinedMenu : UITableViewDelegate { // extension for initial view setup
  
  func setupTableView() {
    tableView.register(UINib(nibName: "SuperCombinedMenuTableViewCell", bundle: nil), forCellReuseIdentifier: SuperCombinedMenu.tableViewCellID)
    self.tableView.decelerationRate = UIScrollView.DecelerationRate.fast
    self.tableView.rowHeight = tableViewCellHeight
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    // this could alternately be accomplished with the datasource but seemed unnecessary for this use case
    // example : https://betterprogramming.pub/how-to-implement-uitableview-and-uicollectionview-with-rxdatasources-1afcd68729bf
    if let data = dataSource {
      return getSectionHeaderWith(title:data[section].model.title)
    }
    return nil
  }
  
  func getSectionHeaderWith(title tit : String) -> UIView{
    let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
    let label = UILabel()
    label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
    label.text = tit
    label.font = .boldSystemFont(ofSize: 16)
    label.textColor = .white
    headerView.backgroundColor = .black
    headerView.addSubview(label)
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
}

extension SuperCombinedMenu : SuperCombinedMenuTableViewCellDelegate {
  func didSelectMedia(_ media: Media) {
    if let navigator = self.getModusNavigationController() {
      navigator.push(media)
    }
  }
  func didSelectCategory(_ category: ModusCategory) {
    if let navigator = self.getModusNavigationController() {
      navigator.push(category)
    }
  }
}

extension SuperCombinedMenu : CarouselViewDelegate {
  func openLink(_ link: URL) {
    if let navigator = self.getModusNavigationController() {
      navigator.open(link)
    }
  }
}
