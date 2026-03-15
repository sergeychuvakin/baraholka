import Foundation

/// Sorting options for item listings.
public enum SortOption: String, CaseIterable, Sendable {
    case newest = "Newest"
    case oldest = "Oldest"
    case priceLowToHigh = "Price: Low to High"
    case priceHighToLow = "Price: High to Low"
    case mostPopular = "Most Popular"
}

/// A filter applied when searching or browsing items.
public struct SearchFilter: Equatable, Sendable {
    public var query: String
    public var category: Category?
    public var minPrice: Decimal?
    public var maxPrice: Decimal?
    public var conditions: Set<ItemCondition>
    public var location: String?
    public var sortBy: SortOption
    public var showFavoritesOnly: Bool

    public init(
        query: String = "",
        category: Category? = nil,
        minPrice: Decimal? = nil,
        maxPrice: Decimal? = nil,
        conditions: Set<ItemCondition> = [],
        location: String? = nil,
        sortBy: SortOption = .newest,
        showFavoritesOnly: Bool = false
    ) {
        self.query = query
        self.category = category
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.conditions = conditions
        self.location = location
        self.sortBy = sortBy
        self.showFavoritesOnly = showFavoritesOnly
    }

    public var isEmpty: Bool {
        query.isEmpty && category == nil && minPrice == nil &&
        maxPrice == nil && conditions.isEmpty && location == nil &&
        sortBy == .newest && !showFavoritesOnly
    }
}

/// In-memory data service providing mock listings, users, and conversations.
public final class MockDataService: Sendable {
    public static let shared = MockDataService()

    public let allItems: [Item]
    public let allUsers: [User]
    public let categories: [Category]

    private init() {
        allItems = Item.sampleItems
        allUsers = User.sampleUsers
        categories = Category.sampleCategories
    }

    /// Returns items matching the given filter.
    public func search(filter: SearchFilter) -> [Item] {
        var results = allItems.filter { $0.status == .active }

        if !filter.query.isEmpty {
            let q = filter.query.lowercased()
            results = results.filter {
                $0.title.lowercased().contains(q) ||
                $0.description.lowercased().contains(q) ||
                $0.category.name.lowercased().contains(q)
            }
        }

        if let category = filter.category, category.id != Category.all.id {
            results = results.filter { $0.category.name == category.name }
        }

        if let minPrice = filter.minPrice {
            results = results.filter {
                NSDecimalNumber(decimal: $0.price).compare(NSDecimalNumber(decimal: minPrice)) != .orderedAscending
            }
        }

        if let maxPrice = filter.maxPrice {
            results = results.filter {
                NSDecimalNumber(decimal: $0.price).compare(NSDecimalNumber(decimal: maxPrice)) != .orderedDescending
            }
        }

        if !filter.conditions.isEmpty {
            results = results.filter { filter.conditions.contains($0.condition) }
        }

        if filter.showFavoritesOnly {
            results = results.filter { $0.isFavorite }
        }

        switch filter.sortBy {
        case .newest:
            results.sort { $0.createdAt > $1.createdAt }
        case .oldest:
            results.sort { $0.createdAt < $1.createdAt }
        case .priceLowToHigh:
            results.sort { (NSDecimalNumber(decimal: $0.price).doubleValue) < (NSDecimalNumber(decimal: $1.price).doubleValue) }
        case .priceHighToLow:
            results.sort { (NSDecimalNumber(decimal: $0.price).doubleValue) > (NSDecimalNumber(decimal: $1.price).doubleValue) }
        case .mostPopular:
            results.sort { $0.viewCount > $1.viewCount }
        }

        return results
    }

    /// Returns the featured items for the home feed.
    public func featuredItems() -> [Item] {
        Array(allItems.sorted { $0.viewCount > $1.viewCount }.prefix(4))
    }

    /// Returns recently added active items.
    public func recentItems(limit: Int = 10) -> [Item] {
        Array(allItems.filter { $0.status == .active }
            .sorted { $0.createdAt > $1.createdAt }
            .prefix(limit))
    }

    /// Returns items listed by a given seller.
    public func items(for seller: User) -> [Item] {
        allItems.filter { $0.seller.id == seller.id }
    }
}
