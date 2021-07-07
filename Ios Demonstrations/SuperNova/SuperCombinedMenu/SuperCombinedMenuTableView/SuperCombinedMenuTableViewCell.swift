//
//  SuperCombinedMenuTableViewCell.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 6/22/21.
//

import UIKit
import RxCocoa
import RxSwift
protocol SuperCombinedMenuTableViewCellDelegate {
  func didSelectMedia(_ media : Media)
  func didSelectCategory(_ categoory : ModusCategory)
}
class SuperCombinedMenuTableViewCell: UITableViewCell {
  let disposeBag = DisposeBag()
  let collectionViewCellID: String = "cell";
  var hasInitializedCollectionView = false
  @IBOutlet weak var collectionView: UICollectionView!
  var viewModel: CategoryViewModel? {
      didSet {
          bindViewModel()
      }
  }
  var delegate: SuperCombinedMenuTableViewCellDelegate?
  
  private func bindViewModel() {
    //binds view model to the view
    if let model = viewModel {
      
      self.collectionView.register(UINib(nibName: "CategoryOrMediaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionViewCellID)
      self.collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
      self.collectionView.delegate = nil
      self.collectionView.dataSource = nil
      
      model.items.bind(to: self.collectionView.rx.items(cellIdentifier: collectionViewCellID, cellType: CategoryOrMediaCollectionViewCell.self)) { index, element, cell in
          switch element {
          case .normal(let vm):
            cell.viewModel = vm
          case .error(let message):
            print(message)
          case .empty:
            print("empty")
          }
        }.disposed(by: disposeBag)
      
      self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
      
      if(!hasInitializedCollectionView) {
        // stuff that should only happen once goes in here
        hasInitializedCollectionView = true
        self.setupModelSelected()
      }
    }
  }
  
  func setupModelSelected() {
    self.collectionView.rx.modelSelected(CategoryOrMediaType.self).subscribe(onNext: { item in
      switch item {
      case .normal(let vm):
        self.selectedView(vm)
      case .error(let message):
        print(message)
      case .empty:
        print("empty")
      }
    }).disposed(by: disposeBag)
  }
  
  func selectedView(_ viewModel :  CategoryOrMediaViewModel) {
    if let del = delegate {
      if let category = viewModel.category {
        del.didSelectCategory(category)
      }
      if let media = viewModel.media {
        del.didSelectMedia(media)
      }
    } else {
      print("Delegate not assigned for item actions");
    }
  }
}
extension SuperCombinedMenuTableViewCell : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 160, height: 91)
  }
}
