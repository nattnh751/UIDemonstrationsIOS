//
//  FirstViewController.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/12/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import UIKit

class MainMenu: UIViewController {
  var wheel :KCRotaryWheel? = nil;

  override func viewDidLoad() {
    super.viewDidLoad()
    self.refreshWheel()
  }

  func refreshWheel() {
    var frame = CGRect(x: 0, y: 0, width: 600, height: 600)
    if(UI_USER_INTERFACE_IDIOM() == .phone) {
      frame = CGRect(x: 0, y: 35, width: 375, height: 375)
    }
    if(wheel == nil) {
      wheel = KCRotaryWheel(frame: frame, del: self, sectionsNumber: 6, categories: NSArray())
    }
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
//      wheel = [[KCRotaryWheel new] initWithFrameWithFrame:CGRectMake(0, 35, 375, 375) del:self sectionsNumber:6 categories:[tempItems copy]];
//      wheel.categoryWasClicked = ^(CGFloat categoryId) {
//        Category *c;
//        c = [Category fetchById:categoryId fromContext:[AppDataRoomService sharedInstance].uiContext];
//        [self pushCategory:c];
//      };
//      [self.imageSplash addSubview:wheel];
//    } else {
//      wheel = [[KCRotaryWheel new] initWithFrameWithFrame:CGRectMake(0, 0, 600, 600) del:self sectionsNumber:6 categories:[tempItems copy]];
//      wheel.categoryWasClicked = ^(CGFloat categoryId) {
//        Category *c;
//        c = [Category fetchById:categoryId fromContext:[AppDataRoomService sharedInstance].uiContext];
//        [self pushCategory:c];
//      };
//      if(self.wheelView) {
//        [self.wheelView addSubview:wheel];
//      } else {
//        [self.imageSplash addSubview:wheel];
//      }
//    }
  }
}

