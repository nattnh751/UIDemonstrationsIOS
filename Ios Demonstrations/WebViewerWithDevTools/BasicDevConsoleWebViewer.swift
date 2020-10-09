//
//  BasicDevConsoleWebViewer.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 3/13/19.
//

import Foundation
//
//  VirtualAssistantViewController.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 3/6/19.
//

import UIKit
import WebKit;

class BasicDevConsoleWebViewer: UIViewController , WKNavigationDelegate, WKScriptMessageHandler, UITableViewDelegate, UITableViewDataSource, WKUIDelegate {
  weak var webView: WKWebView!
  @IBInspectable var resourceKey: String? = nil
  var consoleMessageArray: NSMutableArray!
  var disableProgress: Bool = false
  var userController: WKUserContentController  = WKUserContentController()
  var videoSuccessId = ""
  var developerConsoleView: UITableView!
  var progressView: UIProgressView!
  var showDevConsoleButton: UIButton!
  var enableDevTools: Bool = false
  var clearDevConsoleButton: UIButton!
  @objc var urlToDisplay: String!
  var localPathToDisplay: String!
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  override func viewDidLoad() {
    super.viewDidLoad();
    userController = WKUserContentController();
    userController.add(self, name: "logging");
    userController.add(self, name: "vpt")
    userController.add(self, name: "assistant")
    userController.add(self, name: "modus")
    let configuration: WKWebViewConfiguration = WKWebViewConfiguration();
    configuration.userContentController = userController;
    configuration.websiteDataStore = WKWebsiteDataStore.default()
    configuration.allowsInlineMediaPlayback = false
    webView = WKWebView(frame: self.view.frame, configuration: configuration);
    webView.navigationDelegate = self;
    webView.uiDelegate = self;
    webView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
    webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    self.view.addSubview(webView);
    progressView = UIProgressView(progressViewStyle: .default)
    progressView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height ?? 45), width:  self.view.frame.size.width , height: progressView.frame.size.height)
    progressView.trackTintColor = .white
    progressView.progressTintColor = .black
    progressView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
    if(!self.disableProgress) {
      self.view.addSubview(progressView);
    }
    consoleMessageArray = NSMutableArray();
    let url = URL(string: urlToDisplay ?? "");
    if(localPathToDisplay != nil && localPathToDisplay != "") {
      let server :NSURL = NSURL(fileURLWithPath: localPathToDisplay);
      webView.load(NSURLRequest(url: server as URL) as URLRequest);
    } else {
      if(urlToDisplay != nil && urlToDisplay != "") {
        webView.load(URLRequest(url: url!));
      }
    }
    
    setNavBarButtonItems()
  }
  
  func setNavBarButtonItems() {
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action:#selector(close))
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBackWebView))
    if(urlToDisplay != nil && urlToDisplay != "") {
      self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(title: "Open In Safari", style: .plain, target: self, action: #selector(openUrlInSafari)))
    }
    self.navigationController?.navigationBar.tintColor = .black
    self.navigationController?.navigationBar.barTintColor = .white
  }
  @objc func  reload() {
    //  AppDataRoomService.sharedInstance()?.getAdditionalResources(((Error?) -> Void)?)( {_ in
    //    self.start();
    //  })
  }
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
      if keyPath == "estimatedProgress" {
          progressView.progress = Float(webView.estimatedProgress)
      }
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }

  override func viewWillAppear(_ animated: Bool) {
    initializeDeveloperModeView();
    setHeaderLogo();
    let margins = view.layoutMarginsGuide
       NSLayoutConstraint.activate([
          webView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
          webView.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
       ])
       if #available(iOS 11, *) {
         let guide = view.safeAreaLayoutGuide
         NSLayoutConstraint.activate([
           webView.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
           guide.bottomAnchor.constraint(equalToSystemSpacingBelow: webView.bottomAnchor, multiplier: 1.0)
          ])
       } else {
          let standardSpacing: CGFloat = 8.0
          NSLayoutConstraint.activate([
          webView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
          bottomLayoutGuide.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: standardSpacing)
          ])
       }
  }
  @objc func  dismissMe() {
    self.dismiss(animated: false, completion: nil);
  }
  @objc func  goBackWebView() {
    self.webView.goBack();
  }
  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//    print("HiyaBuddy "+error.localizedDescription);
    self.addOtherMessageToDevLog(error.localizedDescription);
    consoleMessageArray.add(error.localizedDescription);
    developerConsoleView.reloadData();
  }
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    consoleMessageArray.add("Started Loading Webpage");
    developerConsoleView.reloadData();
    progressView.isHidden = false
    print("Strat to load");
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    consoleMessageArray.add("Finished Loading Web Page");
    developerConsoleView.reloadData();
    let js = "console.log = function(){var msg = JSON.stringify(arguments); window.webkit.messageHandlers.logging.postMessage(msg) };"
    let errorjs = "console.error = function(){var msg = JSON.stringify(arguments); window.webkit.messageHandlers.logging.postMessage(msg) };"
    let error = "window.onerror = function(){var err = JSON.stringify(arguments); window.webkit.messageHandlers.logging.postMessage(err) };"
    // evaluate js to wkwebview
    webView.evaluateJavaScript(js, completionHandler: nil)
    webView.evaluateJavaScript(errorjs, completionHandler: nil)
    webView.evaluateJavaScript(error, completionHandler: nil)
    //    let userScript = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    //    contentController.addUserScript(userScript)
    progressView.isHidden = true
    print("finish to load")
  }
  
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
//    guard let urlStr :URL = navigationAction.request.url as URL? else {
//      decisionHandler(.cancel)
//      return
//    }
    decisionHandler(.allow)
  }

  func addOtherMessageToDevLog(_ message: String) {
    DispatchQueue.main.async {
      self.consoleMessageArray.add("App Log:  " + message);
      if(self.developerConsoleView != nil) {
        self.developerConsoleView.reloadData();
      }
    }
  }
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if(developerConsoleView != nil) {
      consoleMessageArray.add(message.body);
      developerConsoleView.reloadData();
    }
  }
  func setHeaderLogo() {

  }
  
  func showMalformedQueryParamWarning() {
    let offlineWarning = UIAlertController(title: "Unable to complete request.", message: "", preferredStyle: .alert);
    offlineWarning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
      self.dismiss(animated: true) {
      }
    }));
    self.present(offlineWarning,animated:true);
  }
  
  @objc func close() {
    self.dismiss(animated: true, completion: nil)
  }
  @objc func openUrlInSafari() {
    if let url = URL(string: urlToDisplay) {
        UIApplication.shared.open(url)
    }
  }
  
  /* Developer Mode Code Below!*/
  func initializeDeveloperModeView() {
    var initalHeight = 100.0
    if let navBarHeight = self.navigationController?.navigationBar.frame.size.height {
      initalHeight = Double(navBarHeight)
    }
    initalHeight += Double(UIApplication.shared.statusBarFrame.height)
    if(developerConsoleView == nil) {
      developerConsoleView = UITableView(frame: CGRect(x: self.view.frame.size.width/2, y: 0, width: self.view.frame.size.width/2, height: self.view.frame.size.height));
      developerConsoleView.backgroundColor = UIColor.black.withAlphaComponent(0.7);
      developerConsoleView.delegate = self;
      developerConsoleView.dataSource = self;
      self.webView.addSubview(developerConsoleView)
    }
    developerConsoleView.alpha = 0.0;
    if(showDevConsoleButton == nil) {
      showDevConsoleButton = UIButton(frame: CGRect(x: 5, y: initalHeight+10, width: 150, height: 25));

      showDevConsoleButton.setTitle("Developer Mode", for: UIControl.State.normal);
      showDevConsoleButton.backgroundColor = UIColor.white.withAlphaComponent(0.7);
      showDevConsoleButton.layer.cornerRadius = 5;
      showDevConsoleButton.setTitleColor(UIColor.black, for: UIControl.State.normal);
      showDevConsoleButton.addTarget(self, action: #selector(toggleDeveloperConsole), for: UIControl.Event.touchUpInside);
      self.webView.addSubview(showDevConsoleButton);
    }
    showDevConsoleButton.isHidden = !enableDevTools
    if(clearDevConsoleButton == nil) {
      clearDevConsoleButton = UIButton(frame: CGRect(x: 0, y: initalHeight+55, width: 150, height: 25));
      clearDevConsoleButton.setTitle("Clear", for: UIControl.State.normal);
      clearDevConsoleButton.backgroundColor = UIColor.white.withAlphaComponent(0.7);
      clearDevConsoleButton.setTitleColor(UIColor.black, for: UIControl.State.normal);
      clearDevConsoleButton.layer.cornerRadius = 5;
      clearDevConsoleButton.addTarget(self, action: #selector(clearDevConsole), for: UIControl.Event.touchUpInside);
      self.webView.addSubview(clearDevConsoleButton);
    }
    clearDevConsoleButton.isHidden = true;
  }
  @IBAction func clearDevConsole() {
    consoleMessageArray = NSMutableArray();
    developerConsoleView.reloadData();
  }
  @IBAction func toggleDeveloperConsole() {
    if(developerConsoleView.alpha == 0.0) {
      UIView.animate(withDuration: 0.5, animations: {
        self.developerConsoleView.alpha = 1.0;
      }, completion: nil);
    } else {
      UIView.animate(withDuration: 0.5, animations: {
        self.developerConsoleView.alpha = 0.0;
      }, completion: nil);
    }
    clearDevConsoleButton.isHidden = !(developerConsoleView.alpha>0);
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return consoleMessageArray.count;
  }
  
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    let message: NSString = consoleMessageArray!.object(at: indexPath.row) as! NSString;
    let fullmessage = UIAlertController(title: "Details", message: message as String, preferredStyle: .alert);
    fullmessage.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
      self.dismiss(animated: true) {
      }
    }));
    self.present(fullmessage,animated:true);
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell :UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "") ?? UITableViewCell();
    let message: NSString = consoleMessageArray!.object(at: indexPath.row) as! NSString;
    cell.textLabel!.text = message.capitalized;
    cell.backgroundColor = UIColor.white.withAlphaComponent(0.0);
    cell.textLabel?.textColor = UIColor.white;
    return cell;
  }
  
  func JSONStringify(value: Any, prettyPrinted: Bool = false) -> String {
    if(value == nil) {
      return "";
    }
    let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
    if JSONSerialization.isValidJSONObject(value) {
      do{
        let data = try JSONSerialization.data(withJSONObject: value, options: options)
        if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
//          print(string)
          return string as String
        }
      }catch {
        print("error")
        //Access error here
      }
      
    }
    return ""
  }
  func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
//    if (navigationAction.targetFrame?.isMainFrame) {
    if let url = navigationAction.request.url {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
//    }
    return nil
  }
}
 
