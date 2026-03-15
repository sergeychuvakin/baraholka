import Foundation
import BaraholkaCore

/// View model for viewing a single item listing.
@MainActor
@Observable
final class ItemDetailViewModel {
    private let dataService: MockDataService

    var item: Item
    var sellerItems: [Item] = []
    var isFavorite: Bool

    init(item: Item, dataService: MockDataService = .shared) {
        self.item = item
        self.isFavorite = item.isFavorite
        self.dataService = dataService
    }

    func loadSellerItems() {
        sellerItems = dataService.items(for: item.seller)
            .filter { $0.id != item.id }
    }

    func toggleFavorite() {
        isFavorite.toggle()
    }
}
