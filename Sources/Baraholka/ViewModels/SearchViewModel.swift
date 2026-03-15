import Foundation
import BaraholkaCore

/// View model for browsing and searching the marketplace.
@MainActor
@Observable
final class SearchViewModel {
    private let dataService: MockDataService

    var filter: SearchFilter = SearchFilter()
    var results: [Item] = []
    var isLoading: Bool = false
    var selectedCategory: Category? = nil

    init(dataService: MockDataService = .shared) {
        self.dataService = dataService
    }

    func search() {
        isLoading = true
        var f = filter
        f.category = selectedCategory
        results = dataService.search(filter: f)
        isLoading = false
    }

    func selectCategory(_ category: Category?) {
        selectedCategory = category
        search()
    }

    func resetFilters() {
        filter = SearchFilter()
        selectedCategory = nil
        search()
    }
}
