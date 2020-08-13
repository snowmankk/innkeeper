//
//  ExUIImage.swift
//  innkeeper
//
//  Created by orca on 2020/08/12.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

extension UIImage {
    func cropped(boundingBox: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage?.cropping(to: boundingBox) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}

