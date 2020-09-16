//
//	MashTemp.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import Mapper


struct MashTemp : Mappable{

	var duration : Int?
	var temp : BoilVolume?

  init(map: Mapper) throws {

    duration = map.optionalFrom("duration")
    temp = map.optionalFrom("temp")
    
  }

}
