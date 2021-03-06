//
//  LayerAction.swift
//  Pods
//
//  Created by Khoa Pham on 04/06/16.
//
//

import UIKit

public extension Layer {

  public final class Action {

    public weak var layer: CALayer?
    var animations: [LayerAnimation] = []

    public init() {
      
    }
  }
}

public extension Chain where A: Layer.Action {

  public func layer(layer: CALayer) -> Chain {
    return configure { (action: Layer.Action) in
      action.layer = layer
    }
  }

  public func add(animation: LayerAnimation) -> Chain {
    return configure { (action: Layer.Action) in
      action.animations.append(animation)
    }
  }

  public func configureAnimation<T>(block: T -> Void) -> Chain {
    return configure { (action: Layer.Action) in
      if let animation = action.animations.last as? T {
        block(animation)
      }
    }
  }
}

extension Layer.Action: Action {

  public func run(nextActions: [Action]) {
    CATransaction.begin()

    CATransaction.setCompletionBlock {
      Wave.run(nextActions)
    }

    animations.forEach {
      layer?.addAnimation($0.info, forKey: "")
    }

    CATransaction.commit()
  }
}
