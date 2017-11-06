//
//  RangeSliderThumbLayer.swift
//  GNKSlider
//
//  Created by Gennadii Tsypenko on 31/10/2017.
//  Copyright © 2017 Gennadii Tsypenko. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSliderThumbLayer: CALayer {
	
	var highlighted = false {
        didSet{
           setNeedsDisplay()
        }
    }
     weak var rangeSlider: RangeSlider?
	
	override func draw(in ctx: CGContext) {
		if let slider = rangeSlider {
			let thumbFrame = bounds
			let cornerRadius = thumbFrame.height * slider.curvaceousness / 2.0
			let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
			
			// Fill - with a subtle shadow
			let shadowColor = UIColor.gray
			ctx.setShadow(offset: CGSize.init(width: 0, height: 1), blur: 1)
			ctx.setFillColor(slider.thumbTintColor.cgColor)
			
			ctx.addPath(thumbPath.cgPath)
			ctx.fillPath()
			
			// Outline
			ctx.setStrokeColor(shadowColor.cgColor)
			ctx.setLineWidth(0.5)
			ctx.addPath(thumbPath.cgPath)
			ctx.strokePath()
			
			if highlighted {
				ctx.setFillColor(UIColor(white: 0.0, alpha: 0.1).cgColor)
				ctx.addPath(thumbPath.cgPath)
				ctx.fillPath()
			}
		}
	}
}
