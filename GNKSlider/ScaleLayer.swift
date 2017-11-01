//
//  ScaleLayer.swift
//  GNKSlider
//
//  Created by Gennadii on 01/11/2017.
//  Copyright © 2017 Gennadii Tsypenko. All rights reserved.
//

import UIKit

class ScaleLayer: CALayer {
	
	weak var rangeSlider: RangeSlider?
	let line = CAShapeLayer()
	let linePath = UIBezierPath()
	
	override init() {
		super.init()
		borderColor = UIColor.black.cgColor
		borderWidth = 3
		
		linePath.move(to: CGPoint(x: 0, y: 15))
		linePath.addLine(to: CGPoint(x: (rangeSlider?.frame.width)! / 4, y: 15))
		line.path = linePath.cgPath
		line.fillColor = nil
		line.opacity = 1.0
		line.strokeColor = UIColor.black.cgColor
		line.lineWidth = 3
		addSublayer(line)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
