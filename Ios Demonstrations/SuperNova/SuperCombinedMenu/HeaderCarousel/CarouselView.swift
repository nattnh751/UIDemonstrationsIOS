  //
//  CarouselView.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 6/25/21.
//

import UIKit
import RxSwift
import RxCocoa
  
protocol CarouselViewDelegate {
  func openLink(_ link : URL)
}
  
class CarouselView: UIView {
  let kCONTENT_XIB_NAME = "CarouselView"
  private var indexOfCellBeforeDragging = 0
  @IBOutlet weak var carouselCollectionView: UICollectionView!
  @IBOutlet var contentView: UIView!
  let delegate : CarouselViewDelegate?
  let disposeBag = DisposeBag()
  @IBOutlet weak var pageControl : UIPageControl!
  var itemsObservable : Observable<[CarouselItem]>? {
    didSet {
      setupFromCarouselItem()
    }
  }
  init(frame: CGRect, del : CarouselViewDelegate) {
    self.delegate = del
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.delegate = nil
    super.init(coder: aDecoder)
    commonInit()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    jumpToCellAt(0, scrollView: self.carouselCollectionView, xVelocity: 5.0)
  }

  func commonInit() {
    Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
    contentView.fixInView(self)
  }
  
  func setupFromCarouselItem() {
    if let items = itemsObservable {
      self.carouselCollectionView.register(UINib(nibName: "CarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "carouselCollectionViewCellID")
      self.carouselCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast
      self.carouselCollectionView.delegate = nil
      self.carouselCollectionView.dataSource = nil
      items.bind(to: self.carouselCollectionView.rx.items(cellIdentifier: "carouselCollectionViewCellID", cellType: CarouselCollectionViewCell.self)) { index, element, cell in
          cell.item = element
          cell.delegate = self.delegate
        }.disposed(by: disposeBag)
      self.carouselCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
      addPagingToCollection()
    }
  }
}

//below is the functions designed to assist in always landing on a full cell when the user scrolls and adjusts the cell size
extension CarouselView : UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.frame.width, height: self.frame.height)
  }

  private func indexOfMajorCell() -> Int {
    let itemWidth = collectionView(carouselCollectionView, layout: carouselCollectionView.collectionViewLayout, sizeForItemAt: IndexPath(item: 0, section: 0)).width
      let proportionalOffset = carouselCollectionView.contentOffset.x / itemWidth
      let index = Int(round(proportionalOffset))
      let numberOfItems = carouselCollectionView.numberOfItems(inSection: 0)
      let safeIndex = max(0, min(numberOfItems - 1, index))
      return safeIndex
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
      indexOfCellBeforeDragging = indexOfMajorCell()
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
      targetContentOffset.pointee = scrollView.contentOffset
      let indexOfMajorCell = self.indexOfMajorCell()
      
      // calculate conditions:
      let dataSourceCount = carouselCollectionView.numberOfItems(inSection: 0)
      let swipeVelocityThreshold: CGFloat = 0.5
      let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < dataSourceCount && velocity.x > swipeVelocityThreshold
      let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
      let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
      let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
      
      if didUseSwipeToSkipCell {
        // this needs to work better, ideally it will snap to further cells depending on how quick the velocity is
        let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
        jumpToCellAt(snapToIndex, scrollView: scrollView, xVelocity: velocity.x)
      } else {
        jumpToCellAt(indexOfMajorCell, scrollView: scrollView, xVelocity: velocity.x)
      }
  }
  
  func jumpToCellAt(_ index : Int, scrollView view: UIScrollView, xVelocity x : CGFloat) {
    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: x, options: .allowUserInteraction, animations: {
      let indexPath = IndexPath(row: index, section: 0)
      self.carouselCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }) { done in
      self.pageControl.currentPage = index
    }
  }
}

//pagination extension
extension CarouselView {
  func addPagingToCollection() {
    self.carouselCollectionView.isPagingEnabled = true
    pageControl.numberOfPages = carouselCollectionView.numberOfItems(inSection: 0)
    pageControl.hidesForSinglePage = true
  }
  
  @IBAction func pageControlUpdate(_ sender: Any) {
    jumpToCellAt(pageControl.currentPage, scrollView: carouselCollectionView, xVelocity: 5.0)
  }
}
  
extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
