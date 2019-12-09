//
//  MyMenuViewController.swift
//  SwiftLeeTools_Example
//
//  Created by 350541732 on 11/26/2019.
//  Copyright (c) 2019 350541732. All rights reserved.
//

import UIKit
import SwiftLeeTools

class MyMenuViewController: BaseMenuUICollectionViewViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.resourceArray = [
            ["title": "item1", "image": "AppIcon","num":"1"],
            ["title": "item2", "image": "AppIcon","num":"10"],
            ["title": "item3", "image": "AppIcon","num":"5"],
            ["title": "item4", "image": "AppIcon","num":"90"],
            ["title": "item5", "image": "AppIcon","num":"33"],
        ]
    }
    

}
