//
//  CarouselCollectionViewCell.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 6/25/21.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var headerTitle: UILabel!
  @IBOutlet weak var subTitle: UILabel!
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var firstButton: UIButton!
  @IBOutlet weak var secondButton: UIButton!
  var delegate : CarouselViewDelegate?
  var item : CarouselItem? {
    didSet {
      setupFromCarouselItem()
    }
  }

  override func awakeFromNib() {
      super.awakeFromNib()
  }
  
  @IBAction func firstButtonClicked(_ sender: Any) {
    if let courseData = item {
      if let buttonOne = courseData.firstButton {
        if let del = delegate {
          del.openLink(buttonOne.url)
        }
      }
    }
  }
  @IBAction func secondButtonClicked(_ sender: Any) {
    if let courseData = item {
      if let secondButton = courseData.secondButton {
        if let del = delegate {
          del.openLink(secondButton.url)
        }
      }
    }
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func setupFromCarouselItem() {
    if let carouselData = item {
      headerTitle!.text = carouselData.headerText
      subTitle!.text = carouselData.subText
      backgroundImage!.image = carouselData.image
      if let buttonOne = carouselData.firstButton {
        firstButton.isHidden = false
        firstButton.setTitle(buttonOne.title, for: .normal)
      } else {
        firstButton.isHidden = true
      }
      if let buttonTwo = carouselData.secondButton {
        secondButton.isHidden = false
        secondButton.setTitle(buttonTwo.title, for: .normal)
      } else {
        secondButton.isHidden = true
      }
    }
  }
}
