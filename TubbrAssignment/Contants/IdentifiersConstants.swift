//
//  IdentifiersConstants.swift
//  TubbrAssignment
//
//  Created by Gaurav Kabra on 10/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
public struct NIBNames {
    static let SpotifyTrackCollectionViewCellNib = "SpotifyTrackCollectionViewCell"
}

public struct NIBIdentifier {
    static let SpotifyCellIdentifier = "spotifyCellIdentifier"
}

var fileName: String {
    set {
        UserDefaults.standard.set(newValue, forKey: "DownloadedTrackFile")
        UserDefaults.standard.synchronize()
    }
    get {
        return UserDefaults.standard.string(forKey: "DownloadedTrackFile") ?? ""
    }
}

var bearerToken: String {
    set {
        UserDefaults.standard.set(newValue, forKey: "bearerToken")
        UserDefaults.standard.synchronize()
    }
    get {
        return UserDefaults.standard.string(forKey: "bearerToken") ?? ""
    }
}

extension UserDefaults {
    func imageForKey(key: String) -> UIImage? {
        var image: UIImage?
        if let imageData = data(forKey: key) {
            image = NSKeyedUnarchiver.unarchiveObject(with: imageData) as? UIImage
        }
        return image
    }
    func setImage(image: UIImage?, forKey key: String) {
        var imageData: NSData?
        if let image = image {
            imageData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData?
        }
        set(imageData, forKey: key)
    }
}
