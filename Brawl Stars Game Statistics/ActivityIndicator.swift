
//
//  ActivityIndicator.swift
//  Brawl Stars Game Statistics
//
//  Created by Jeremy on 8/18/20.
//  Copyright © 2020 Jeremy. All rights reserved.
//

import UIKit

//     func hideActivityIndicator() {
//            DispatchQueue.main.async {
//    //            let activityIndicatorView = UIActivityIndicatorView(style: .large)
//    //            activityIndicatorView.frame = self.view.frame
//    //            activityIndicatorView.hidesWhenStopped = true
//                activityIndicatorView.stopAnimating()
//            }
//        }
    
//    func hideActivityIndicator() {
//        DispatchQueue.main.async {
////            let activityIndicatorView = UIActivityIndicatorView(style: .large)
////            activityIndicatorView.frame = self.view.frame
////            activityIndicatorView.hidesWhenStopped = true
//            activityIndicatorView.stopAnimating()
//        }
//    }

class ActivityIndicator {
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    func showActivityIndicator(view: UIView) {
       activityIndicatorView.frame = view.frame
       activityIndicatorView.hidesWhenStopped = true
       view.addSubview(activityIndicatorView)
       activityIndicatorView.startAnimating()
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
        }
    }
}

