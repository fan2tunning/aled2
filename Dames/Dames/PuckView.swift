//
//  PuckView.swift
//  Dames
//
//  Created by Eric Le Maître on 29/05/2018.
//  Copyright © 2018 Eric Le Maître. All rights reserved.
//

import UIKit

class PuckView: UIImageView {

  var position: IndexPath
  
  init(frame: CGRect, position: IndexPath) {
    self.position = position
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.position = IndexPath(row: 0, section: 0)
    super.init(coder: aDecoder)
  }
  
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
