import SwiftUI
import ComposableArchitecture

/**
 A specialized View for handling remote image loading in a SwiftUI application.
  
  ### Overview:
  
  RemoteImage leverages its environment to adapt its behavior according to specific configurations, such as whether caching is enabled.
  
  ### Store Initialization:
  
  The store can be either created independently or scoped from a parent store.
  
  #### Examples:
  
    - Without a parent store:
     
 ```swift
  let remoteImageStore = StoreOf<RemoteImageFeature>(
      initialState: .init(imageStringURL: "your_image_url"),
      reducer: RemoteImageFeature()
  )
  
  RemoteImage(store: remoteImageStore)
 ```
 
    - With parent store:
 
 ```swift
 public struct MyView: View {
     let store: StoreOf<MyViewFeature>
     
     public var body: some View {
         WithViewStore(store, observe: \.imageStringURL) { url in
             RemoteImage(
                 store: store.scope(
                     state: \.image,
                     action: MyViewFeature.Action.image
                 )
             )
         }
     }
 }
 ```
 
 ### Environment
 The RemoteImageEnvironment struct allows you to configure the RemoteImage view according to your needs. It comes with a default image provider, but you can provide your own, especially if you require advanced configurations like authentication. The environment also enables redaction and caching by default.

 Example to change redaction value:
 
 ```swift
 let feature = RemoteImageFeature()
     .dependency(\.environment.redactionEnabled, false)
 ```
 
 ### Image modifiers:
 - ``resizable()``
 - ``contentMode(_:)``
 
*/
public struct RemoteImage: View {
    let store: StoreOf<RemoteImageFeature>

    private var isResizable = false
    private var contentMode: ContentMode = .fit

    public init(store: StoreOf<RemoteImageFeature>) {
        self.store = store

        let feature = RemoteImageFeature()
            .dependency(\.environment.redactionEnabled, false)
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
    /// Makes the image resizable
    func resizable() -> RemoteImage {
        var copy = self
        copy.isResizable = true
        return copy
    }
    /// Sets the content mode for displaying the image
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
