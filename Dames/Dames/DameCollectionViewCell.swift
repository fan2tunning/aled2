//
//  DameCollectionViewCell.swift
//  Dames
//
//  Created by Eric Le Maître on 25/05/2018.
//  Copyright © 2018 Eric Le Maître. All rights reserved.
//

import UIKit

class DameCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      layer.borderColor = UIColor.black.cgColor
      layer.borderWidth = 2.0
    }
}
