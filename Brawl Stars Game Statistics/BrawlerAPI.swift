//
//  BrawlerAPI.swift
//  Brawl Stars Game Statistics
//
//  Created by Jeremy on 8/24/20.
//  Copyright © 2020 Jeremy. All rights reserved.
//

import Foundation

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

protocol BrawlerItemsProtocol {
    func BrawlerItemsReceivedAndParsed(_ itemsArray: [Item])
}

class BrawlerAPI {

    class func getItems(_ apiFunction: String, sender: BrawlerItemsProtocol) {
        let apiToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6ImFkOTdhNmMwLTZmMGMtNDkwOS1iZTk1LTI2Yjg2ZDdhMjI3ZCIsImlhdCI6MTU5ODU4MjI1OSwic3ViIjoiZGV2ZWxvcGVyLzQ5MzVhYjAyLTY4YzEtMzQ3YS1kOTllLWNkOGQ0ODI2NDg5ZiIsInNjb3BlcyI6WyJicmF3bHN0YXJzIl0sImxpbWl0cyI6W3sidGllciI6ImRldmVsb3Blci9zaWx2ZXIiLCJ0eXBlIjoidGhyb3R0bGluZyJ9LHsiY2lkcnMiOlsiNzEuNTguNDEuMjI0Il0sInR5cGUiOiJjbGllbnQifV19.pXQaNVR7y-2jdTP2TXdRMhh1bbzlDxsXj1SxGLF2gQQ8vSNY3GV5NNUrEycnPljL_bCvC7Mr95MRXNfldmsB6w"

        if let url = URL(string: "https://api.brawlstars.com/v1/\(apiFunction)") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Bearer \(apiToken)", forHTTPHeaderField: "authorization")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    guard let data = data else {return}
                    let decoder = JSONDecoder()
                    do {
                        let items = try decoder.decode(Items.self, from: data)
                        sender.BrawlerItemsReceivedAndParsed(items.items)
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
