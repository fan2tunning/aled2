//
//  Case.swift
//  Jeu de Dame
//
//  Created by MacOS Sierra on 25/05/2018.
//  Copyright © 2018 MacOS Sierra. All rights reserved.
//

import UIKit

class Case: UICollectionViewCell {
    
    @IBOutlet weak var imagePion: UIImageView!
    @IBOutlet weak var imageBackground: UIImageView!
    
    public func getBgColor() -> UIColor{
        return imagePion.backgroundColor!
    }
    
    func creationPlateau(indexPath : IndexPath){
        let column = indexPath.section
        let row = indexPath.row
        
        imagePion.layer.cornerRadius = frame.size.width / 2.0
        if (column % 2) == 0 {
            if (row % 2) == 0 {
                //back clair
                imageBackground.image = UIImage(named: "boisClair.jpeg")
                imagePion.backgroundColor = nil
            }
            else{
                //foncé
                imageBackground.image = UIImage(named: "boisFonce.jpeg")
                if (column <= 3) {
                    imagePion.backgroundColor = UIColor.black
                }
                else if (column >= 6){
                    imagePion.backgroundColor = UIColor.white
                }
                else{
                    imagePion.backgroundColor = nil
                }
            }
        }
        else{
            if (row % 2) == 0 {
                //back foncé
                imageBackground.image = UIImage(named: "boisFonce.jpeg")
                if (column <= 3) {
                    imagePion.backgroundColor = UIColor.black
                }
                else if (column >= 6){
                    imagePion.backgroundColor = UIColor.white
                }
                else{
                    imagePion.backgroundColor = nil
                }
            }
            else{
                //clair
                imageBackground.image = UIImage(named: "boisClair.jpeg")
                imagePion.backgroundColor = nil
                
            }
        }
    }  
    
    
}
