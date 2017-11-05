//
//  RangeSlider.swift
//  GNKSlider
//
//  Created by Gennadii Tsypenko on 31/10/2017.
//  Copyright © 2017 Gennadii Tsypenko. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSlider: UIControl {

    var minimumValue = 0.0
    var maximumValue = 1.0
    var lowerValue = 0.2
    var upperValue = 0.8
    
	//var scaleLayer = ScaleLayer()
    let lowerThumbLayer = RangeSliderThumbLayer()
    let upperThumbLayer = RangeSliderThumbLayer()
	let trackLayer = RangeSliderScaleLayer()
    var previousLocation = CGPoint()
	
    var thumbWidth : CGFloat {
        return bounds.insetBy(dx: 60, dy: 60).width
    }
	
	var trackTintColor = UIColor.red
	var trackHighlightTintColor = UIColor.green
	var thumbTintColor = UIColor.white
	var curvaceousness : CGFloat = 1
	let thumbsXInset : CGFloat = 120
	let scaleMargin : CGFloat = 35
	
	let cupLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
		
		trackLayer.rangeSlider = self
		trackLayer.contentsScale = UIScreen.main.scale
		layer.addSublayer(trackLayer)
		
		lowerThumbLayer.rangeSlider = self
		lowerThumbLayer.contentsScale = UIScreen.main.scale
		layer.addSublayer(lowerThumbLayer)
		
		upperThumbLayer.rangeSlider = self
		upperThumbLayer.contentsScale = UIScreen.main.scale
		layer.addSublayer(upperThumbLayer)
		
//        lowerThumbLayer.rangeSlider = self
//        upperThumbLayer.rangeSlider = self
//		scaleLayer.rangeSlider = self
//
//		scaleLayer.backgroundColor = UIColor.red.cgColor
//		layer.addSublayer(scaleLayer)
//
//        lowerThumbLayer.backgroundColor = UIColor.green.cgColor
//        layer.addSublayer(lowerThumbLayer)
//
//        upperThumbLayer.backgroundColor = UIColor.green.cgColor
//        layer.addSublayer(upperThumbLayer)
//
         updateLayerFrames()
		 drawCupLayer()
    }
	
	let bottomCupMargins: CGFloat = 50
	func drawCupLayer(){
		let path = UIBezierPath()
		path.move(to: CGPoint.init(x: 0, y: bounds.height / 2))
		path.addLine(to: CGPoint.init(x: bounds.width - 50 , y: bounds.height / 2))
		path.addLine(to: CGPoint.init(x: bounds.width - bottomCupMargins*1.5, y: bounds.height))
		path.addLine(to: CGPoint.init(x: bounds.width - bottomCupMargins*2.5, y: bounds.height))
		path.close()
		
		cupLayer.path = path.cgPath
		let waterColor = UIColor.init(red: 64/255, green: 164/255, blue: 223/255, alpha: 0.5)
		cupLayer.fillColor = waterColor.cgColor
		cupLayer.fillRule = kCAFillRuleNonZero
		cupLayer.lineCap = kCALineCapButt
		cupLayer.lineDashPattern = nil
		cupLayer.lineDashPhase = 0.0
		cupLayer.lineJoin = kCALineJoinMiter
		cupLayer.lineWidth = 3.0
		cupLayer.miterLimit = 10.0
		cupLayer.strokeColor = UIColor.black.cgColor
		layer.addSublayer(cupLayer)
	}
	
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLayerFrames(){
		trackLayer.frame = CGRect(x: scaleMargin, y: 0.0, width: bounds.width, height: bounds.height) //bounds
		trackLayer.setNeedsDisplay()
		
//		scaleLayer.frame = bounds
//		scaleLayer.setNeedsDisplay()
		
        let lowerThumbCenter = CGFloat(positionForValue(value: lowerValue))
        
        lowerThumbLayer.frame = CGRect(x: thumbsXInset, y: lowerThumbCenter - thumbWidth / 2,
                                       width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(value: upperValue))
        
        upperThumbLayer.frame = CGRect(x: thumbsXInset, y: upperThumbCenter - thumbWidth / 2,
                                       width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
    }
    
    func positionForValue(value: Double) -> Double {
        return Double(bounds.height - thumbWidth) * (value - minimumValue) /
            (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
    }
    
    override var frame: CGRect{
        didSet{
            updateLayerFrames()
        }
    }
    
    func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    // MARK: UIControl delegates
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        // Hit test the thumb layers
        if lowerThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.highlighted = true
        } else if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.highlighted = true
        }
        
        return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        // 1. Determine by how much the user has dragged
        let deltaLocation = Double(location.y - previousLocation.y)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.height - thumbWidth)
        
        // stopped here !!!<---!!!
        // lookup here ->>> https://www.raywenderlich.com/76433/how-to-make-a-custom-control-swift
        previousLocation = location
        
        // 2. Update the values
        if lowerThumbLayer.highlighted {
            lowerValue += deltaValue
            lowerValue = boundValue(value: lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
        } else if upperThumbLayer.highlighted {
            upperValue += deltaValue
            upperValue = boundValue(value: upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
        }
        
        // 3. Update the UI
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        updateLayerFrames()
        
        CATransaction.commit()
		
		sendActions(for: .valueChanged)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.highlighted = false
        upperThumbLayer.highlighted = false
    }
    
}
