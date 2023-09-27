
import SwiftUI
import ComposableArchitecture

public struct RemoteImageEnvironment {
    /// The object conforming to `ImageProvider` that handles the image loading logic.
    public var loader: ImageProvider
    /// An optional placeholder image to be shown while the main image is being loaded.
    public var placeholder: Image?
    /// A flag indicating whether redaction should be applied to the image while loading.
    public var redactionEnabled: Bool
    /// A flag indicating whether caching is enabled for image loading.
    public var cacheEnabled: Bool
}
