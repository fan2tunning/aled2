//
//  Puck.swift
//  Dames
//
//  Created by Eric Le Maître on 28/05/2018.
//  Copyright © 2018 Eric Le Maître. All rights reserved.
//

enum PuckColor {
  case Black
  case White
}

struct Puck: Equatable, Hashable {
  let color: PuckColor
  
  static func ==(lhs: Puck, rhs: Puck) -> Bool {
    return lhs.color == rhs.color
  }
}
