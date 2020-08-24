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
    var brawlerStarPowers: [String] = []
    var brawlerGadgets: [String] = []

    var activityIndicatorView = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicatorView.showActivityIndicator(view: view)
        brawlerNameLabel.text = brawlerName
        starPowerLabel.text = "Star Powers: \(self.brawlerStarPowers.joined(separator: "\n"))"
        gadgetLabel.text = "Star Powers: \(self.brawlerGadgets.joined(separator: "\n"))"
        activityIndicatorView.hideActivityIndicator()
    }
}
