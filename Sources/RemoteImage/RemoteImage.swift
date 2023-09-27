
import SwiftUI
import ComposableArchitecture

public struct RemoteImage: View {
    let store: StoreOf<RemoteImageFeature>
    
    private var isResizable = false
    private var contentMode: ContentMode = .fit
    
    public init(store: StoreOf<RemoteImageFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(
            self.store,
            observe: { $0 }
        ) { viewStore in
            (viewStore.image)
                .modifyIf(isResizable, apply: { $0.resizable() })
                .aspectRatio(contentMode: contentMode)
                .redacted(reason: viewStore.redactedReasons)
                .task { @MainActor in
                    viewStore.send(.onAppear)
                }
        }
    }
}

public extension RemoteImage {
    func resizable() -> RemoteImage {
        var copy = self
        copy.isResizable = true
        return copy
    }
    
    func contentMode(_ contentMode: ContentMode) -> RemoteImage {
        var copy = self
        copy.contentMode = contentMode
        return copy
    }
}

extension View {
    @ViewBuilder
    func modifyIf<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }
}
