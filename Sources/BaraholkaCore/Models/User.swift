import Foundation

/// A user of the marketplace.
public struct User: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public var username: String
    public var displayName: String
    public var avatarURL: URL?
    public var bio: String
    public var location: String
    public var rating: Double
    public var reviewCount: Int
    public var joinedDate: Date
    public var isVerified: Bool
    public var activeListingCount: Int

    public init(
        id: UUID = UUID(),
        username: String,
        displayName: String,
        avatarURL: URL? = nil,
        bio: String = "",
        location: String,
        rating: Double = 0.0,
        reviewCount: Int = 0,
        joinedDate: Date = Date(),
        isVerified: Bool = false,
        activeListingCount: Int = 0
    ) {
        self.id = id
        self.username = username
        self.displayName = displayName
        self.avatarURL = avatarURL
        self.bio = bio
        self.location = location
        self.rating = rating
        self.reviewCount = reviewCount
        self.joinedDate = joinedDate
        self.isVerified = isVerified
        self.activeListingCount = activeListingCount
    }
}

public extension User {
    /// The seller's rating formatted as a string (e.g. "4.8").
    var formattedRating: String {
        String(format: "%.1f", rating)
    }

    /// The number of years/months since joining.
    var memberSinceText: String {
        let calendar = Calendar.current
        let now = Date()
        let years = calendar.dateComponents([.year], from: joinedDate, to: now).year ?? 0
        if years >= 1 {
            return "Member for \(years) year\(years == 1 ? "" : "s")"
        }
        let months = calendar.dateComponents([.month], from: joinedDate, to: now).month ?? 0
        if months >= 1 {
            return "Member for \(months) month\(months == 1 ? "" : "s")"
        }
        return "New member"
    }

    static let sampleUsers: [User] = [
        User(
            id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            username: "alexk",
            displayName: "Alex Kovalev",
            bio: "Selling things I no longer use. Fast shipping!",
            location: "Moscow, Russia",
            rating: 4.8,
            reviewCount: 47,
            joinedDate: Calendar.current.date(byAdding: .year, value: -2, to: Date()) ?? Date(),
            isVerified: true,
            activeListingCount: 12
        ),
        User(
            id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
            username: "mariap",
            displayName: "Maria Petrova",
            bio: "Vintage clothing enthusiast. Everything is in great condition.",
            location: "Saint Petersburg, Russia",
            rating: 4.9,
            reviewCount: 89,
            joinedDate: Calendar.current.date(byAdding: .year, value: -3, to: Date()) ?? Date(),
            isVerified: true,
            activeListingCount: 24
        ),
        User(
            id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
            username: "ivan_s",
            displayName: "Ivan Sidorov",
            bio: "Electronics geek. All items tested and working.",
            location: "Novosibirsk, Russia",
            rating: 4.6,
            reviewCount: 31,
            joinedDate: Calendar.current.date(byAdding: .month, value: -8, to: Date()) ?? Date(),
            isVerified: false,
            activeListingCount: 7
        )
    ]

    static let currentUser = sampleUsers[0]
}
