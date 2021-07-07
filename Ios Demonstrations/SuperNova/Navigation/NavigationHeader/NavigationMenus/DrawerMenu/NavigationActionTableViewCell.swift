//
//  NavigationActionTableViewCell.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 6/30/21.
//

import UIKit

class NavigationActionTableViewCell: UITableViewCell {
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
      if(drawerItem.notificationCount > 0) {
        //show the notification indicator
        notificationLabel.isHidden = false
        notificationLabel!.text = String(drawerItem.notificationCount)
      } else {
        notificationLabel.isHidden = true
      }
      if let ic = drawerItem.icon {
        icon.image = ic
      }
    }
  }
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

    
}
