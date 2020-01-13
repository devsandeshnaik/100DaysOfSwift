//
//  Capital.swift
//  Project16
//
//  Created by Sandesh on 13/01/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {
    var title       :String?
    var coordinate  : CLLocationCoordinate2D
    var info        : String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title          = title
        self.coordinate     = coordinate
        self.info           = info
    }
}
