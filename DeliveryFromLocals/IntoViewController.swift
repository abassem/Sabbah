//
//  IntoViewController.swift
//  DeliveryFromLocals
//
//  Created by Abdo Assem on 12/20/16.
//  Copyright © 2016 Max Bachinskiy. All rights reserved.
//

import UIKit
import Material
class IntoViewController: UIViewController {
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        prepareTabBarItem()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.red.base
    }
}

extension IntoViewController {
    fileprivate func prepareTabBarItem() {
        tabBarItem.image = Icon.cm.photoCamera?.tint(with: Color.blueGrey.base)
        tabBarItem.selectedImage = Icon.cm.photoCamera?.tint(with: Color.blue.base)
    }

}
