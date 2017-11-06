//
//  CurrentWaterFlag.swift
//  GNKSlider
//
//  Created by Gennadii on 06/11/2017.
//  Copyright © 2017 Gennadii Tsypenko. All rights reserved.
//

import UIKit
import QuartzCore

class CurrentWaterFlag: CALayer {
	
	weak var rangeSlider : RangeSlider?{
		didSet{
			setNeedsDisplay()
		}
	}
	
	override func draw(in ctx: CGContext) {
		guard let rangeSlider = rangeSlider else {return}
		let trianglePath = UIBezierPath()
		trianglePath.move(to: CGPoint(x: 0, y: 0))
		trianglePath.addLine(to: CGPoint(x: bounds.width, y: bounds.width / 2))
		trianglePath.addLine(to: CGPoint(x: 0, y: bounds.width))
		trianglePath.addLine(to: CGPoint(x: 0, y: 0))
		ctx.setFillColor(rangeSlider.flagColor.cgColor)
		ctx.addPath(trianglePath.cgPath)
		ctx.fillPath()
		//Border
		ctx.setStrokeColor(rangeSlider.borderColor.cgColor)
		ctx.setLineWidth(rangeSlider.currentWaterFlagBorderWidth)
		ctx.addPath(trianglePath.cgPath)
		ctx.strokePath()
		
	}
}
