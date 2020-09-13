//
//  FirstViewController.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/12/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import UIKit

class MainMenu: UIViewController, KCRotaryProtocol {
  
  var wheel :KCRotaryWheel;
  @IBOutlet weak var wheelContainer: UIView!
  
  required init?(coder aDecoder: NSCoder) {
    var frame = CGRect(x: 0, y: 0, width: 600, height: 600)
    if(UIDevice.current.userInterfaceIdiom == .phone) {
      frame = CGRect(x: 0, y: 35, width: 375, height: 375)
    }
    
    // This object list could easily replaced with a coredata fetch of an object, iterated over and insert with their titles and object ids.
    let objects = NSMutableArray()
    objects.add(WheelItem(title: "Search Demo", itemId: 1))
    objects.add(WheelItem(title: "Beer Api", itemId: 2))
    objects.add(WheelItem(title: "Nested Categories", itemId: 3))
    objects.add(WheelItem(title: "Twiddle Down Screen", itemId: 4))
    objects.add(WheelItem(title: "Web Bundle Demo", itemId: 5))
    objects.add(WheelItem(title: "Something else", itemId: 6))
    self.wheel = KCRotaryWheel(frame: frame, sectionsNumber: 6, categories: objects)
    super.init(coder: aDecoder)
    wheel.delegate = self
    wheel.categoryWasClicked = { itemId in
      // push the item
//      self.wheel.resetWheel()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.refreshWheel()
  }
  
  func refreshWheel() {
    if let container = self.wheelContainer {
      container.addSubview(wheel)
    }
  }
  func wheelDidChangeValue(_ newValue: String!) {
  }
}

