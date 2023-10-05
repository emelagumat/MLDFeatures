#if canImport(UIKit)
import UIKit
#endif

import SwiftUI
// import Foundation
class ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func set(_ image: UIImage?, forKey key: String) {
        guard let image else { return }
        cache.setObject(image, forKey: key as NSString)
    }

    func get(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
}

#if canImport(AppKit)
import AppKit
public typealias UIImage = NSImage
public extension Image {
    init(uiImage: UIImage) {
        self.init(nsImage: uiImage)
    }
}
#endif
