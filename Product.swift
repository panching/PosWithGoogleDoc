//
//  Product.swift
//  PosPC
//
//  Created by ChingPan on 2016/12/15.
//  Copyright © 2016年 pan. All rights reserved.
//

import Foundation
import UIKit

class Product{
    
    var itemImage = UIImage(named: "drink")
    var itemName = ""
    var itemMoney = 0
    
    init(image:UIImage,name:String,money:Int) {
        itemImage = image
        itemName = name
        itemMoney = money
    }
    convenience init(name:String,money:Int) {
        self.init(image:UIImage(named: "drink")!,name:name,money:money)
    }
    
}


