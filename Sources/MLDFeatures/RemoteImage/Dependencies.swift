import SwiftUI
import ComposableArchitecture

public extension RemoteImageEnvironment {
    enum Key: DependencyKey {
        static public var liveValue = RemoteImageEnvironment(
            loader: ImageProviderImpl(),
            placeholder: Image(systemName: "rectangle.portrait.slash"),
            redactionEnabled: true,
            cacheEnabled: true
        )

        public static var testValue = liveValue
    }
}

public extension DependencyValues {
    var environment: RemoteImageEnvironment {
        get { self[RemoteImageEnvironment.Key.self] }
        set { self[RemoteImageEnvironment.Key.self] = newValue }
    }
}
