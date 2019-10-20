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

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  override func viewWillAppear(_ animated: Bool) {
    self.addWheel()
  }
  func addWheel() {
    if(viewControllerItems == nil || viewControllerItems.count <= 0) {
      self.populateViewControllerArray();
    }
    wheel = RotaryWheel(frame: CGRect(x:0,y:0,width:300,height:300), del: self, sectionsNumber: 6, categories: viewControllerItems)

//    if([SettingsManager boolForKey:@"addCategoryWheelToMainMenu"] && !hasAddedWheel && self.items && self.items.count > 0) {
//       NSMutableArray *tempItems = [self.items mutableCopy];
//       bool noFirst = true;
//       NSMutableArray *without = [self.items mutableCopy];
//       [without removeObject:[without firstObject]];
//       NSMutableArray *with = [self.items mutableCopy];
//       while(tempItems.count < 36) {
//         if(noFirst) {
//           [tempItems addObjectsFromArray:without];
//           noFirst = false;
//         } else {
//           [tempItems addObjectsFromArray:with];
//           noFirst = true;
//         }
//       }
//       hasAddedWheel = YES;
//       if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
//         wheel = [[KCRotaryWheel new] initWithFrameWithFrame:CGRectMake(0, 35, 375, 375) del:self sectionsNumber:6 categories:[tempItems copy]];
//         wheel.categoryWasClicked = ^(CGFloat categoryId) {
//           Category *c;
//           c = [Category fetchById:categoryId fromContext:[AppDataRoomService sharedInstance].uiContext];
//           [self pushCategory:c];
//         };
//         [self.imageSplash addSubview:wheel];
//       } else {
//         wheel = [[KCRotaryWheel new] initWithFrameWithFrame:CGRectMake(0, 0, 600, 600) del:self sectionsNumber:6 categories:[tempItems copy]];
//         wheel.categoryWasClicked = ^(CGFloat categoryId) {
//           Category *c;
//           c = [Category fetchById:categoryId fromContext:[AppDataRoomService sharedInstance].uiContext];
//           [self pushCategory:c];
//         };
//         if(self.wheelView) {
//           [self.wheelView addSubview:wheel];
//         } else {
//           [self.imageSplash addSubview:wheel];
//         }
//       }
//     }
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

