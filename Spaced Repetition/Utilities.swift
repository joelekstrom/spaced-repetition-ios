//
//  Utilities.swift
//  Spaced Repetition
//
//  Created by Johannes Warn on 2019-08-09.
//  Copyright © 2019 Johannes Wärn. All rights reserved.
//

import UIKit
import Photos

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIImage {
    class func imageWithLayer(layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func clearImageWithSize(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func imageWithCircle(radius: CGFloat, color: UIColor = .black) -> UIImage? {
        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = color.cgColor
        circleLayer.bounds = CGRect(origin: .zero, size: CGSize(width: radius * 2.0, height: radius * 2.0))
        circleLayer.path = UIBezierPath.init(ovalIn: CGRect(origin: .zero, size: CGSize(width: radius * 2.0, height: radius * 2.0))).cgPath
        return imageWithLayer(layer: circleLayer)
    }
}

extension UIActivityViewController {
    func addSaveToCameraRollErrorCompletion() {
        self.completionWithItemsHandler = { activity, _, _, _ in
            if activity == UIActivity.ActivityType.saveToCameraRoll {
                if PHPhotoLibrary.authorizationStatus() == .authorized {
                    self.isEditing = false
                } else {
                    let alertController = UIAlertController(title: "Unable to Save Photos", message: "You need to allow Spaced Repetion acces to your photos to use Save Images.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (_) in
                        UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                    }))
                    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alertController, animated: true)
                }
            } else {
                self.isEditing = false
            }
        }
    }
}
