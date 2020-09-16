//
//	Ingredient.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import Mapper


struct Ingredient : Mappable{

	var hops : [Hop]?
	var malt : [Malt]?
	var yeast : String?

  init(map: Mapper) throws {
      hops = map.optionalFrom("hops")
      malt = map.optionalFrom("malt")
      yeast = map.optionalFrom("yeast")
  }

}
