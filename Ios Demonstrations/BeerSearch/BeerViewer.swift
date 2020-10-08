//
//  BeerViewer.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/21/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import UIKit

class BeerViewer: UIViewController {
  @IBOutlet weak var beerName: UILabel!
  @IBOutlet weak var beerImage: UIImageView!
  @IBOutlet weak var beerDescription: UILabel!
  let beer : Beer?
  init(beer:Beer) {
    self.beer = beer
    super.init(nibName: "BeerViewer", bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.beer = nil
    super.init(coder: aDecoder)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    if let beerMe =  self.beer {
      self.beerName.text = beerMe.name
      let fileUrl = URL(string: beerMe.imageUrl ?? "")!
      self.beerImage.load(url:fileUrl, blur: false)
      self.beerDescription.text = beerMe.descriptionField ?? ""
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIImageView {
  func load(url: URL, blur: Bool) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
              if let image = UIImage(data: data) {
                  if(blur) {
                    if let blurredImage = image.blur(7.0) {
                      DispatchQueue.main.async {
                          self?.image = blurredImage
                      }
                    } else {
                      print("fail")
                    }
                  } else {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                  }
                } else {
                  print("fail")
                }
            } else {
              print("fail")
            }
        }
    }
}
