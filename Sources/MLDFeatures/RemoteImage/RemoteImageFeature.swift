import ComposableArchitecture
import SwiftUI

/// A Reducer for managing remote image state and loading.
public struct RemoteImageFeature: Reducer {

    /// Dependency to access external environment like image loading.
    @Dependency(\.environment) var environment
    
    /// Initializes a new `RemoteImageFeature`.
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                .none
                
            case let .onGetStringURL(url):
                if url == state.imageStringURL { .none }
                else {
                    makeNewURLEffect(
                        into: &state,
                        with: url
                    )
                }
                
            case let .onLoaded(uiImage):
                imageLoadedEffect(
                    state: &state,
                    uiImage: uiImage
                )
            }
        }
    }
    
    private func makeNewURLEffect(into state: inout State, with stringURL: String) -> Effect<Action> {
        state.imageStringURL = stringURL
        state.isLoading = true
        state.redactedReasons = environment.redactionEnabled ? [.placeholder] : []
        return .run { send in
            let image = await environment.loader.loadImage(stringURL: stringURL)
            await send(.onLoaded(image))
        }
    }
    
    private func imageLoadedEffect(state: inout State, uiImage: UIImage?) -> Effect<Action> {
        state.isLoading = false
        state.redactedReasons = []
        
        if let uiImage = uiImage {
            state.image = Image(uiImage: uiImage)
        } else {
            state.image = state.placeholder
        }
        
        return .none
    }
}

// MARK: - State

/// Represents the state managed by `RemoteImageFeature`.
public extension RemoteImageFeature {
    struct State: Equatable, Identifiable {
        public let id: UUID = .init()
        
        /// The actual image to display. Defaults to empty image
        var image: Image
        
        /// URL as a string for the image. Defaults to empty string
        var imageStringURL: String
        
        /// Placeholder image while loading. Defaults to 􀣦
        var placeholder: Image
        
        /// Indicates whether the image is loading.
        var isLoading: Bool
        
        /// Redaction reasons, if any.
        var redactedReasons: RedactionReasons = []
        
        /// Initializes a new `State` with default values.
        public init() {
            self.init(
                image: .init(uiImage: .init()),
                imageStringURL: "",
                placeholder: .init(uiImage: .init()),
                isLoading: false
            )
        }
        
        /// Initializes a new `State`.
        public init(
            image: Image = .init(uiImage: .init()),
            imageStringURL: String,
            placeholder: Image = .init(uiImage: .init()),
            isLoading: Bool = false
        ) {
            self.imageStringURL = imageStringURL
            self.image = image
            self.placeholder = placeholder
            self.isLoading = isLoading
        }
    }
}

// MARK: - Action

/// Actions that can be performed on `RemoteImageFeature`.
public extension RemoteImageFeature {
    enum Action: Equatable {
        /// Triggered when the view appears.
        case onAppear
        
        /// Triggered when a new URL is set.
        case onGetStringURL(String)
        
        /// Triggered when the image is loaded.
        case onLoaded(UIImage?)
    }
}
