//
//	Malt.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import Mapper


struct Malt : Mappable{

	var amount : Amount?
	var name : String?

  init(map: Mapper) throws {

    amount = map.optionalFrom("amount")
    name = map.optionalFrom("name")
    
  }
}
