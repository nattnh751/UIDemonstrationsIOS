//
//  BasicDevConsoleWebViewer+WebBundleLoading.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 3/12/20.
//

import Foundation
extension BasicDevConsoleWebViewer {
  func load(_ path : String) {
    let fileUrl = URL.init(fileURLWithPath: path);
    let paths :NSArray = FileManager().urls(for: .documentDirectory, in:  .userDomainMask) as NSArray;
    let readAccessUrl :URL = paths.firstObject as! URL;
    var components = URLComponents.init(url: fileUrl, resolvingAgainstBaseURL: false);
    let additionalResourceRootPath :NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray;
    let directory :NSString = additionalResourceRootPath.object(at: 0) as! NSString;
    let additionalResourcePath = directory.appendingPathComponent("/additionalResources/")
    var runningQuery : String = ""
    runningQuery = String(format:"os=ios&resourcePath=%@", additionalResourcePath)
    components!.query = runningQuery;
    DispatchQueue.main.async {
      print("appointments url \(String(describing: components?.url))");
      self.webView.loadFileURL(components?.url as! URL, allowingReadAccessTo: readAccessUrl);
    }
  }
}
