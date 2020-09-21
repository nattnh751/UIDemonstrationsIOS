//
//	Beer.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import Mapper


struct Beer : Mappable{

	var abv : Float? //Main
	var attenuationLevel : Int?// Brew tab
	var boilVolume : BoilVolume?// Brew tab
	var brewersTips : String?// Brew tab
	var contributedBy : String?// Brew tab
  var descriptionField : String? // Main
	var ebc : Int?// Main
	var firstBrewed : String?// Brew tab
	var foodPairing : [String]? //Pair
	var ibu : Int? // Main
	var id : Int?
	var imageUrl : String? // Main
	var ingredients : Ingredient? // Brew tab
	var method : Method? // Brew tab
	var name : String? // Main
	var ph : Float? // Main
	var srm : Int? // Main
	var tagline : String? // Main
	var targetFg : Int?// Brew tab
	var targetOg : Int?// Brew tab
	var volume : BoilVolume?// Brew tab
  
  init(map: Mapper) throws {
      abv = map.optionalFrom("abv")
      attenuationLevel = map.optionalFrom("attenuation_level")
      boilVolume = map.optionalFrom("boil_volume")
      brewersTips = map.optionalFrom("brewers_tips")
      contributedBy = map.optionalFrom("contributed_by")
      descriptionField = map.optionalFrom("description")
      ebc = map.optionalFrom("ebc")
      firstBrewed = map.optionalFrom("first_brewed")
      foodPairing = map.optionalFrom("food_pairing")
      ibu = map.optionalFrom("ibu")
      id = map.optionalFrom("id")
      imageUrl = map.optionalFrom("image_url")
      ingredients = map.optionalFrom("ingredients")
      method = map.optionalFrom("method")
      name = map.optionalFrom("name")
      ph = map.optionalFrom("ph")
      srm = map.optionalFrom("srm")
      tagline = map.optionalFrom("tagline")
      targetFg = map.optionalFrom("target_fg")
      targetOg = map.optionalFrom("target_og")
      volume = map.optionalFrom("volume")
  }

	

}
