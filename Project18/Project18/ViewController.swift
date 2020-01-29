//
//  ViewController.swift
//  Project18
//
//  Created by Sandesh on 29/01/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(1,2,3,4,5, separator: "-")
        
        assert(1==1, "Math error ")
        
        for i in 1...100 {
            print("Got number\(i)")
        }
   
    }



}

