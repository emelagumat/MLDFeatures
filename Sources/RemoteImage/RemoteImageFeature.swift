
import ComposableArchitecture
import SwiftUI

public struct RemoteImageFeature: Reducer {
    @Dependency(\.environment) var environment
    
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
        
        if let uiImage {
            state.image = Image(uiImage: uiImage)
        } else {
            state.image = state.placeholder
        }
        
        return .none
    }
}

// MARK: - State
public extension RemoteImageFeature {
    struct State: Equatable, Identifiable {
        public let id: UUID = .init()
        
        var image: Image
        var imageStringURL: String
        var placeholder: Image
        var isLoading: Bool
        var redactedReasons: RedactionReasons = []
        
        public init() {
            self.init(
                image: .init(uiImage: .init()),
                imageStringURL: "",
                placeholder: .init(uiImage: .init()),
                isLoading: false
            )
        }
        
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
public extension RemoteImageFeature {
    enum Action: Equatable {
        case onAppear
        case onGetStringURL(String)
        case onLoaded(UIImage?)
    }
}
