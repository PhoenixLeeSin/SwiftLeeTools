//
//  MyAutoTableViewController.swift
//  SwiftLeeTools_Example
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import SwiftLeeTools

class MyAutoTableViewController: BaseAutoTableViewListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        url = "http://172.20.3.53:8919/toa/" +
        "toa/toaRestaurantFood_foodList.json"
        
        itemContent = [["key":"name","value":"名称"],
                       ["key":"id","value":"标识"],
                       ["key":"records","value":"记录"]
        ]
        
    }
    

}
