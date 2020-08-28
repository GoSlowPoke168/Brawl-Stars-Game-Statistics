//
//  BrawlerInfoViewController.swift
//  Brawl Stars Game Stats
//
//  Created by Jeremy on 8/17/20.
//  Copyright © 2020 Jeremy. All rights reserved.
//

import UIKit

class BrawlerInfoViewController: UIViewController {
    @IBOutlet var brawlerNameLabel: UILabel!
    @IBOutlet var starPowerLabel: UILabel!
    @IBOutlet var gadgetLabel: UILabel!
    
    var brawlerName: String = ""
    var brawlerGadgets: [Gadget] = []
    var brawlerStarPowers: [StarPowers] = []

    var activityIndicatorView = ActivityIndicator()
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicatorView.showActivityIndicator(view: view)
        brawlerNameLabel.text = brawlerName
                
        var starPowerString = String("Star Powers: ")
        for starPower in brawlerStarPowers {
            starPowerString.append("\(starPower.name ?? "") ")
        }
        starPowerLabel.text = starPowerString
        
        var gadgetString = String("Gadgets: ")
        for gadget in brawlerGadgets {
            gadgetString.append("\(gadget.name ?? "") ")
        }
        gadgetLabel.text = gadgetString
        
        activityIndicatorView.hideActivityIndicator()
    }
}
