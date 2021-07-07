//
//  ModusNavigationController.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 6/29/21.
//

import Foundation

protocol ModusNavigationControllerDelegate: class {
  func rootViewControllerDidTapDrawerButton(_ rootViewController: ModusNavigationController)
  func rootViewControllerDidTapDropButton(_ rootViewController: ModusNavigationController)
}

@objc class ModusNavigationController: UINavigationController, UINavigationControllerDelegate {
  fileprivate var drawerButton: UIBarButtonItem!
  fileprivate var dropButton: UIBarButtonItem!

  weak var drawerDelegate: ModusNavigationControllerDelegate?
  weak var mainViewController: UIViewController?
  var menuController : NavigationMenuController?
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.mainViewController = topViewController
  }

  @objc public init(mainViewController: UIViewController) {
    self.mainViewController = mainViewController
    super.init(rootViewController: mainViewController)
  }

  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.mainViewController = topViewController
  }
  
  func drawerListItems() -> [ModusNavigationType] {
    var items : [ModusNavigationType] = [
      .normal(cellViewModel: ModusNavigationViewModel(controller:Notifications(), localizationKey: "Notifications", icon: UIImage(named:"notification-bell"), notificationCount: ADRNotification.fetchUnread(AppDataRoomService.sharedInstance().uiContext).count))
    ]
    let hasFeedbackUrl = SettingsManager.string(forKey: "feedbackUrl") != nil
    let hasFeedbackItem = AdditionalResource.fetch(in: AppDataRoomService.sharedInstance().uiContext, withKey: "FeedbackFormURL") != nil
    if(hasFeedbackUrl || hasFeedbackItem) {
      //this is going to need to change, maybe to a popover?
      items.append(.normal(cellViewModel: ModusNavigationViewModel(controller:Feedback(), localizationKey: "Feedback", icon: UIImage(named:"notification-bell"), notificationCount: nil)))
    }
    return items
  }
  
  func dropListItems() -> [ModusNavigationType] {
    var items : [ModusNavigationType] = [
      .normal(cellViewModel: ModusNavigationViewModel(controller:Library(nibName: "CombinedHeaderMenu-iPhone", bundle: nil), localizationKey: "Collections", icon: UIImage(named:"notification-bell"), notificationCount: 0)),
    ]
    // need to always append the top vc to the list so you can get back to it
    if let image = self.tabBarItem.image {
      if let key = (self.tabBarItem as? LanguageTabBarItem)?.keyText {
        if let topvc = self.topViewController {
          items.insert(.normal(cellViewModel: ModusNavigationViewModel(controller:topvc, localizationKey: key, icon: image, notificationCount: nil)), at: 0)
        }
      }
    }
    return items
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    bindNavigationHeader()
  }
  
  public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    prepareNavigationBar()
  }
  
  func createMenuController() {
    menuController = NavigationMenuController(rootViewController: self, drawerItems: drawerListItems(), dropItems: dropListItems())
    self.addChild(menuController!)
    menuController!.view.clipsToBounds = true
    view.addSubview(menuController!.view)
    menuController!.didMove(toParent: self)
    self.view.sendSubviewToBack(menuController!.view)
    self.viewControllers.reverse()
  }
  
  fileprivate func createHeaderMenuButtons() {
    if(drawerButton == nil) {
      drawerButton = UIBarButtonItem(image:UIImage(named: "hamburger-menu-icon"), style: .plain, target: self, action: #selector(handleDrawerButton))
    }
    if(dropButton == nil) {
      if let tabBarItem = self.tabBarItem as? LanguageTabBarItem { //
        dropButton = UIBarButtonItem(title: AppDataRoomService.sharedInstance()?.session.selectedLanguage.localize(tabBarItem.keyText) ?? "", style: .plain, target: self, action: #selector(handleDropButton))
      }
    }
  }
  
  func bindNavigationHeader() {
    createMenuController()
    createHeaderMenuButtons()
  }
}

extension ModusNavigationController {
    func prepareNavigationBar() {
      topViewController?.navigationItem.title = topViewController?.title
      if(self.viewControllers.count <= 2) { //two because one is the drawer menu and the other is the top view controller
        topViewController?.navigationItem.leftBarButtonItem = drawerButton
        if(dropListItems().count > 1) {
          topViewController?.navigationItem.rightBarButtonItem = dropButton
        }
      }
    }
}

extension ModusNavigationController {
  @objc
  func handleDrawerButton() {
      drawerDelegate?.rootViewControllerDidTapDrawerButton(self)
  }
  @objc
  func handleDropButton() {
      drawerDelegate?.rootViewControllerDidTapDropButton(self)
  }
}

//navigation overrides
extension ModusNavigationController {
  override func popViewController(animated: Bool) -> UIViewController? {
    if(topViewController != mainViewController) {
      return super.popViewController(animated: animated)
    }
    return nil
  }
  
  override func popToRootViewController(animated: Bool) -> [UIViewController]? {
    if let main = mainViewController {
      return self.popToViewController(main, animated: true)
    } else {
      return super.popToRootViewController(animated: animated)
    }
  }
  
  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    if let drawer = menuController {
      drawer.closeAll()
    }
    super.pushViewController(viewController, animated: animated)
  }
  
  func swapMainViewControllerWith(_ viewModel : ModusNavigationViewModel) {
    if let drawer = menuController {
      drawer.closeAll()
    }
    let viewController = viewModel.controller
    var mutVcs = self.viewControllers.filter { $0 is NavigationMenuController }
    mutVcs.append(viewController)
    self.viewControllers = mutVcs
    dropButton.title = viewModel.localizedTitle()
    self.mainViewController = viewController
  }
}

//navigation helpers for use by all view controllers, this should be extracted to a coordinator some day
extension ModusNavigationController {
  func logout() {
    print("loging user out")
    AppDataRoomService.sharedInstance().deauthenticate(nil)
  }
  func open(_ link: URL) {
    print("open link : " + link.absoluteString)
    UIApplication.shared.open(link)
  }
  
  func push(_ category: ModusCategory) {
    if let categoryViewController = getViewerFor(category) {
      self.pushViewController(categoryViewController, animated: true)
    }
  }
  
  func push(_ media: Media) {
    print("presenting new media view controller")
  }
  
  func getViewerFor(_ category : ModusCategory) -> UIViewController? {
    if let _ = category.vpt {
      Tracker.trackCategoryView(category)
      self.showVptWith(cat: category)
      return nil;
    }
    
    if(category.medias.count == 1 && category.subcategories.count == 0 && SettingsManager.bool(forKey: "autoviewSingleItemInCategory")) {
      if let media = category.mediasList.first as? Media {
        push(media)
        return nil;
      }
    }
    
    let categoryVC = CombinedCategoryMenu.init(nibName: "CombinedMenu", bundle: nil)
    categoryVC.category = category
    return categoryVC
  }
  
  func showVptWith(cat category : ModusCategory) {
    
  }
}
