//
//  ArrayExtension.swift
//  GNKSlider
//
//  Created by Gennadii on 06/11/2017.
//  Copyright © 2017 Gennadii Tsypenko. All rights reserved.
//

import Foundation
import UIKit

protocol PointXY {
	var x: CGFloat {get set}
	var y: CGFloat {get set}
}

extension CGPoint: PointXY {}

extension Array where Element: PointXY {
	
	func getValue(forY y: CGFloat) -> CGFloat? {
		for index in 0..<(self.count - 1) {
			let p1 = self[index]
			let p2 = self[index + 1]
			// return p.x if a p.y matches y
			if y == p1.y { return p1.x }
			if y == p2.y { return p2.x }
			// if y is between p1.y and p2.y calculate interpolated value
			if y > p1.y && y < p2.y {
				let x1 = p1.x
				let x2 = p2.x
				let y1 = p1.y
				let y2 = p2.y
				return (y - y1) / (y2 - y1) * (x2 - x1) + x1
			}
		}
		return nil
	}
	
}
