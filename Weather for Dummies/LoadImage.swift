//
//  LoadImage.swift
//  Weather for Dummies
//
//  Created by Matvey on 7/8/19.
//  Copyright © 2019 Matvey. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
