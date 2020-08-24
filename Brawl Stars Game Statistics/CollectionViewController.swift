//
//  CollectionViewController.swift
//  Brawl Stars Game Stats
//
//  Created by Jeremy on 8/16/20.
//  Copyright © 2020 Jeremy. All rights reserved.
//

import UIKit

struct Items: Codable {
    let items: [Item]
}

struct Item: Codable {
    let id: Int?
    let name: String?
    let gadgets: [Gadget]
    let starPowers: [StarPowers]
}

struct Gadget: Codable {
    let id: Int?
    let name: String?
}

struct StarPowers: Codable {
    let id: Int?
    let name: String?
}

class CollectionViewController: UICollectionViewController {
    
    @IBOutlet var collectionViewOutlet: UICollectionView!
    
    var brawlerNames: [String] = []
    var selectedBrawlerName: String = ""
    var selectedBrawlerGadgets: [String] = []
    var selectedBrawlerStarPowers: [String] = []
    var activityIndicatorView = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        BrawlStars.getData("brawlers")
        getNames("brawlers")
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToBrawlerInfoVC" {
            guard let vc = segue.destination as? BrawlerInfoViewController else {return}
            vc.brawlerName = selectedBrawlerName
            vc.brawlerGadgets = selectedBrawlerGadgets
            vc.brawlerStarPowers = selectedBrawlerStarPowers
        }
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brawlerNames.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let brawlerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
            brawlerCell.configure(with: brawlerNames[indexPath.row])
            cell = brawlerCell
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let selectedBrawler = indexPath.row
        print("Selected Brawler: \(brawlerNames[indexPath.row])")
        selectedBrawlerName = brawlerNames[indexPath.row]
        getBrawlerInfo("brawlers", selectedBrawler)
        return true
    }
    
    // MARK: - GetNames
    
    func getNames(_ urlEndpoint: String) {
        activityIndicatorView.showActivityIndicator(view: view)
        let apiToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6IjM0YTM1NjA4LTljM2EtNDhiYi04ZmNhLWZlNDBhYWVlODIwNiIsImlhdCI6MTU5NjUwNzUyOSwic3ViIjoiZGV2ZWxvcGVyLzQ5MzVhYjAyLTY4YzEtMzQ3YS1kOTllLWNkOGQ0ODI2NDg5ZiIsInNjb3BlcyI6WyJicmF3bHN0YXJzIl0sImxpbWl0cyI6W3sidGllciI6ImRldmVsb3Blci9zaWx2ZXIiLCJ0eXBlIjoidGhyb3R0bGluZyJ9LHsiY2lkcnMiOlsiMTUyLjIwOC43LjIyOCJdLCJ0eXBlIjoiY2xpZW50In1dfQ.qKN5_5v4xyW1Xq9xnA_7M9zC3LNN-c2eF-EtZuJV0kcWjtsrYX5gck5ur3YsoCcxdQSyeOFD-VMGHQ2XGWW88A"

        if let url = URL(string: "https://api.brawlstars.com/v1/\(urlEndpoint)") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "authorization")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                self.activityIndicatorView.hideActivityIndicator()
                if error != nil {
                    print(error!)
                } else {
                    guard let data = data else {return}
                    let decoder = JSONDecoder()
                    do {
                        let items = try decoder.decode(Items.self, from: data)
                        for i in items.items {
                            if let brawlerName = i.name {
//                                print(brawlerName)
                                self.brawlerNames.append(brawlerName)
                            }
                        }
                    } catch {
                        print("JSON processing failed: \(error.localizedDescription)")
                    }
                }
                DispatchQueue.main.async {
                    self.collectionViewOutlet.reloadData()
                }
            }.resume()
        } else {
            print("Something went wrong")
        }
    }
    
    // MARK: - GetBrawlerInfo
    
    func getBrawlerInfo(_ urlEndpoint: String, _ selectedBrawler: Int) {
        activityIndicatorView.showActivityIndicator(view: view)
        selectedBrawlerGadgets = []
        selectedBrawlerStarPowers = []
        let apiToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6IjM0YTM1NjA4LTljM2EtNDhiYi04ZmNhLWZlNDBhYWVlODIwNiIsImlhdCI6MTU5NjUwNzUyOSwic3ViIjoiZGV2ZWxvcGVyLzQ5MzVhYjAyLTY4YzEtMzQ3YS1kOTllLWNkOGQ0ODI2NDg5ZiIsInNjb3BlcyI6WyJicmF3bHN0YXJzIl0sImxpbWl0cyI6W3sidGllciI6ImRldmVsb3Blci9zaWx2ZXIiLCJ0eXBlIjoidGhyb3R0bGluZyJ9LHsiY2lkcnMiOlsiMTUyLjIwOC43LjIyOCJdLCJ0eXBlIjoiY2xpZW50In1dfQ.qKN5_5v4xyW1Xq9xnA_7M9zC3LNN-c2eF-EtZuJV0kcWjtsrYX5gck5ur3YsoCcxdQSyeOFD-VMGHQ2XGWW88A"

        if let url = URL(string: "https://api.brawlstars.com/v1/\(urlEndpoint)") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "authorization")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                self.activityIndicatorView.hideActivityIndicator()
                if error != nil {
                    print(error!)
                } else {
                    guard let data = data else {return}
                    let decoder = JSONDecoder()
                    do {
                        let items = try decoder.decode(Items.self, from: data)
                        let brawlerArray = items.items[selectedBrawler]
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
                    } catch {
                        print("JSON processing failed: \(error.localizedDescription)")
                    }
                }
                DispatchQueue.main.async {
                    self.collectionViewOutlet.reloadData()
                    self.performSegue(withIdentifier: "goToBrawlerInfoVC", sender: self)

                }
            }.resume()
        } else {
            print("Something went wrong")
        }
    }
}
