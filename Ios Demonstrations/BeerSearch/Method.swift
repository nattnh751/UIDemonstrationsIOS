//
//	Method.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import Mapper


struct Method : Mappable {

	var fermentation : Fermentation?
	var mashTemp : [MashTemp]?
	var twist : String?

  init(map: Mapper) throws {

		fermentation = map.optionalFrom("fermentation")
		mashTemp = map.optionalFrom("mash_temp")
		twist = map.optionalFrom("twist")
		
	}

}
