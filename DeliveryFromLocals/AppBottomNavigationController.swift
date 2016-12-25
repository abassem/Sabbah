//
//  AppBottomNavigationController.swift
//  DeliveryFromLocals
//
//  Created by Abdo Assem on 12/20/16.
//  Copyright © 2016 Max Bachinskiy. All rights reserved.
//

import UIKit
import Material
class AppBottomNavigationController: BottomNavigationController {

    open override func prepare() {
        super.prepare()
        prepareTabBar()
    }
}

extension AppBottomNavigationController {
    fileprivate func prepareTabBar() {
        tabBar.depthPreset = .none
        tabBar.dividerColor = Color.grey.lighten3
    }
}
