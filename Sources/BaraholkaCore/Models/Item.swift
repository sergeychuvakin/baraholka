import Foundation

/// The condition of a second-hand item.
public enum ItemCondition: String, CaseIterable, Codable, Sendable {
    case brandNew = "Brand New"
    case likeNew = "Like New"
    case good = "Good"
    case fair = "Fair"
    case forParts = "For Parts"

    public var description: String { rawValue }
}

/// The current status of a listing.
public enum ListingStatus: String, Codable, Sendable {
    case active = "Active"
    case sold = "Sold"
    case reserved = "Reserved"
    case archived = "Archived"
}

/// A single marketplace listing for a second-hand item.
public struct Item: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public var title: String
    public var description: String
    public var price: Decimal
    public var currency: String
    public var condition: ItemCondition
    public var category: Category
    public var imageURLs: [URL]
    public var seller: User
    public var location: String
    public var status: ListingStatus
    public var createdAt: Date
    public var updatedAt: Date
    public var viewCount: Int
    public var favoriteCount: Int
    public var isFavorite: Bool

    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        price: Decimal,
        currency: String = "USD",
        condition: ItemCondition,
        category: Category,
        imageURLs: [URL] = [],
        seller: User,
        location: String,
        status: ListingStatus = .active,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        viewCount: Int = 0,
        favoriteCount: Int = 0,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.currency = currency
        self.condition = condition
        self.category = category
        self.imageURLs = imageURLs
        self.seller = seller
        self.location = location
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.viewCount = viewCount
        self.favoriteCount = favoriteCount
        self.isFavorite = isFavorite
    }
}

public extension Item {
    /// Price formatted as a currency string.
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: price as NSDecimalNumber) ?? "\(currency) \(price)"
    }

    /// A short "time since posted" label.
    var timeAgoText: String {
        let seconds = Date().timeIntervalSince(createdAt)
        if seconds < 60 { return "Just now" }
        let minutes = Int(seconds / 60)
        if minutes < 60 { return "\(minutes)m ago" }
        let hours = minutes / 60
        if hours < 24 { return "\(hours)h ago" }
        let days = hours / 24
        if days < 7 { return "\(days)d ago" }
        let weeks = days / 7
        if weeks < 5 { return "\(weeks)w ago" }
        let months = days / 30
        return "\(months)mo ago"
    }

    static let sampleItems: [Item] = [
        Item(
            id: UUID(uuidString: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa")!,
            title: "iPhone 13 Pro – Excellent Condition",
            description: "Selling my iPhone 13 Pro 256GB in Sierra Blue. No scratches, always used with a case and screen protector. Battery health at 94%. Comes with original box and charger.",
            price: 650,
            condition: .likeNew,
            category: Category.sampleCategories[0],
            seller: User.sampleUsers[0],
            location: "Moscow, Russia",
            viewCount: 142,
            favoriteCount: 18,
            isFavorite: false
        ),
        Item(
            id: UUID(uuidString: "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb")!,
            title: "Vintage Levi's 501 Jeans – W32 L30",
            description: "Classic Levi's 501 jeans from the 90s. Size W32 L30. Minor fading gives them that authentic vintage look. No holes or tears.",
            price: 45,
            condition: .good,
            category: Category.sampleCategories[1],
            seller: User.sampleUsers[1],
            location: "Saint Petersburg, Russia",
            viewCount: 89,
            favoriteCount: 11,
            isFavorite: true
        ),
        Item(
            id: UUID(uuidString: "cccccccc-cccc-cccc-cccc-cccccccccccc")!,
            title: "IKEA KALLAX Shelf Unit – White 4x4",
            description: "IKEA KALLAX 4x4 shelf unit in white. Perfect condition, dismantled for easy transport. Must-pick-up item, located in the city centre.",
            price: 80,
            condition: .good,
            category: Category.sampleCategories[2],
            seller: User.sampleUsers[2],
            location: "Novosibirsk, Russia",
            viewCount: 56,
            favoriteCount: 7
        ),
        Item(
            id: UUID(uuidString: "dddddddd-dddd-dddd-dddd-dddddddddddd")!,
            title: "Trek FX3 City Bike – 2021",
            description: "Trek FX3 hybrid bike, size M. Bought in 2021, ridden maybe 200 km total. Comes with front and rear lights, bell, and kickstand.",
            price: 420,
            condition: .likeNew,
            category: Category.sampleCategories[3],
            seller: User.sampleUsers[0],
            location: "Moscow, Russia",
            viewCount: 210,
            favoriteCount: 34
        ),
        Item(
            id: UUID(uuidString: "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee")!,
            title: "Harry Potter Complete Series – Hardcover",
            description: "Complete Harry Potter box set, all 7 books in hardcover. Books 1-5 have minor shelf wear. Books 6-7 are pristine.",
            price: 35,
            condition: .good,
            category: Category.sampleCategories[4],
            seller: User.sampleUsers[1],
            location: "Saint Petersburg, Russia",
            viewCount: 44,
            favoriteCount: 9,
            isFavorite: false
        ),
        Item(
            id: UUID(uuidString: "ffffffff-ffff-ffff-ffff-ffffffffffff")!,
            title: "Sony WH-1000XM4 Headphones",
            description: "Sony WH-1000XM4 noise-cancelling headphones. Used for about 6 months, works perfectly. Selling because I upgraded. Comes with case and all accessories.",
            price: 180,
            condition: .likeNew,
            category: Category.sampleCategories[0],
            seller: User.sampleUsers[2],
            location: "Novosibirsk, Russia",
            viewCount: 178,
            favoriteCount: 22
        ),
        Item(
            id: UUID(uuidString: "11111111-aaaa-bbbb-cccc-111111111111")!,
            title: "LEGO Star Wars Millennium Falcon 75192",
            description: "LEGO Millennium Falcon, 7541 pieces. Fully built, kept in a glass display case. No missing pieces. Comes with all original minifigures.",
            price: 550,
            condition: .likeNew,
            category: Category.sampleCategories[5],
            seller: User.sampleUsers[0],
            location: "Moscow, Russia",
            viewCount: 320,
            favoriteCount: 61
        ),
        Item(
            id: UUID(uuidString: "22222222-aaaa-bbbb-cccc-222222222222")!,
            title: "MacBook Air M2 13\" – 8GB/256GB",
            description: "MacBook Air M2, Space Gray. Bought 10 months ago. No dents, very minor marks on the bottom. Battery cycles: 48. Running macOS Sonoma.",
            price: 900,
            condition: .likeNew,
            category: Category.sampleCategories[0],
            seller: User.sampleUsers[1],
            location: "Saint Petersburg, Russia",
            viewCount: 485,
            favoriteCount: 72
        )
    ]
}
