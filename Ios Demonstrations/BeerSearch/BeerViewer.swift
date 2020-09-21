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
  init(beer:Beer) {
    super.init(nibName: "BeerViewer", bundle: nil)
    self.beerName.text = beer.name
    let fileUrl = URL(string: beer.imageUrl ?? "")!
    self.beerImage.load(url:fileUrl)
    self.beerDescription.text = beer.descriptionField ?? ""
  }
  
  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  override func viewDidLoad() {
      super.viewDidLoad()
        
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
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
