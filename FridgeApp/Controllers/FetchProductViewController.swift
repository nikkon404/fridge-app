//
//  FetchProductViewController.swift
//  FridgeApp
//
//  Created by Khushneet on 22/07/22.
//

import UIKit

class FetchProductViewController: UIViewController {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    
    public var barcodeStr :
        String = ""
    
    
    func showLoading()  {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
    }
        override func viewDidLoad() {
            super.viewDidLoad()
            //show loading indicator
            showLoading()
           
            //fetch data
            ApiService.fetchData(barCode: barcodeStr, completion: { result in
                
                //disliss loading
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
                
                //stop indicator
                switch (result) {
                case .success(let data):
                    DispatchQueue.main.async { [self] in
                        
                        nameLabel.text = data.title
                    }
                    //goto form page and init data
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "kAddItemFormVC") as? AddItemFormVC {
                        vc.item = data
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }

                    
                    break
                    
                case .failure(let err):
                    let alert = UIAlertController(title: "Alert", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                            case .default:
                            print("default")
                            
                            case .cancel:
                            print("cancel")
                            
                            case .destructive:
                            print("destructive")
                            
                        @unknown default: break
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    break
                    
                default:
                    //show error and goto form page
                   break
                }
            });
        }
	
}
