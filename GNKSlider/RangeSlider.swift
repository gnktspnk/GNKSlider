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

    let minimumValue = 6.0
    let maximumValue = 26.0
	
	var lowerValue = 8.0
    var upperValue = 25.0
	var currentWaterValue = 20.0
	
	
    
    let lowerThumbLayer = RangeSliderThumbLayer()
    let upperThumbLayer = RangeSliderThumbLayer()
	let trackLayer = RangeSliderScaleLayer()
    let cupLayer = CAShapeLayer()
	let currentWaterFlag = CurrentWaterFlag()
    
    var previousLocation = CGPoint()
	
    var thumbWidth : CGFloat {
        return bounds.insetBy(dx: 60, dy: 60).width
    }
	//MARK: Colors
	let trackTintColor = UIColor.red
	let selectedRangeColor = UIColor.green
	let thumbTintColor = UIColor.white
	let flagColor = UIColor.red
	let borderColor = UIColor.black
	let waterColor = UIColor.init(red: 64/255, green: 164/255, blue: 223/255, alpha: 0.5)
	// MARK: Constants
	var curvaceousness : CGFloat = 10
	let thumbsXInset : CGFloat = 120
	var currentWaterFlagInset : CGFloat {return currentWaterFlagBorderWidth}
	let currentWaterFlagBorderWidth : CGFloat = 1
	let scaleMargin : CGFloat = 35
	
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

		currentWaterFlag.rangeSlider = self
		currentWaterFlag.contentsScale = UIScreen.main.scale
		layer.addSublayer(currentWaterFlag)
		
         updateLayerFrames()
		 drawCupLayer()
    }
	
	let bottomCupMargins: CGFloat = 50
	
	func drawCupLayer(){
		
		let cupShapePath = UIBezierPath()
		let topLeftPoint = CGPoint.init(x: 0, y: bounds.height / 2)
		let topRightPoint = CGPoint.init(x: bounds.width - 50 , y: bounds.height / 2)
		let bottomRightPoint = CGPoint.init(x: bounds.width - bottomCupMargins*1.5, y: bounds.height)
		let bottomLeftPoint = CGPoint.init(x: bounds.width - bottomCupMargins*2.5, y: bounds.height)
		let leftCupLine = [topLeftPoint, bottomLeftPoint]
		let rightCupLine = [topRightPoint, bottomRightPoint]
		cupShapePath.move(to: topLeftPoint)
		cupShapePath.addLine(to: topRightPoint)
		cupShapePath.addLine(to: bottomRightPoint)
		cupShapePath.addLine(to: bottomLeftPoint)
		cupShapePath.close()
		//cupShapePath.close()
		
		cupLayer.path = cupShapePath.cgPath
		
		cupLayer.fillRule = kCAFillRuleNonZero
		cupLayer.lineCap = kCALineCapButt
		cupLayer.fillColor = UIColor.clear.cgColor
		cupLayer.lineDashPattern = nil
		cupLayer.lineDashPhase = 0.0
		cupLayer.lineJoin = kCALineJoinMiter
		cupLayer.lineWidth = 3.0
		cupLayer.miterLimit = 10.0
		cupLayer.strokeColor = UIColor.black.cgColor
		
		// Water
		
		let fillLayer = CAShapeLayer()
		fillLayer.frame = cupLayer.bounds
		
		let cupFillPath = UIBezierPath()
		waterColor.setFill()
		cupFillPath.fill()
		
		var leftIntersectedPoint: CGFloat = 0
		var rightIntersectedPoint: CGFloat = bounds.height / 2 -  8 // I can't explain this for now.
		if currentWaterValue < (maximumValue + minimumValue) / 2 {
			leftIntersectedPoint = leftCupLine.getValue(forY: CGFloat(positionForValue(value: currentWaterValue))) ?? 0
			rightIntersectedPoint = rightCupLine.getValue(forY: CGFloat(positionForValue(value: currentWaterValue))) ?? bounds.height / 2 - 8
		}
		
		
		let topWaterLevel = max(bounds.height / 2, CGFloat(positionForValue(value: currentWaterValue)))
		let topLeftFillPoint = CGPoint.init(x: leftIntersectedPoint, y: topWaterLevel)
		let topRightFillPoint = CGPoint.init(x: rightIntersectedPoint, y: topWaterLevel)
		
		cupFillPath.move(to: topLeftFillPoint)
		cupFillPath.addLine(to: topRightFillPoint)
		cupFillPath.addLine(to: bottomRightPoint)
		cupFillPath.addLine(to: bottomLeftPoint)
		cupFillPath.close()
		fillLayer.path = cupFillPath.cgPath
		fillLayer.fillColor = waterColor.cgColor
		
		cupLayer.addSublayer(fillLayer)
		layer.addSublayer(cupLayer)
		
	}
	
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLayerFrames(){
		trackLayer.frame = CGRect(x: scaleMargin, y: 0.0, width: bounds.width, height: bounds.height) //bounds
		trackLayer.setNeedsDisplay()
				
        let lowerThumbCenter = CGFloat(positionForValue(value: lowerValue))
        
        lowerThumbLayer.frame = CGRect(x: thumbsXInset, y: lowerThumbCenter - thumbWidth / 2,
                                       width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(value: upperValue))
        
        upperThumbLayer.frame = CGRect(x: thumbsXInset, y: upperThumbCenter - thumbWidth / 2,
                                       width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
		
		let currentWaterFlagCenter = CGFloat(positionForValue(value: currentWaterValue))
		
		currentWaterFlag.frame = CGRect(x: currentWaterFlagInset, y: currentWaterFlagCenter - thumbWidth / 2, width: thumbWidth, height: thumbWidth)
		currentWaterFlag.setNeedsLayout()
    }
    
    func positionForValue(value: Double) -> Double {
//        return Double(bounds.height - thumbWidth) * (value - minimumValue) /
//            (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
		
		 return Double(bounds.height) - Double(bounds.height) * (value - minimumValue) / (maximumValue - minimumValue)
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
		
		previousLocation = location
        
        // 2. Update the values
        if lowerThumbLayer.highlighted {
            lowerValue -= deltaValue
            lowerValue = boundValue(value: lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
        } else if upperThumbLayer.highlighted {
            upperValue -= deltaValue
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
