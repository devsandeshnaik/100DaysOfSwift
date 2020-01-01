//
//  DetailVC.swift
//  Day50 Milestone
//
//  Created by Sandesh on 01/01/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var path: String?
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if path != nil {
            if let image = UIImage(contentsOfFile: path!) {
                imageView.image = image
            } else {
                let alert = UIAlertController(title: "Image Not Found!", message: "Unable to find the image you have requested", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.dismiss(animated: true)
                }
                alert.addAction(alertAction)
                present(alert, animated:  true)
            }
        } else {
            fatalError("You forgot to set image path")
        }
    }
    

   
}
