//
//  File.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 3/20/20.
//

import Foundation
extension BasicDevConsoleWebViewer {
//  
//  func saveJsonBlob(data :NSDictionary) {
//    guard let successID : String = data.object(forKey: "successMethodId") as? String else {
//    showMalformedQueryParamWarning()
//    return
//    }
//    
//    
//    if let resource = self.resource {
//      
//      if let obj = data.object(forKey: "data") as? NSDictionary {
//        if let newJsonString = obj.object(forKey: "value") as? String {
//          resource.requiredJson = newJsonString
//        }
//      }
//       do {
//         var err = try AppDataRoomService.sharedInstance().uiContext?.save();
//       } catch {
//         showMalformedQueryParamWarning()
//       }
//       self.webView.evaluateJavaScript(String(format:"window.%@(%@);", successID, ""), completionHandler: nil)
//    } else {
//       self.error(data: data);
//    }
//  }
//  
//  func localize(data :NSDictionary) {
//    guard let successID : String = data.object(forKey: "successMethodId") as? String else {
//      showMalformedQueryParamWarning()
//      return
//    }
//    guard let localizeKey = data.object(forKey: "data") as? String else {
//      showMalformedQueryParamWarning()
//      return
//    }
//    self.webView.evaluateJavaScript(String(format:"window.%@('%@');", successID, (AppDataRoomService.sharedInstance()?.session.selectedLanguage.localize(localizeKey)) ?? ""), completionHandler: nil)
//  }
//  
//  func getJsonBlob(data :NSDictionary) {
//    guard let successID : String = data.object(forKey: "successMethodId") as? String else {
//      showMalformedQueryParamWarning()
//      return
//    }
//   if let resource = self.resource {
//      addOtherMessageToDevLog(resource.requiredJson);
//      self.webView.evaluateJavaScript(String(format:"window.%@(JSON.stringify(%@));", successID, resource.requiredJson), completionHandler: nil)
//    } else {
//       self.error(data: data);
//    }
//  }
//  func isConnected(data :NSDictionary) {
//     guard let successID : String = data.object(forKey: "successMethodId") as? String else {
//       showMalformedQueryParamWarning()
//       return
//     }
//    if(AFNetworkReachabilityManager.shared().isReachable) {
//        self.webView.evaluateJavaScript(String(format:"window.%@(JSON.stringify(%@));", successID, "1"), completionHandler: nil);
//    } else {
//         self.webView.evaluateJavaScript(String(format:"window.%@(JSON.stringify(%@));", successID, "0"), completionHandler: nil);
//    }
//  }
//  func getAccount(data :NSDictionary) {
//    guard let successID : String = data.object(forKey: "successMethodId") as? String else {
//      showMalformedQueryParamWarning()
//      return
//    }
//    let account = AppDataRoomService.sharedInstance().session.selectedAccount;
//    if(account != nil) {
//      let sendie = ["id": account?.accountId,
//                    "subdomain": account?.subdomain,
//                    "settings": account?.settingsDictionary]
//      self.webView.evaluateJavaScript(String(format:"window.%@(%@);", successID, JSONStringify(value: sendie)), completionHandler: nil);
//    } else {
//      self.error(data: data)
//    }
//  }
//  func getUser(data :NSDictionary) {
//    guard let successID : String = data.object(forKey: "successMethodId") as? String else {
//      showMalformedQueryParamWarning()
//      return
//    }
//    let user = AppDataRoomService.sharedInstance().session.userDictionary as! NSDictionary
//    let sendie = ["id": user["users_id"],
//                  "first_name": user["first_name"],
//                  "last_name": user["last_name"],
//                  "email": user["email"],
//                  "alt_email": user["alt_email"]]
//    self.webView.evaluateJavaScript(String(format:"window.%@(%@);", successID, JSONStringify(value: sendie)), completionHandler: nil);
//  }
//  func error(data: NSDictionary) {
//      guard let errorID : String = data.object(forKey: "errorMethodId") as? String else {
//        showMalformedQueryParamWarning()
//        return
//      }
//      self.webView.evaluateJavaScript(String(format:"window.%@(%@);", errorID, ""), completionHandler: nil)
//  }
//  func previewMedia(data: NSDictionary) {
//    if(AFNetworkReachabilityManager.shared().isReachable) {
//      guard let successID : String = data.object(forKey: "successMethodId") as? String else {
//        showMalformedQueryParamWarning()
//        return
//      }
//      guard let params :NSDictionary =  data.object(forKey: "data") as? NSDictionary else {
//        showMalformedQueryParamWarning()
//        return
//      }
//      guard let url :String = params.object(forKey: "url") as? String else {
//        showMalformedQueryParamWarning()
//        return
//      }
//      let newWebViewer = BasicDevConsoleWebViewer()
//      newWebViewer.urlToDisplay = url
//      let holder = UINavigationController.init(rootViewController: newWebViewer)
//      self.present(holder, animated: true, completion: nil)
//      self.webView.evaluateJavaScript(String(format:"window.%@(%@);", successID, ""), completionHandler: nil)
//    } else {
//      let offlineWarning = UIAlertController(title: "Your device is not connected to the internet.", message: "", preferredStyle: .alert);
//      offlineWarning.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
//        self.dismiss(animated: true) {
//        }
//      }));
//      self.present(offlineWarning,animated:true);
//      self.error(data: data)
//    }
//  }
//  func addMediaTo(data :NSDictionary) {
//    guard let successID : String = data.object(forKey: "successMethodId") as? String else {
//      showMalformedQueryParamWarning()
//      return
//    }
//    guard let params :NSDictionary =  data.object(forKey: "data") as? NSDictionary else {
//      showMalformedQueryParamWarning()
//      return
//    }
//    guard let medId :String = params.object(forKey: "mediaId") as? String else {
//      showMalformedQueryParamWarning()
//      return
//    }
//    guard let title :String = params.object(forKey: "title") as? String else {
//      showMalformedQueryParamWarning()
//      return
//    }
//    guard let optionalURL :String = params.object(forKey: "url") as? String else {
//      showMalformedQueryParamWarning()
//      return
//    }
//    
//    let followup = AppDataRoomService.sharedInstance().session.selectedAccount!.selectedContentGroup!.followup
//    var media = Media.fetch(byId: Int32(medId) ?? 0, from: AppDataRoomService.sharedInstance()?.uiContext)
//    if(media != nil) {
//      followup?.addMediasObject(media)
//    } else {
//      let newGenericFollowupItem = ["id": medId,
//                                    "title": title,
//                                    "url": optionalURL]
//      followup?.addGenericItem(newGenericFollowupItem)
//    }
//    self.webView.evaluateJavaScript(String(format:"window.%@(%@);", successID, ""), completionHandler: nil)
//    let followupadded = UIAlertController(title: "Item has been added to the followup.", message: "", preferredStyle: .alert);
//    followupadded.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
//      self.dismiss(animated: true) {
//      }
//    }));
//    self.present(followupadded,animated:true);
//  }
//  func httpRequest(data :NSDictionary) {
//
//    guard let successID : String = data.object(forKey: "successMethodId") as? String else {
//      showMalformedQueryParamWarning()
//      return
//    }
//    guard let errorID : String = data.object(forKey: "errorMethodId") as? String else {
//      showMalformedQueryParamWarning()
//      return
//    }
//    guard let params :NSDictionary =  data.object(forKey: "data") as? NSDictionary else {
//      showMalformedQueryParamWarning()
//      return
//    }
//    guard let url :String =  params.object(forKey: "url") as? String else {
//      showMalformedQueryParamWarning()
//      return
//    }
//    addOtherMessageToDevLog("calling   :" + url)
//    guard let verb :String =  params.object(forKey: "verb") as? String else {
//      showMalformedQueryParamWarning()
//      return
//    }
//    guard let body :String =  params.object(forKey: "body") as? String else {
//      showMalformedQueryParamWarning()
//      return
//    }
//    let request : AsyncHttpRequest = AsyncHttpRequest.insert(in: AppDataRoomService.sharedInstance().uiContext) as! AsyncHttpRequest;
//    request.url = url;
//    request.verb = verb;
////    request.body = body
//
//    let temp = body.data(using: .utf8)!
//    do {
//      let jsonArray : Any? = try JSONSerialization.jsonObject(with: temp, options : [])
//      request.body = jsonArray
//    } catch let error as NSError {
//      print(error)
//    }
//    do {
//      var err = try AppDataRoomService.sharedInstance().uiContext?.save();
//    } catch {
//      
//    }
//    if(AFNetworkReachabilityManager.shared().isReachable) {
//      let waiting : UIAlertController = UIAlertController(title: "waiting", message: "", preferredStyle: .actionSheet)
//      waiting.show(self, sender: nil)
//      DispatchQueue.global(qos: .userInitiated).async {
//        AppDataRoomService.sharedInstance()?.postGenericRequest({error,object in
//          DispatchQueue.main.async {
//            if(error != nil) {
//              //if errors tell the console and start the async task to try again
//              self.webView.evaluateJavaScript(String(format:"window.%@(%@);", errorID, ""), completionHandler: nil);
//            } else {
//              self.webView.evaluateJavaScript(String(format:"window.%@(JSON.stringify(%@));", successID, self.JSONStringify(value: object)), completionHandler: nil);
//            }
//            waiting.dismiss(animated: false, completion: nil)
//          }
//        },with: request);
//      }
//    } else {
//      AppDataRoomService.sharedInstance()?.postGenericAsyncRequests(nil);
//    }
//  }
//  func asyncHttpRequest(data :NSDictionary) {
//    guard let successID : String = data.object(forKey: "successMethodId") as? String else {
//      showMalformedQueryParamWarning()
//      return
//    }
//    guard let params :NSDictionary =  data.object(forKey: "data") as? NSDictionary else {
//      showMalformedQueryParamWarning()
//      return
//    }
//    let url  : String = params.object(forKey: "url") as! String;
//    let verb : String = params.object(forKey: "verb") as! String;
//    let body = params.object(forKey: "body");
//    let request : AsyncHttpRequest = AsyncHttpRequest.insert(in: AppDataRoomService.sharedInstance().uiContext) as! AsyncHttpRequest;
//    request.url = url;
//    request.verb = verb;
//    request.body = body;
//    do {
//      var err = try AppDataRoomService.sharedInstance().uiContext?.save();
//    } catch {
//      
//    }
//    self.webView.evaluateJavaScript(String(format:"window.%@(%@);", successID, ""), completionHandler: nil);
//    AppDataRoomService.sharedInstance()?.postGenericAsyncRequests(nil);
//  }
//  func openLink(data :NSDictionary) {
//   guard let params :NSDictionary =  data.object(forKey: "data") as? NSDictionary else {
//     showMalformedQueryParamWarning()
//     return
//   }
//   let url  : String = params.object(forKey: "url") as! String;
//    guard let successID : String = data.object(forKey: "successMethodId") as? String else {
//      showMalformedQueryParamWarning()
//      return
//    }
//   guard let linkUrl = URL(string: url) else {
//     return
//   }
//   UIApplication.shared.open(linkUrl)
//
//   self.webView.evaluateJavaScript(String(format:"window.%@(%@);", successID,""), completionHandler: nil);
//  }

}
