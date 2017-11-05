//
//  RangeSliderScaleLayer.swift
//  GNKSlider
//
//  Created by Gennadii on 05/11/2017.
//  Copyright © 2017 Gennadii Tsypenko. All rights reserved.
//

import UIKit

class RangeSliderScaleLayer: CALayer {
	
	weak var rangeSlider: RangeSlider?
	
	override func draw(in ctx: CGContext) {
		if let slider = rangeSlider {
			// Clip
            let cornerRadius = bounds.width * slider.curvaceousness / 2.0
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            ctx.setStrokeColor(UIColor.black.cgColor)
            path.stroke()
            ctx.addPath(path.cgPath)
            
			
			// Fill the highlighted and background range
			ctx.setFillColor(slider.selectedRangeColor.cgColor)
			let lowerValuePosition = CGFloat(slider.positionForValue(value: slider.lowerValue))
			let upperValuePosition = CGFloat(slider.positionForValue(value: slider.upperValue))
			let rect = CGRect(x: 0.0, y: lowerValuePosition, width: bounds.width / 4, height: upperValuePosition - lowerValuePosition)
			ctx.fill(rect)
			
			ctx.setFillColor(slider.trackTintColor.cgColor)
			let redTopBackground = CGRect(x: 0.0, y: 0.0, width: bounds.width / 4, height: lowerValuePosition)
			ctx.fill(redTopBackground)
			let redBottomBackground = CGRect(x: 0.0, y: upperValuePosition, width: bounds.width / 4, height: max(upperValuePosition, bounds.height - upperValuePosition))
			ctx.fill(redBottomBackground)
			
			//Add scale
			ctx.setStrokeColor(UIColor.black.cgColor)
			ctx.setLineWidth(3)
			ctx.beginPath()
			let shortLineWidth: CGFloat = 15  //rangeSlider!.frame.width / 4
			let longLineWidth: CGFloat = 30   //rangeSlider!.frame.width / 2
			let scaleFullHeight = rangeSlider!.frame.height
			let step : CGFloat = 30
			let steps = Int(scaleFullHeight / step)
			
			var yCoord = step
			for stepIndex in 1...steps {
				ctx.move(to: CGPoint(x: 0, y: yCoord))
				if stepIndex%2 == 0 {
					ctx.addLine(to: CGPoint(x: longLineWidth, y: yCoord))
				}else{
					ctx.addLine(to: CGPoint(x: shortLineWidth, y: yCoord))
				}
				
				yCoord = step * CGFloat(stepIndex)
			}
			
			//Add lines
			ctx.move(to: CGPoint(x: 0, y: upperValuePosition))
			ctx.addLine(to: CGPoint(x: (rangeSlider?.frame.width)! - (rangeSlider?.scaleMargin)!, y:upperValuePosition))
			
			ctx.move(to: CGPoint(x: 0, y: lowerValuePosition))
			ctx.addLine(to: CGPoint(x: (rangeSlider?.frame.width)! - (rangeSlider?.scaleMargin)!, y:lowerValuePosition))
			//End adding lines
			
			ctx.strokePath()
			
		}
	}
	
	
	
}
