//
//  CollectionViewController.swift
//  Jeu de Dame
//
//  Created by MacOS Sierra on 25/05/2018.
//  Copyright © 2018 MacOS Sierra. All rights reserved.
//


import UIKit


var cellType = true
class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    let reuseIdentifier = "case"
    
    
    @IBOutlet weak var collection: UICollectionView!
    
    var imageView : UIImageView? = nil
    var cell = UICollectionViewCell()
    var locationPointSaved = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        collection.dataSource = self
        collection.delegate = self
        
        let gest = UIPanGestureRecognizer(target: self, action: #selector(CollectionViewController.handlePanGesture(_:)))
        collection.addGestureRecognizer(gest)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return collectionView.numberOfSections
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collection.frame.height / 10, height: self.collection.frame.height / 10)
    }
        
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //return section
        return 10
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.collection.reloadData()
        })
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Case
        cell.creationPlateau(indexPath: indexPath)
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension CollectionViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // Manage an invalid drag (no pion on this case / not current pion to be played)
        return true
    }
    @objc func handlePanGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {
        
        let locationPoint = panGestureRecognizer.location(in: collection)
        locationPointSaved = locationPoint
        
        if panGestureRecognizer.state == .began {
            // Create a current viewCell "screenshot" / TODO: only pionView should be duplicated
            //if (imageView?.backgroundColor == UIColor.black || imageView?.backgroundColor == UIColor.white){
            let indexPathOfMovingCell = collection.indexPathForItem(at: locationPoint)!
            cell = collection.cellForItem(at: indexPathOfMovingCell)!
            UIGraphicsBeginImageContext(cell.bounds.size)
            let ctx = UIGraphicsGetCurrentContext()!
            cell.layer.render(in: ctx)
            if (cell as! Case).imagePion.backgroundColor == UIColor.black || (cell as! Case).imagePion.backgroundColor == UIColor.white{

                //let cellImage = UIGraphicsGetImageFromCurrentImageContext()
                let cellImage = (cell as! Case).imagePion.backgroundColor
                imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.bounds.width*0.9, height:
                    cell.bounds.height*0.9))
                
                if let imageView = imageView {
                    imageView.backgroundColor = cellImage
                    imageView.layer.cornerRadius = imageView.frame.size.width / 2
                    collection.addSubview(imageView)
                    imageView.center = locationPoint
                }
                // TODO: make moving view bigger (as it is upper from other "pion")
                // use UIView transform property and CGAffineTransform(scaleX:y:) to achieve this
                imageView?.transform = CGAffineTransform(scaleX : 1.1 , y : 1.1)
                // TODO: reconfigure current cell to be in state "moving away" (pion can have a alpha of 0.5 to indicate this)
                (cell as! Case).imagePion.alpha = 0.5
            }
        }
        if panGestureRecognizer.state == .changed {
            print("pan at \(locationPoint)")
            imageView?.center = locationPoint
        }
        if panGestureRecognizer.state == .ended {
            // TODO: manage if movement is valid (update model accordingly)
            /*UIView.animate(withDuration: 2, animations: {
                self.imageView?.center.x += self.locationPoint
                })*/
            
            let finalPoint = imageView?.center
            
            UIView.animate(withDuration: 0.5, delay: 0,options: UIViewAnimationOptions.curveEaseOut,
                           animations: {self.locationPointSaved = finalPoint! },
                completion: nil)
            
            
            
            
            
            
            imageView?.removeFromSuperview()
        }
    } }

