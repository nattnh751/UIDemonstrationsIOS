//
//  ModusDropMenuTableViewCell.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 7/1/21.
//

import UIKit

class ModusDropMenuTableViewCell: UITableViewCell {
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var icon: UIImageView!
  
  @IBOutlet weak var notificationLabel: UILabel!
  var model : ModusNavigationViewModel? {
    didSet {
      setUpFromViewModel()
    }
  }
  func setUpFromViewModel() {
    if let drawerItem = model {
      title!.text = drawerItem.localizedTitle()
//      if let ic = drawerItem.icon {
//        icon.image = ic
//      }
    }
  }
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

    
}
