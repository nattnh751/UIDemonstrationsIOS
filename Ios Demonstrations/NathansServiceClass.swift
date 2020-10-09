//
//  NathansServiceClass.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/29/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import Foundation
import AFNetworking
import AVFoundation

@objc class NathansService : NSObject{
  @objc static let shared = NathansService()
  let operationManager =  AFHTTPSessionManager()
  let API_KEY = "e168d3304469432dacc33cdd825aed1e"
  let CAT_API_KEY = "d51fe67b-2b3d-4bbf-a2f1-38bd1bf1702e"
  override init(){}
  
  @objc func getRecipes( query : String, cusines : [String]?, diets :[String]?, intolerances : [String]?, returnBlock: @escaping ((URLSessionDataTask, Any?) -> Void)) {
    var params: [String: Any] = [:]
    params["query"] = query
    if(cusines != nil && cusines!.count > 0) {
      params["cuisine"] = cusines!.map{$0}.joined(separator: ",")
    }
    if(diets != nil && diets!.count > 0) {
      params["diet"] = diets!.map{$0}.joined(separator: ",")
    }
    if(intolerances != nil && intolerances!.count > 0) {
      params["intolerances"] = intolerances!.map{$0}.joined(separator: ",")
    }
    params["apiKey"] = API_KEY
    params["addRecipeInformation"] = "true"

    operationManager.get("https://api.spoonacular.com/recipes/complexSearch", parameters: params, headers: nil, progress: nil, success:returnBlock) { task, error in
      print(error)
    }
  }
  @objc func getRecipes( query : String, returnBlock: @escaping ((URLSessionDataTask, Any?) -> Void)) {
    self.getRecipes(query: query, cusines: nil, diets: nil, intolerances: nil, returnBlock: returnBlock)
  }
}
