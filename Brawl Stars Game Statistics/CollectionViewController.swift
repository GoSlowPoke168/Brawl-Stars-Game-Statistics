//
//  CollectionViewController.swift
//  Brawl Stars Game Stats
//
//  Created by Jeremy on 8/16/20.
//  Copyright © 2020 Jeremy. All rights reserved.
//

import UIKit


class CollectionViewController: UICollectionViewController {
    
    @IBOutlet var collectionViewOutlet: UICollectionView!
    
    var brawlerIDs: [String] = []
    var brawlerNames: [String] = []
    var selectedBrawlerID: String = ""
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    override func viewDidAppear(_ animated: Bool) {
//        BrawlStars.getData("brawlers")
        activityIndicatorView.frame = view.frame
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = .systemTeal
        
        brawlerIDs = []
        getData("brawlers")
        selectedBrawlerID = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         Uncomment the following line to preserve selection between presentations
//         self.clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToBrawlerInfoVC" {
            guard let vc = segue.destination as? BrawlerInfoViewController else {return}
            vc.brawlerID = selectedBrawlerID
        }
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brawlerIDs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if let brawlerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
//            brawlerCell.configure(with: brawlerIDs[indexPath.row])
            brawlerCell.configure(with: brawlerNames[indexPath.row])
            cell = brawlerCell
        }
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print("Selected Brawler: \(brawlerIDs[indexPath.row])")
        selectedBrawlerID = brawlerIDs[indexPath.row]
        performSegue(withIdentifier: "goToBrawlerInfoVC", sender: self)
        return true
    }
    
    // MARK: - ActivityIndicator

    func showActivityIndicator() {
        self.view.addSubview(activityIndicatorView)
        self.activityIndicatorView.startAnimating()
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    // MARK: - GetData
    
    func getData(_ urlEndpoint: String) {
        showActivityIndicator()
        let apiToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6IjM0YTM1NjA4LTljM2EtNDhiYi04ZmNhLWZlNDBhYWVlODIwNiIsImlhdCI6MTU5NjUwNzUyOSwic3ViIjoiZGV2ZWxvcGVyLzQ5MzVhYjAyLTY4YzEtMzQ3YS1kOTllLWNkOGQ0ODI2NDg5ZiIsInNjb3BlcyI6WyJicmF3bHN0YXJzIl0sImxpbWl0cyI6W3sidGllciI6ImRldmVsb3Blci9zaWx2ZXIiLCJ0eXBlIjoidGhyb3R0bGluZyJ9LHsiY2lkcnMiOlsiMTUyLjIwOC43LjIyOCJdLCJ0eXBlIjoiY2xpZW50In1dfQ.qKN5_5v4xyW1Xq9xnA_7M9zC3LNN-c2eF-EtZuJV0kcWjtsrYX5gck5ur3YsoCcxdQSyeOFD-VMGHQ2XGWW88A"

        if let url = URL(string: "https://api.brawlstars.com/v1/\(urlEndpoint)") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "authorization")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                self.hideActivityIndicator()
                if error != nil {
                    print(error!)
                } else {
                    guard let data = data else {return}
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                        if let items = jsonResult["items"] as? NSArray {
                            for item in items as [AnyObject] {
                                if let name = item["name"] {
//                                    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
//                                    print("Brawler Name: \(name!)")
                                    self.brawlerNames.append("\(name ?? "")")
                                }
                                if let brawlerID = item["id"] {
//                                    print("Brawler ID: \(brawlerID!)")
                                    self.brawlerIDs.append("\(brawlerID ?? "")")
                                }
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
}

