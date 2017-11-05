////
////  ScaleLayer.swift
////  GNKSlider
////
////  Created by Gennadii on 01/11/2017.
////  Copyright © 2017 Gennadii Tsypenko. All rights reserved.
////
//
//import UIKit
//
//class ScaleLayer: CALayer {
//
//	weak var rangeSlider: RangeSlider?{
//		didSet{
//			addLines()
//		}
//	}
//
//	let line = CAShapeLayer()
//	let linePath = UIBezierPath()
//	
//	override init() {
//		super.init()
//
//		borderColor = UIColor.black.cgColor
//		borderWidth = 3
//
//	}
//
//	private func addLines(){
//		let shortLineWidth = rangeSlider!.frame.width / 4
//		let longLineWidth = rangeSlider!.frame.width / 2
//		let scaleFullHeight = rangeSlider!.frame.height
//		let step : CGFloat = 30
//		let steps = Int(scaleFullHeight / step)
//
//		var yCoord = step
//		for stepIndex in 1...steps {
//			linePath.move(to: CGPoint(x: 0, y: yCoord))
//			if stepIndex%2 == 0 {
//				linePath.addLine(to: CGPoint(x: longLineWidth, y: yCoord))
//			}else{
//				linePath.addLine(to: CGPoint(x: shortLineWidth, y: yCoord))
//			}
//
//			yCoord = step * CGFloat(stepIndex)
//		}
//
//		line.path = linePath.cgPath
//		line.fillColor = nil
//		line.opacity = 1.0
//		line.strokeColor = UIColor.black.cgColor
//		line.lineWidth = 3
//		addSublayer(line)
//	}
//
//	required init?(coder aDecoder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
//}

