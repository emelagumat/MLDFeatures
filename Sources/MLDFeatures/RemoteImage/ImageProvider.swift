
import SwiftUI

/// A protocol defining the methods for loading an image, either by URL or string URL.
public protocol ImageProvider {
    /// Asynchronously fetches an image from the provided string URL. If `storeInCache` is true, the method first looks for the image in the cache before fetching.
    func loadImage(stringURL: String, storeInCache: Bool) async -> UIImage?
    
    /// Asynchronously fetches an image from the provided URL. If `storeInCache` is true, the method first looks for the image in the cache before fetching.
    func loadImage(url: URL, storeInCache: Bool) async -> UIImage?
}

/// Provides default implementations for loading images with caching enabled.
public extension ImageProvider {
    /// Fetches an image asynchronously from cache or the given string URL
    func loadImage(stringURL: String) async -> UIImage? {
        await loadImage(stringURL: stringURL, storeInCache: true)
    }
    /// Fetches an image asynchronously from cache or the given URL
    func loadImage(url: URL) async -> UIImage? {
        await loadImage(url: url, storeInCache: true)
    }
}

final class ImageProviderImpl: ImageProvider {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }

    public func loadImage(stringURL: String, storeInCache: Bool) async -> UIImage? {
        guard let url = URL(string: stringURL) else { return nil }
        return await loadImage(url: url, storeInCache: storeInCache)
    }

    public func loadImage(url: URL, storeInCache: Bool) async -> UIImage? {
        do {
            let request = URLRequest(url: url)
            let data = try await session.data(for: request).0
            return await Task { @MainActor in
                let image = UIImage(data: data)
                ImageCache.shared.set(image, forKey: url.absoluteString)
                return image
            }.value
        } catch {
            return nil
        }
    }
}
