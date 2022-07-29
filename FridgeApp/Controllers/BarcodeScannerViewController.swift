//
//  BarcodeScannerViewController.swift
//  FridgeApp
//
//  Created by Khushneet on 14/07/22.
//

import UIKit
import AVFoundation
	
class BarcodeScannerViewController: UIViewController {
	var captureSession: AVCaptureSession!
	var previewLayer: AVCaptureVideoPreviewLayer!
	var delegate : ScannerViewDelegate? = nil
	var result : ScanningResult = .invalid
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor.black
		captureSession = AVCaptureSession()
		delegate = self
		guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
		let videoInput: AVCaptureDeviceInput
		
		do {
			videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
		} catch {
			return
		}
		
		if (captureSession.canAddInput(videoInput)) {
			captureSession.addInput(videoInput)
		} else {
			result = .failure
			delegate?.didComplete(with: result)
			return
		}
		
		let metadataOutput = AVCaptureMetadataOutput()
		
		if (captureSession.canAddOutput(metadataOutput)) {
			captureSession.addOutput(metadataOutput)
			
			metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
		} else {
			result = .failure
			delegate?.didComplete(with: result)
			return
		}
		
		previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		previewLayer.frame = view.layer.bounds
		previewLayer.videoGravity = .resizeAspectFill
		view.layer.addSublayer(previewLayer)
		
		captureSession.startRunning()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		if (captureSession?.isRunning == false) {
			captureSession.startRunning()
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		if (captureSession?.isRunning == true) {
			captureSession.stopRunning()
		}
	}
}

extension BarcodeScannerViewController : AVCaptureMetadataOutputObjectsDelegate {
	func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		captureSession.stopRunning()
		
		if let metadataObject = metadataObjects.first {
			guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
			guard let stringValue = readableObject.stringValue else { return }
			AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
			result = .success(data: Double(stringValue) ?? 0)
			delegate?.didComplete(with: result)
		}
		
		dismiss(animated: true)
	}
}

extension BarcodeScannerViewController : ScannerViewDelegate {
    func didComplete(with result:ScanningResult) {
        switch result {
        case .success(let data):
            if let vc = storyboard?.instantiateViewController(withIdentifier: "FetchProductVC") as? FetchProductViewController {
                vc.barcodeStr = "\(data)"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        default:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "AddProductVC") as? AddProductViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
            break
        }
    }
}
