//
//  Game.swift
//  Dames
//
//  Created by Eric Le Maître on 28/05/2018.
//  Copyright © 2018 Eric Le Maître. All rights reserved.
//

import CoreGraphics
import Foundation

//TODO: Swift 4.2 : make Player an enum : CaseIterable to count the number of cases
struct Player: CustomStringConvertible {
  var color: PuckColor
  
  var description: String {
    switch color {
    case .Black:
      return "Noir"
    case .White:
      return "Blanc"
    }
  }
}

protocol GameDelegate {
  func eatPuckAt(position: IndexPath)
}

struct Game {
  var pucks : [IndexPath:Puck]
  var currentPlayer: Player
  var turnNumber = 0
  var delegate: GameDelegate?
  
  init(with pucks: [IndexPath:Puck] = initPucks()) {
    self.pucks = pucks
    self.currentPlayer = Player(color: .White)
  }
  
  private static func initPucks() -> [IndexPath:Puck] {
    var pucks = [IndexPath:Puck]()
    for i in 0..<10 {
      for j in 0..<10 {
        guard j <= 3 || j >= 6 else {
          continue
        }
        if j % 2 == 0 {
          if i % 2 == 1 {
            pucks[IndexPath(row: i, section: j)] = Puck(color: j < 5 ? .Black : .White)
          }
        } else {
          if i % 2 == 0 {
            pucks[IndexPath(row: i, section: j)] = Puck(color: j < 5 ? .Black : .White)
          }
        }
      }
    }
    return pucks
  }
  
  mutating func nextTurn() {
    currentPlayer = currentPlayer.color == .White ? Player(color: .Black) : Player(color: .White)
    turnNumber += 1
  }
  
  mutating func canPuck(_ puck: Puck, atPosition startPosition: IndexPath, moveTo endPosition: IndexPath) -> Bool {
    guard isDiagonalBetween(position1: startPosition, position2: endPosition) && pucks[endPosition] == nil else {
      return false
    }
    if checkIfPosition(startPosition, isNextTo: endPosition) {
      return isPuckMovingForward(puck, startPosition: startPosition, endPosition: endPosition)
    } else {
      let positionBetween = getPositionBetween(position1: startPosition, and: endPosition)
      let puckBetween = pucks[positionBetween]
      if let puckBetween = puckBetween, puckBetween == Puck(color: puck.color == .Black ? .White : .Black) {
        pucks.removeValue(forKey: positionBetween)
        delegate?.eatPuckAt(position: positionBetween)
        return true
      }
    }
    return false
  }
  
  private func isDiagonalBetween(position1: IndexPath, position2: IndexPath) -> Bool {
    return position1.row != position2.row && position1.section != position2.section
  }
  
  private func checkIfPosition(_ position: IndexPath, isNextTo currentPosition: IndexPath) -> Bool {
    return abs(position.section - currentPosition.section) == 1 && abs(position.row - currentPosition.row) == 1
  }
  
  private func isPuckMovingForward(_ puck: Puck, startPosition: IndexPath, endPosition: IndexPath) -> Bool {
    switch puck.color {
    case .Black:
      return startPosition.section - endPosition.section == -1
    case .White:
      return startPosition.section - endPosition.section == 1
    }
  }
  
  private func getPositionBetween(position1: IndexPath, and position2: IndexPath) -> IndexPath {
    let line = max(position1.section, position2.section) - 1
    let column = max(position1.row, position2.row) - 1
    return IndexPath(row: column, section: line)
  }
  
  private func getAllPositionsBetween(position1: IndexPath, and position2: IndexPath) -> [IndexPath] {
    var lines = [Int]()
    var columns = [Int]()
    var positions = [IndexPath]()
    for line in min(position1.section, position2.section)+1..<max(position1.section, position2.section) {
      lines.append(line)
    }
    for column in min(position1.row, position2.row)+1..<max(position1.row, position2.row) {
      columns.append(column)
    }
    for i in 0..<lines.count {
      positions.append(IndexPath(row: columns[i], section: lines[i]))
    }
    return positions
  }
  
}
