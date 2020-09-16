//
//	Hop.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import Mapper


struct Hop : Mappable{

	var add : String?
	var amount : Amount?
	var attribute : String?
	var name : String?


  init(map: Mapper) throws {
		add = map.optionalFrom("add")
		amount = map.optionalFrom("amount")
		attribute = map.optionalFrom("attribute")
		name = map.optionalFrom("name")
		
	}

}
