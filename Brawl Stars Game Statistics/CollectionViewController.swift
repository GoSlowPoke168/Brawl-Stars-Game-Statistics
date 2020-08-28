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
    
    var brawlerNames: [String] = []
    var selectedBrawlerName: String = ""
    var selectedBrawlerGadgets: [String] = []
    var selectedBrawlerStarPowers: [String] = []
    var activityIndicatorView = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getNames("brawlers")
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
//        return brawlerNames.count
        return jsonItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let brawlerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
//            brawlerCell.configure(with: brawlerNames[indexPath.row])
            brawlerCell.configure(with: jsonItems[indexPath.row].name ?? "")
            cell = brawlerCell
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        selectedIndex = indexPath.row
//        let selectedBrawler = indexPath.row
        print("Selected Brawler: \(jsonItems[indexPath.row].name ?? "")")
//        selectedBrawlerName = brawlerNames[indexPath.row]
//        getBrawlerInfo(selectedBrawler)
        DispatchQueue.main.async {
            //self.collectionViewOutlet.reloadData()
            self.performSegue(withIdentifier: "goToBrawlerInfoVC", sender: self)
        }
        return true
    }
    
    // MARK: - BrawlerAPI Delegate Function
    
    func BrawlerItemsReceivedAndParsed(_ itemsArray: [Item]) {
        jsonItems = itemsArray
        print(jsonItems.count)
        DispatchQueue.main.async {
             self.collectionViewOutlet.reloadData()
        }
        
    }
    
//    func getNames(_ urlEndpoint: String) {
//        activityIndicatorView.showActivityIndicator(view: view)
//        let apiToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6ImFkOTdhNmMwLTZmMGMtNDkwOS1iZTk1LTI2Yjg2ZDdhMjI3ZCIsImlhdCI6MTU5ODU4MjI1OSwic3ViIjoiZGV2ZWxvcGVyLzQ5MzVhYjAyLTY4YzEtMzQ3YS1kOTllLWNkOGQ0ODI2NDg5ZiIsInNjb3BlcyI6WyJicmF3bHN0YXJzIl0sImxpbWl0cyI6W3sidGllciI6ImRldmVsb3Blci9zaWx2ZXIiLCJ0eXBlIjoidGhyb3R0bGluZyJ9LHsiY2lkcnMiOlsiNzEuNTguNDEuMjI0Il0sInR5cGUiOiJjbGllbnQifV19.pXQaNVR7y-2jdTP2TXdRMhh1bbzlDxsXj1SxGLF2gQQ8vSNY3GV5NNUrEycnPljL_bCvC7Mr95MRXNfldmsB6w"
//
//        if let url = URL(string: "https://api.brawlstars.com/v1/\(urlEndpoint)") {
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//            request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "authorization")
//            request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                self.activityIndicatorView.hideActivityIndicator()
//                if error != nil {
//                    print(error!)
//                } else {
//                    guard let data = data else {return}
//                    let decoder = JSONDecoder()
//                    do {
//                        let items = try decoder.decode(Items.self, from: data)
//                        self.jsonItems = items.items
//                        for i in items.items {
//                            if let brawlerName = i.name {
////                                print(brawlerName)
//                                self.brawlerNames.append(brawlerName)
//                            }
//                        }
//                    } catch {
//                        print("JSON processing failed: \(error.localizedDescription)")
//                    }
//                }
//                DispatchQueue.main.async {
//                    self.collectionViewOutlet.reloadData()
//                }
//            }.resume()
//        } else {
//            print("Something went wrong")
//        }
//    }
    
    // MARK: - GetBrawlerInfo
    
    func getBrawlerInfo(_ selectedBrawler: Int) {
        selectedBrawlerGadgets = []
        selectedBrawlerStarPowers = []

        let brawlerArray = jsonItems[selectedBrawler]
        for gadget in brawlerArray.gadgets {
            if let gadgetName = gadget.name {
                print(gadgetName)
                self.selectedBrawlerGadgets.append(gadgetName)
            }
        }
        for starPower in brawlerArray.starPowers {
            if let starPowerName = starPower.name {
                print(starPowerName)
                self.selectedBrawlerStarPowers.append(starPowerName)
            }
        }
        DispatchQueue.main.async {
            self.collectionViewOutlet.reloadData()
            self.performSegue(withIdentifier: "goToBrawlerInfoVC", sender: self)
        }
    }
}
