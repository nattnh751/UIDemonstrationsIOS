//
//  SearchCollectionViewCell.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/24/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var titleView: UILabel!
  @IBOutlet weak var name: UILabel!
  @IBOutlet var image: UIImageView!
  var imageUrl : String!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  @objc func setImage(url: String) {
    image.load(url: URL(string: url)!, blur: true)
  }
}


extension UIImage {
  func blur(_ ammount : CGFloat) -> UIImage? {
    guard let ciImage = CIImage(image: self) else {
      return nil
    }
    let blurFiler = CIFilter(name:"CIGaussianBlur")
    blurFiler?.setValue(ciImage, forKey: kCIInputImageKey)
    blurFiler?.setValue(ammount , forKey: kCIInputRadiusKey)
    guard let outputImage = blurFiler?.outputImage else {
      return nil
    }
    return UIImage(ciImage: outputImage)
  }
}
