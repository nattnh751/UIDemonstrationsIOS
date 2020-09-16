//
//	Beer.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import Mapper


struct Beer : Mappable{

	var abv : Float?
	var attenuationLevel : Int?
	var boilVolume : BoilVolume?
	var brewersTips : String?
	var contributedBy : String?
	var descriptionField : String?
	var ebc : Int?
	var firstBrewed : String?
	var foodPairing : [String]?
	var ibu : Int?
	var id : Int?
	var imageUrl : String?
	var ingredients : Ingredient?
	var method : Method?
	var name : String?
	var ph : Float?
	var srm : Int?
	var tagline : String?
	var targetFg : Int?
	var targetOg : Int?
	var volume : BoilVolume?
  
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
