//
//  Person.swift
//  Project10
//
//  Created by Sandesh on 29/12/19.
//  Copyright © 2019 Sandesh. All rights reserved.
//

import UIKit

class Person: NSObject {

    var name: String
    var image: String
    
    init(name: String, image:String) {
        self.name = name
        self.image = image 
    }
}
