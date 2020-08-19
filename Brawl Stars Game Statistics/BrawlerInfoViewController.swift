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
    var brawlerID = ""
    var activityIndicatorView = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brawlerName = ""
        brawlerStarPowers = []
        brawlerGadgets = []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getInfo("brawlers/\(brawlerID)")
    }

    func getInfo(_ urlEndpoint: String) {
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
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
//                        print(jsonResult)
                        if let name = jsonResult["name"] as? String {
                            print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                            print("Brawler Name: \(name)")
                            self.brawlerName = name
                        }
                        if let gadgets = jsonResult["gadgets"] as? [[String:Any]]{
                            gadgets.forEach { gadget in
                                print("Gadget: \(gadget["name"]!)")
                                self.brawlerGadgets.append("\(gadget["name"] ?? "")")
                            }
                        }
                        if let starPowers = jsonResult["starPowers"] as? [[String:Any]] {
                            starPowers.forEach { starPower in
                                print("Star Power: \(starPower["name"]!)")
                                self.brawlerStarPowers.append("\(starPower["name"] ?? "")")
                            }
                        }
                    } catch {
                        print("JSON processing failed: \(error.localizedDescription)")
                    }
                }
                DispatchQueue.main.async {
                    self.brawlerNameLabel.text = self.brawlerName
                    self.gadgetLabel.text = "Star Powers: \(self.brawlerGadgets.joined(separator: "\n"))"
                    self.starPowerLabel.text = "Gadgets: \(self.brawlerStarPowers.joined(separator: "\n"))"
                }
            }.resume()
        } else {
            print("Something went wrong")
        }
    }
}
