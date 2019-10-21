//
//  FirstViewController.swift
//  UIDemonstrations
//
//  Created by Nathan Walsh on 10/20/19.
//  Copyright © 2019 Nathan Walsh. All rights reserved.
//

import UIKit

class RotaryWheelViewController: UIViewController {
  var wheel : RotaryWheel? = nil
  var viewControllerItems : NSMutableArray = []

  @IBOutlet weak var wheelView: UIView!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  override func viewWillAppear(_ animated: Bool) {
    self.addWheel()
  }
  func addWheel() {
    if(viewControllerItems.count <= 0) {
      self.populateViewControllerArray();
    }
    wheel = RotaryWheel(frame: CGRect(x:0,y:35,width:375,height:375), del: self, sectionsNumber: 6, categories: viewControllerItems)
    wheel?.categoryWasClicked = { _ in
      
    }
    self.wheelView.addSubview(wheel ?? UIView())
  }
  func populateViewControllerArray() {
    viewControllerItems.add("Tag Controller")
    viewControllerItems.add("Tag Controller")
    viewControllerItems.add("Tag Controller")
    viewControllerItems.add("Tag Controller")
    viewControllerItems.add("Tag Controller")
    viewControllerItems.add("Tag Controller")
  }
}

