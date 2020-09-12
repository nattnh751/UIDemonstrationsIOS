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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.refreshWheel()
  }
  required init?(coder aDecoder: NSCoder) {
    var frame = CGRect(x: 0, y: 0, width: 600, height: 600)
    if(UIDevice.current.userInterfaceIdiom == .phone) {
      frame = CGRect(x: 0, y: 35, width: 375, height: 375)
    }
    self.wheel = KCRotaryWheel(frame: frame, sectionsNumber: 6, categories: NSArray())
    wheel.categoryWasClicked = { itemId in
      // push the item
    }
    super.init(coder: aDecoder)
    wheel.delegate = self
  }
  func refreshWheel() {
    if let container = self.wheelContainer {
      container.addSubview(wheel)
    }
  }
  func wheelDidChangeValue(_ newValue: String!) {
    
  }
}

