//
//  CategoryOrMediaCollectionViewCell.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 6/23/21.
//

import UIKit

class CategoryOrMediaCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var image: UIImageView!

  var viewModel: CategoryOrMediaViewModel? {
      didSet {
          bindViewModel()
      }
  }
  
  private func bindViewModel() {
    //binds view model to the view
    if let model = viewModel {
      // this might need to be re thought out in the future for easier addition of new item types
      if let media = model.media {
        createMediaCell(media)
      }
      if let category = model.category {
        createCategoryCell(category)
      }
    }
  }
  
  func createMediaCell(_ media : Media) {
    title?.text = media.title;
    if let thumb = MediaHelper.thumb(for: media) {
      image.image = thumb
    } else {
      // have to set to nil so that the recycled collection view cell doesn't show the wrong thumbnail
      image.image = nil
      print("thumb not found")
    }
  }
  
  func createCategoryCell(_ category : ModusCategory) {
    title?.text = category.title;
    image.image = nil
    self.backgroundColor = .lightGray
  }
}
