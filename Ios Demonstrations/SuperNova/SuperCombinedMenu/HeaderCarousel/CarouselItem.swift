//
//  CarouselItem.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 6/25/21.
//

import Foundation

struct CarouselItem {
  let image : UIImage
  let headerText: String
  let subText : String
  let firstButton : CarouselButton?
  let secondButton : CarouselButton?
  init(image : UIImage, headerText: String, subText: String, firstButton: CarouselButton?, secondButton: CarouselButton?) {
    self.image = image
    self.headerText = headerText
    self.subText = subText
    self.firstButton = firstButton
    self.secondButton = secondButton
  }
}

struct CarouselButton {
  let title : String
  let url : URL
  init(title : String, url : URL) {
    self.title = title
    self.url = url
  }
}
