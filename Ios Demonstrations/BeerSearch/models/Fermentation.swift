//
//	Fermentation.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import Mapper


struct Fermentation : Mappable{

	var temp : BoilVolume?

  init(map: Mapper) throws {

    temp = map.optionalFrom("temp")
    
  }
	
}
