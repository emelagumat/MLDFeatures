
import SwiftUI

public protocol ImageProvider {
    func loadImage(stringURL: String, storeInCache: Bool) async -> UIImage?
    func loadImage(url: URL, storeInCache: Bool) async -> UIImage?
}

public extension ImageProvider {
    func loadImage(stringURL: String) async -> UIImage? {
        await loadImage(stringURL: stringURL, storeInCache: true)
    }
    
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
