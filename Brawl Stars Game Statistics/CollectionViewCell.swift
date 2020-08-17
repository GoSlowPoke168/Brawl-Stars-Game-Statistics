//
//  CollectionViewCell.swift
//  Brawl Stars Game Stats
//
//  Created by Jeremy on 8/16/20.
//  Copyright © 2020 Jeremy. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet private var brawlerNameLabel: UILabel!
    
    func configure(with brawlerName: String) {
        brawlerNameLabel.text = brawlerName
    }
}
