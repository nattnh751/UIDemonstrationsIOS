//
//  CircleGradient.swift
//  Ios Demonstrations
//
//  Created by Nathan Walsh on 9/23/20.
//  Copyright © 2020 Nathan Walsh. All rights reserved.
//

import Foundation

class circleView : UIView {
  override func draw(_ rect: CGRect) {
    self.backgroundColor = .clear
    let context = UIGraphicsGetCurrentContext()
    let colorspace =  CGColorSpaceCreateDeviceRGB()
    let gradientColors = NSMutableArray()
    gradientColors.add(UIColor.red.withAlphaComponent(0.0).cgColor)
    gradientColors.add(UIColor.black.cgColor)
    let locations: [CGFloat] = [0, 0.1, 0.9, 1]
    let gradient: CGGradient? = CGGradient(colorsSpace: colorspace, colors: [UIColor.black.cgColor, UIColor.red.cgColor, UIColor.black.cgColor, UIColor.white.cgColor] as CFArray, locations: locations)
    let beizerround = UIBezierPath.init(rect: rect)
    if let cont = context {
      cont.saveGState()
      beizerround.fill()
      beizerround.addClip()
      let center = CGPoint(x: rect.midX, y: rect.midY)
      if let grad = gradient {
        cont.drawRadialGradient (grad, startCenter: center, startRadius: 0, endCenter: center, endRadius: rect.size.width, options: .drawsBeforeStartLocation);
      }
    }
  }
}
