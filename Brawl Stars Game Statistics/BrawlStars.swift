//
//  BrawlStars.swift
//  Brawl Stars Game Stats
//
//  Created by Jeremy on 8/17/20.
//  Copyright © 2020 Jeremy. All rights reserved.
//

import Foundation
import UIKit


class BrawlStars {
    class func getData(_ urlEndpoint: String) {
        let apiToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6IjM0YTM1NjA4LTljM2EtNDhiYi04ZmNhLWZlNDBhYWVlODIwNiIsImlhdCI6MTU5NjUwNzUyOSwic3ViIjoiZGV2ZWxvcGVyLzQ5MzVhYjAyLTY4YzEtMzQ3YS1kOTllLWNkOGQ0ODI2NDg5ZiIsInNjb3BlcyI6WyJicmF3bHN0YXJzIl0sImxpbWl0cyI6W3sidGllciI6ImRldmVsb3Blci9zaWx2ZXIiLCJ0eXBlIjoidGhyb3R0bGluZyJ9LHsiY2lkcnMiOlsiMTUyLjIwOC43LjIyOCJdLCJ0eXBlIjoiY2xpZW50In1dfQ.qKN5_5v4xyW1Xq9xnA_7M9zC3LNN-c2eF-EtZuJV0kcWjtsrYX5gck5ur3YsoCcxdQSyeOFD-VMGHQ2XGWW88A"

        if let url = URL(string: "https://api.brawlstars.com/v1/\(urlEndpoint)") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "authorization")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    guard let data = data else {return}
                    do {
//                        let decoded = try JSONDecoder().decode([String:[Item]].self, from: data)
//                        let items = decoded["items"]!
//                        let element = items.first!
//                        for starPower in element.starPowers {
//                            print(starPower.name)
//                        }
//                        for gadget in element.gadgets {
//                            print(gadget.name)
//                        }
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
//                        print(jsonResult)
                        
                        if let items = jsonResult["items"] as? NSArray {
                            for item in items as [AnyObject] {
                                if let name = item["name"] {
                                    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                                    print("Brawler Name: \(name!)")
                                    if let brawlerID = item["id"] {
                                        print("Brawler ID: \(brawlerID!)")
                                    }
                                }
                                if let gadgets = item["gadgets"] as? [[String:Any]]{
//                                    print(gadgets)
                                    gadgets.forEach { gadget in
//                                        print(gadget["id"]!)
                                        print("Gadget: \(gadget["name"]!)")
                                    }
                                }
                                if let starPowers = item["starPowers"] as? [[String:Any]] {
//                                    print(starPowers)
                                    starPowers.forEach { starPower in
//                                        print(starPower["id"]!)
                                        print("Star Power: \(starPower["name"]!)")
                                    }
                                }
                            }
                        }
                    } catch {
                        print("JSON processing failed: \(error.localizedDescription)")
                    }
                }
            }.resume()
        } else {
            print("Something went wrong")
        }
    }
}
