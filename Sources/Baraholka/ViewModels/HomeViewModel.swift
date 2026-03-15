import Foundation
import BaraholkaCore

/// View model driving the home feed.
@MainActor
@Observable
final class HomeViewModel {
    private let dataService: MockDataService

    var featuredItems: [Item] = []
    var recentItems: [Item] = []
    var isLoading: Bool = false

    init(dataService: MockDataService = .shared) {
        self.dataService = dataService
    }

    func loadData() {
        isLoading = true
        // Simulated async load using sample data
        featuredItems = dataService.featuredItems()
        recentItems = dataService.recentItems()
        isLoading = false
    }
}
