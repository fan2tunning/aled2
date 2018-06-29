//
//  ViewController.swift
//  Dames
//
//  Created by Eric Le Maître on 25/05/2018.
//  Copyright © 2018 Eric Le Maître. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GameDelegate {
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var numberTurnsLabel: UILabel!
  @IBOutlet weak var playerTurnLabel: UILabel!
  
  var game = Game()
  var puckViews = [PuckView]()
  
  var touchedPuckInitialCenter: CGPoint?
  var touchedPuck: PuckView?
  var touchedPuckStartPosition: IndexPath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.delegate = self
    collectionView.dataSource = self
    game.delegate = self
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    collectionView.resignFirstResponder()
    coordinator.animate(alongsideTransition: { _ in
      for puckView in self.puckViews {
        puckView.removeFromSuperview()
      }
      self.puckViews.removeAll()
      self.collectionView.reloadData()
    }, completion: { _ in
      self.collectionView.becomeFirstResponder()
    })
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touchLocation = touches.first!.location(in: collectionView)
    for puck in puckViews {
      if puck.frame.contains(touchLocation) && game.pucks[puck.position]?.color == game.currentPlayer.color {
        touchedPuck = puck
        touchedPuckInitialCenter = puck.center
        touchedPuckStartPosition = puck.position
        collectionView.bringSubview(toFront: touchedPuck!)
        
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 4.0, options: .curveEaseIn, animations: {
          self.touchedPuck?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        })
      }
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let _ = touchedPuck {
      touchedPuck?.center = touches.first!.location(in: collectionView)
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    defer {
      UIView.animate(withDuration: 0.5) {
        self.touchedPuck?.transform = .identity
      }
      touchedPuck = nil
      touchedPuckInitialCenter = nil
      touchedPuckStartPosition = nil
    }
    guard let _ = touchedPuck else {
      return
    }
    
    let endLocation = touches.first!.location(in: collectionView)
    let endCell = collectionView.subviews.compactMap { cell -> DameCollectionViewCell? in
      if let cell = cell as? DameCollectionViewCell, cell.frame.contains(endLocation) {
        return cell
      }
      return nil
    }.first
    if let endCell = endCell {
      guard let endIndexPath = collectionView.indexPath(for: endCell) else {
        touchedPuck!.center = touchedPuckInitialCenter!
        return
      }
      let movingPuck = game.pucks[touchedPuckStartPosition!]
      
      if game.canPuck(movingPuck!, atPosition: touchedPuckStartPosition!, moveTo: endIndexPath) {
        touchedPuck!.center = endCell.center
        touchedPuck!.position = endIndexPath
        game.pucks[endIndexPath] = game.pucks[touchedPuckStartPosition!]
        game.pucks.removeValue(forKey: touchedPuckStartPosition!)
        game.nextTurn()
        numberTurnsLabel.text = "Nombre de tour : \(game.turnNumber)"
        playerTurnLabel.text = "Au joueur \(game.currentPlayer) ! "
      } else {
        touchedPuck!.center = touchedPuckInitialCenter!
      }
    } else {
      touchedPuck!.center = touchedPuckInitialCenter!
    }
  }
  
  @IBAction func startButtonTouched(_ sender: Any) {
    game = Game()
    playerTurnLabel.text = "Au joueur \(game.currentPlayer) !"
    for puck in puckViews {
      puck.removeFromSuperview()
    }
    puckViews.removeAll()
    collectionView.reloadData()
  }
}

//MARK : GameDelegate methods
extension ViewController {
  func eatPuckAt(position: IndexPath) {
    var eatedPuck: PuckView? = nil
    for puck in puckViews {
      if puck.position == position {
        eatedPuck = puck
        break
      }
    }
    guard eatedPuck != nil else {
      return
    }
    
    UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2, animations: {
        eatedPuck!.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
      })
      UIView.addKeyframe(withRelativeStartTime: 0.22, relativeDuration: 0.78, animations: {
        eatedPuck!.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
      })
    }) { _ in
      eatedPuck?.removeFromSuperview()
      self.puckViews.remove(at: self.puckViews.index(of: eatedPuck!)!)
    }
  }
}

//MARK : UICollectionViewDataSource methods
extension ViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    collectionView.register(UINib(nibName: "DameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DameCell")
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DameCell", for: indexPath) as! DameCollectionViewCell
    if indexPath.section % 2 == 0 {
      cell.imageView.image = UIImage(named: indexPath.row % 2 == 1 ? "darkWood" : "clearWood")
    } else {
      cell.imageView.image = UIImage(named: indexPath.row % 2 == 0 ? "darkWood" : "clearWood")
    }
    return cell
  }
  
  func addPuckOf(color: PuckColor, in cell: DameCollectionViewCell, at indexPath: IndexPath) {
    let puckView = PuckView(frame: cell.frame, position: indexPath)
    puckView.image = UIImage(named: color == .Black ? "BlackPuck" : "WhitePuck")
    puckViews.append(puckView)
    collectionView.addSubview(puckView)
  }
}

//MARK : UICollectionViewDelegate methods
extension ViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let cell = cell as? DameCollectionViewCell {
      if let puck = game.pucks[indexPath] {
        addPuckOf(color: puck.color, in: cell, at: indexPath)
      }
    }
  }
}

//MARK : UICollectionViewDelegateFlowLayout methods
extension ViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width / 10, height: collectionView.frame.height / 10)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
}
