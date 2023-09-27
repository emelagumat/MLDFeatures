
import XCTest
import PowerAssert
import ComposableArchitecture

@testable import RemoteImage

@MainActor
class RemoteImageFeatureTests: XCTestCase {
    var store: TestStoreOf<RemoteImageFeature>!
    var reducer: RemoteImageFeature!
    var state: RemoteImageFeature.State!
    
    override func setUpWithError() throws {
        reducer = .init()
        state = .init()
        store = .init(initialState: state, reducer: { reducer })
    }
    
    func testOnAppear() async {
        await store.send(.onAppear)
    }
    
    func testOnGetStringURL() async {
        let sampleURL = "sample"
        
        await store.send(.onGetStringURL(sampleURL)) {
            $0.imageStringURL = sampleURL
            $0.isLoading = true
            $0.redactedReasons = [.placeholder]
        }
    }
    
    func testOnGetImage() async {
        let image = UIImage(systemName: "circle.fill")
        
        await store.send(.onLoaded(image)) {
            $0.image = .init(uiImage: image!)
        }
    }
}
