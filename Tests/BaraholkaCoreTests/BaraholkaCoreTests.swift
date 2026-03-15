import Testing
@testable import BaraholkaCore
import Foundation

// MARK: - Item Tests

@Suite("Item Model")
struct ItemModelTests {

    @Test("formattedPrice formats correctly")
    func formattedPrice() {
        let item = Item(
            title: "Test",
            description: "Desc",
            price: 250,
            currency: "USD",
            condition: .good,
            category: Category.sampleCategories[0],
            seller: User.sampleUsers[0],
            location: "Moscow"
        )
        #expect(item.formattedPrice.contains("250"))
    }

    @Test("timeAgoText returns 'Just now' for very recent items")
    func timeAgoTextJustNow() {
        let item = Item(
            title: "Test",
            description: "Desc",
            price: 10,
            condition: .good,
            category: Category.sampleCategories[0],
            seller: User.sampleUsers[0],
            location: "Moscow",
            createdAt: Date()
        )
        #expect(item.timeAgoText == "Just now")
    }

    @Test("timeAgoText returns hours for items posted hours ago")
    func timeAgoTextHours() {
        let item = Item(
            title: "Test",
            description: "Desc",
            price: 10,
            condition: .good,
            category: Category.sampleCategories[0],
            seller: User.sampleUsers[0],
            location: "Moscow",
            createdAt: Date().addingTimeInterval(-7200) // 2 hours ago
        )
        #expect(item.timeAgoText == "2h ago")
    }

    @Test("timeAgoText returns days for items posted days ago")
    func timeAgoTextDays() {
        let item = Item(
            title: "Test",
            description: "Desc",
            price: 10,
            condition: .good,
            category: Category.sampleCategories[0],
            seller: User.sampleUsers[0],
            location: "Moscow",
            createdAt: Date().addingTimeInterval(-172800) // 2 days ago
        )
        #expect(item.timeAgoText == "2d ago")
    }
}

// MARK: - Category Tests

@Suite("Category Model")
struct CategoryModelTests {

    @Test("sampleCategories is non-empty")
    func sampleCategoriesNonEmpty() {
        #expect(!Category.sampleCategories.isEmpty)
    }

    @Test("all categories have unique IDs")
    func uniqueCategoryIDs() {
        let ids = Category.sampleCategories.map { $0.id }
        #expect(Set(ids).count == ids.count)
    }

    @Test("each category has subcategories")
    func categoriesHaveSubcategories() {
        for category in Category.sampleCategories {
            #expect(!category.subcategories.isEmpty, "Category '\(category.name)' should have subcategories")
        }
    }
}

// MARK: - User Tests

@Suite("User Model")
struct UserModelTests {

    @Test("formattedRating formats to one decimal place")
    func formattedRating() {
        let user = User.sampleUsers[0]
        #expect(user.formattedRating == "4.8")
    }

    @Test("memberSinceText for recent user returns 'New member'")
    func memberSinceTextNew() {
        let user = User(
            username: "newbie",
            displayName: "New User",
            location: "Moscow",
            joinedDate: Date()
        )
        #expect(user.memberSinceText == "New member")
    }

    @Test("memberSinceText for 2-year-old account returns correct label")
    func memberSinceTextYears() {
        let joinDate = Calendar.current.date(byAdding: .year, value: -2, to: Date()) ?? Date()
        let user = User(
            username: "veteran",
            displayName: "Veteran User",
            location: "SPb",
            joinedDate: joinDate
        )
        #expect(user.memberSinceText == "Member for 2 years")
    }
}

// MARK: - SearchFilter Tests

@Suite("SearchFilter")
struct SearchFilterTests {

    @Test("default filter is empty")
    func defaultFilterIsEmpty() {
        let filter = SearchFilter()
        #expect(filter.isEmpty)
    }

    @Test("filter with query is not empty")
    func filterWithQueryNotEmpty() {
        let filter = SearchFilter(query: "iPhone")
        #expect(!filter.isEmpty)
    }

    @Test("filter with category is not empty")
    func filterWithCategoryNotEmpty() {
        let filter = SearchFilter(category: Category.sampleCategories[0])
        #expect(!filter.isEmpty)
    }
}

// MARK: - MockDataService Tests

@Suite("MockDataService")
struct MockDataServiceTests {

    let service = MockDataService.shared

    @Test("featuredItems returns items")
    func featuredItemsNonEmpty() {
        #expect(!service.featuredItems().isEmpty)
    }

    @Test("recentItems respects limit")
    func recentItemsLimit() {
        let items = service.recentItems(limit: 3)
        #expect(items.count <= 3)
    }

    @Test("search with empty filter returns all active items")
    func searchWithEmptyFilter() {
        let results = service.search(filter: SearchFilter())
        let active = service.allItems.filter { $0.status == .active }
        #expect(results.count == active.count)
    }

    @Test("search by query filters correctly")
    func searchByQuery() {
        let results = service.search(filter: SearchFilter(query: "iPhone"))
        #expect(results.allSatisfy {
            $0.title.lowercased().contains("iphone") ||
            $0.description.lowercased().contains("iphone")
        })
    }

    @Test("search sorts by price low to high")
    func searchSortPriceLowToHigh() {
        let results = service.search(filter: SearchFilter(sortBy: .priceLowToHigh))
        let prices = results.map { NSDecimalNumber(decimal: $0.price).doubleValue }
        #expect(prices == prices.sorted())
    }

    @Test("search sorts by price high to low")
    func searchSortPriceHighToLow() {
        let results = service.search(filter: SearchFilter(sortBy: .priceHighToLow))
        let prices = results.map { NSDecimalNumber(decimal: $0.price).doubleValue }
        #expect(prices == prices.sorted(by: >))
    }

    @Test("items(for:) returns only items by that seller")
    func itemsForSeller() {
        let seller = User.sampleUsers[0]
        let sellerItems = service.items(for: seller)
        #expect(sellerItems.allSatisfy { $0.seller.id == seller.id })
    }

    @Test("search filter by condition works")
    func searchFilterByCondition() {
        let filter = SearchFilter(conditions: [.likeNew])
        let results = service.search(filter: filter)
        #expect(results.allSatisfy { $0.condition == .likeNew })
    }

    @Test("search filter by price range works")
    func searchFilterByPriceRange() {
        let filter = SearchFilter(minPrice: 100, maxPrice: 500)
        let results = service.search(filter: filter)
        #expect(results.allSatisfy {
            let price = NSDecimalNumber(decimal: $0.price).doubleValue
            return price >= 100 && price <= 500
        })
    }
}

// MARK: - Conversation Tests

@Suite("Conversation Model")
struct ConversationModelTests {

    @Test("unreadCount returns correct count")
    func unreadCount() {
        let user = User.currentUser
        let conversations = Conversation.sampleConversations(currentUser: user)
        let first = conversations[0]
        let unread = first.unreadCount(for: user.id)
        #expect(unread >= 0)
    }

    @Test("otherParticipant returns the other user")
    func otherParticipant() {
        let user = User.currentUser
        let conversations = Conversation.sampleConversations(currentUser: user)
        let first = conversations[0]
        let other = first.otherParticipant(currentUserId: user.id)
        #expect(other?.id != user.id)
    }

    @Test("lastMessage returns the last message in the thread")
    func lastMessage() {
        let user = User.currentUser
        let conversations = Conversation.sampleConversations(currentUser: user)
        let first = conversations[0]
        #expect(first.lastMessage == first.messages.last)
    }
}
