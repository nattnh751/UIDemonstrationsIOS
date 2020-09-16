//
//	Amount.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import Mapper


struct Amount : Mappable{

	var unit : String?
	var value : Float?


  init(map: Mapper) throws {

    unit = map.optionalFrom("unit")
    value = map.optionalFrom("value")
  }

   

}
