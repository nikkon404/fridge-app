//
//  ScannerViewDelegate.swift
//  FridgeApp
//
//  Created by Khushneet on 26/07/22.
//

import Foundation

enum ScanningResult {
	 case invalid
	 case success(data: Double)
	 case failure
}

protocol ScannerViewDelegate {
	func didComplete(with result:ScanningResult)
}
