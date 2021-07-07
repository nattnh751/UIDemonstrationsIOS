//
//  DrawerMenu.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 6/29/21.
//

import Foundation
import UIKit

class NavigationMenuController: UIViewController, ModusNavigationControllerDelegate {
  var rootViewController: ModusNavigationController
  var isDrawerMenuExpanded: Bool = false
  var drawerMenuController: ModusDrawerMenu
  var isDropMenuExpanded: Bool = false
  var dropMenuController: ModusDropMenu
  let overlayView = UIView()
  let tabBarHeight : CGFloat = 65.0;
  
  init(rootViewController: ModusNavigationController, drawerItems : [ModusNavigationType], dropItems: [ModusNavigationType]) {
    self.rootViewController = rootViewController
    self.drawerMenuController = ModusDrawerMenu(nibName: "ModusDrawerMenu", bundle: nil)
    self.dropMenuController = ModusDropMenu(nibName: "ModusDropMenuViewController", bundle: nil)
    super.init(nibName: nil, bundle: nil)
    self.rootViewController.drawerDelegate = self
    self.drawerMenuController.delegate = self
    self.drawerMenuController.viewModel = ModusDrawerMenuViewModel(items: drawerItems) // this will probably need to be overriden by  by navigation controller down the road
    self.dropMenuController.delegate = self
    self.dropMenuController.viewModel = ModusDropMenuViewModel(items: dropItems) // this will probably need to be overriden by navigation controller down the road
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func addDrawerMenu() {
    self.drawerMenuController.view.frame = CGRect(x: 0, y: 0, width: 0, height: (self.view.bounds.height - tabBarHeight))
    self.drawerMenuController.view.alpha = 0.5
    
    self.drawerMenuController.view.clipsToBounds = true
    self.addChild(drawerMenuController)
    self.view.addSubview(drawerMenuController.view)
    drawerMenuController.didMove(toParent: self)
    
    configureGestures()
  }
  fileprivate func dropMenuYPosition() -> CGFloat {
    if let frame = self.navigationController?.navigationBar.frame {
      return frame.size.height + frame.origin.y
    }
    return 400.0
  }
  fileprivate func addDropMenu() {
    self.dropMenuController.view.frame = CGRect(x: 0, y: dropMenuYPosition(), width: self.view.bounds.width, height: self.view.bounds.height/2)
    self.dropMenuController.view.alpha = 0.5
    
    self.dropMenuController.view.clipsToBounds = true
    self.addChild(dropMenuController)
    self.view.addSubview(dropMenuController.view)
    dropMenuController.didMove(toParent: self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    overlayView.backgroundColor = .black
    overlayView.alpha = 0.5
    view.addSubview(overlayView)
    
    addDrawerMenu()
    addDropMenu()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    overlayView.frame = view.bounds
    let width: CGFloat = (isDrawerMenuExpanded) ? 321.0 : 0.0
    self.drawerMenuController.view.alpha = (self.isDrawerMenuExpanded) ? 1.0  : 0.5
    self.drawerMenuController.view.frame = CGRect(x: 0, y: 0, width: width , height: (self.view.bounds.height - tabBarHeight))
    let height: CGFloat = (isDropMenuExpanded) ?  self.view.bounds.height/2 : 0.0
    self.dropMenuController.view.alpha = (self.isDropMenuExpanded) ? 1.0  : 0.5
    self.dropMenuController.view.frame =  CGRect(x: 0, y:  dropMenuYPosition(), width: self.view.bounds.width, height:  height)
  }
  
  func toggleDrawerMenu() {
    isDrawerMenuExpanded = !isDrawerMenuExpanded
    let bounds = self.view.bounds
    if (self.isDrawerMenuExpanded) {
      self.rootViewController.view.bringSubviewToFront(self.view)
    }
    let width: CGFloat = (isDrawerMenuExpanded) ? 321.0 : 0.0
    UIView.animate(withDuration: 0.3, animations: {
      self.drawerMenuController.view.frame = CGRect(x: 0, y: 0, width: width, height: (bounds.height - self.tabBarHeight))
      self.drawerMenuController.view.alpha = (self.isDrawerMenuExpanded) ? 1.0 : 0.5
      self.overlayView.alpha = (self.isDrawerMenuExpanded) ? 0.5 : 0.0
    }) { (success) in
      if (!self.isDrawerMenuExpanded) {
        self.rootViewController.view.sendSubviewToBack(self.view)
      }
    }
  }
  func toggleDropMenu() {
    isDropMenuExpanded = !isDropMenuExpanded
    if (self.isDropMenuExpanded) {
      self.rootViewController.view.bringSubviewToFront(self.view)
    }
    let height: CGFloat = (isDropMenuExpanded) ?  self.view.bounds.height/2 : 0.0

    UIView.animate(withDuration: 0.3, animations: {
      self.dropMenuController.view.frame = CGRect(x: 0, y:  self.dropMenuYPosition(), width: self.view.bounds.width, height: height)
      self.dropMenuController.view.alpha = (self.isDropMenuExpanded) ? 1.0 : 0.5
      self.overlayView.alpha = (self.isDropMenuExpanded) ? 0.5 : 0.0
    }) { (success) in
      if (!self.isDropMenuExpanded) {
        self.rootViewController.view.sendSubviewToBack(self.view)
      }
    }
  }
  
  func configureGestures() {
    let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
    swipeLeftGesture.direction = .left
    overlayView.addGestureRecognizer(swipeLeftGesture)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOverlay))
    overlayView.addGestureRecognizer(tapGesture)
  }
  
  @objc fileprivate func didSwipeLeft() {
    toggleDrawerMenu()
  }
  func closeAll() {
    if(isDrawerMenuExpanded) {
      toggleDrawerMenu()
    }
    if(isDropMenuExpanded) {
      toggleDropMenu()
    }
  }
  @objc fileprivate func didTapOverlay() {
    closeAll()
  }
}

extension NavigationMenuController {
  func rootViewControllerDidTapDrawerButton(_ rootViewController: ModusNavigationController) {
    toggleDrawerMenu()
  }
  func rootViewControllerDidTapDropButton(_ rootViewController: ModusNavigationController) {
    toggleDropMenu()
  }
}

extension NavigationMenuController : ModusDrawerMenuDelegate {
  func closeDrawer() {
    toggleDrawerMenu()
  }
  
  func showViewController(_ viewController: UIViewController) {
    self.rootViewController.pushViewController(viewController, animated: true)
  }
  
  func shouldShowNotificationIndicator(_ show: Bool) {
    // show an indicator on the rootViewController left navigation bar item "menu"
  }
}
extension NavigationMenuController : ModusDropMenuDelegate {
  func closeDrop() {
    toggleDropMenu()
  }
  
  func insertViewController(_ viewModel: ModusNavigationViewModel) {
    //update the root view controller main vc
    rootViewController.swapMainViewControllerWith(viewModel)
  }
}
