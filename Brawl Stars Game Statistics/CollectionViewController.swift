//
//  CollectionViewController.swift
//  Brawl Stars Game Stats
//
//  Created by Jeremy on 8/16/20.
//  Copyright © 2020 Jeremy. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, BrawlerItemsProtocol {
    
    @IBOutlet var collectionViewOutlet: UICollectionView!
    
    var jsonItems: [Item] = []
    var selectedIndex: Int = 0
    var activityIndicatorView = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BrawlerAPI.getItems("brawlers", sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToBrawlerInfoVC" {
            guard let vc = segue.destination as? BrawlerInfoViewController else {return}
            vc.brawlerName = jsonItems[selectedIndex].name ?? ""
            vc.brawlerGadgets = jsonItems[selectedIndex].gadgets
            vc.brawlerStarPowers = jsonItems[selectedIndex].starPowers
        }
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsonItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let brawlerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
            brawlerCell.configure(with: jsonItems[indexPath.row].name ?? "")
            cell = brawlerCell
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedIndex = indexPath.row
        print("Selected Brawler: \(jsonItems[indexPath.row].name ?? "")")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "goToBrawlerInfoVC", sender: self)
        }
        return true
    }
    
    // MARK: - BrawlerAPI Delegate Function
    
    func BrawlerItemsReceivedAndParsed(_ itemsArray: [Item]) {
        jsonItems = itemsArray
        DispatchQueue.main.async {
             self.collectionViewOutlet.reloadData()
        }
    }
    
}
