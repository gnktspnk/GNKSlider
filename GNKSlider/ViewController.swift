//
//  ViewController.swift
//  GNKSlider
//
//  Created by Gennadii Tsypenko on 31/10/2017.
//  Copyright © 2017 Gennadii Tsypenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //let rangeSlider = RangeSlider(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
		let margin: CGFloat = 54.0
		let width: CGFloat = 154
		let height: CGFloat = 300
		let rangeSlider = RangeSlider(frame: CGRect(x: margin, y: margin + topLayoutGuide.length,
													width: width, height: height))
        view.addSubview(rangeSlider)
		
		rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged), for: .valueChanged)
    }
	
	@objc func rangeSliderValueChanged(rangeSlider: RangeSlider){
		print("Range slider new value: \(rangeSlider.lowerValue)-\(rangeSlider.upperValue)")
	}
    



}

