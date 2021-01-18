//
//  SessionImageCache.swift
//  PokeBowl
//
//  Created by Bart Kneepkens on 16/01/2021.
//

import Foundation
import UIKit

/// A simple cache to keep images within a single session
class SessionImageCache {
    static let shared = SessionImageCache()
    
    private init() {}
    
    private var cache = NSCache<NSString, UIImage>()
    
    func get(for key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func set(image: UIImage, for key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
