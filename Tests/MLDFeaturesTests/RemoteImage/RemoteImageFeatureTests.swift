
import XCTest
import PowerAssert
import ComposableArchitecture

@testable import MLDFeatures

@MainActor
class RemoteImageFeatureTests: XCTestCase {
    var store: TestStoreOf<RemoteImageFeature>!
    var reducer: RemoteImageFeature!
    var state: RemoteImageFeature.State!
    var sampleImage: UIImage!
    let sampleURL = "sample"
    
    override func setUpWithError() throws {
        reducer = .init()
        state = .init()
        sampleImage = .init()
        store = .init(initialState: state, reducer: { reducer }, withDependencies: {
            $0.environment.loader = self
        })
    }
    
    func testOnAppear() async {
        await store.send(.onAppear)
    }
    
    func testOnGetStringURL() async {
        await store.send(.onGetStringURL(sampleURL)) { [unowned self] in
            $0.imageStringURL = sampleURL
            $0.isLoading = true
            $0.redactedReasons = [.placeholder]
        }
        
        await store.receive(.onLoaded(.init()), timeout: .milliseconds(10)) { [unowned self] in
            $0.image = .init(uiImage: sampleImage)
            $0.isLoading = false
            $0.redactedReasons = []
        }
        
        await store.send(.onGetStringURL(sampleURL))
    }
    
    func testOnGetImage() async {
        let image = UIImage(systemName: "circle.fill")
        await store.send(.onLoaded(image)) {
            $0.image = .init(uiImage: image!)
        }
    }
    
    func testWithoutRedactedReasons() async {
        store = .init(
            initialState: state,
            reducer: { reducer },
            withDependencies: {
                $0.environment.redactionEnabled = false
            }
        )
        
        await store.send(.onGetStringURL(sampleURL)) { [unowned self] in
            $0.imageStringURL = sampleURL
            $0.isLoading = true
            $0.redactedReasons = []
        }
    }
}

extension RemoteImageFeatureTests: ImageProvider {
    func loadImage(stringURL: String, storeInCache: Bool) async -> UIImage? {
        sampleImage
    }
    
    func loadImage(url: URL, storeInCache: Bool) async -> UIImage? {
        sampleImage
    }
}
