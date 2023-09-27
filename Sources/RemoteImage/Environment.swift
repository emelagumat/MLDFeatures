
import SwiftUI
import ComposableArchitecture

public struct RemoteImageEnvironment {
    public var loader: ImageProvider
    public var placeholder: Image?
    public var redactionEnabled: Bool
    public var cacheEnabled: Bool
}
