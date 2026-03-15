import Foundation

/// A category for classifying listings in the marketplace.
public struct Category: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public let name: String
    public let iconName: String
    public let subcategories: [Category]

    public init(id: UUID = UUID(), name: String, iconName: String, subcategories: [Category] = []) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.subcategories = subcategories
    }
}

public extension Category {
    static let all = Category(id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!, name: "All", iconName: "square.grid.2x2")

    static let sampleCategories: [Category] = [
        Category(name: "Electronics", iconName: "laptopcomputer", subcategories: [
            Category(name: "Phones", iconName: "iphone"),
            Category(name: "Computers", iconName: "desktopcomputer"),
            Category(name: "TVs", iconName: "tv"),
            Category(name: "Audio", iconName: "headphones")
        ]),
        Category(name: "Clothing", iconName: "tshirt", subcategories: [
            Category(name: "Men's", iconName: "person"),
            Category(name: "Women's", iconName: "person.fill"),
            Category(name: "Kids'", iconName: "figure.and.child.holdinghands"),
            Category(name: "Shoes", iconName: "shoeprints.fill")
        ]),
        Category(name: "Furniture", iconName: "sofa", subcategories: [
            Category(name: "Seating", iconName: "chair"),
            Category(name: "Tables", iconName: "table.furniture"),
            Category(name: "Storage", iconName: "cabinet"),
            Category(name: "Beds", iconName: "bed.double")
        ]),
        Category(name: "Sports", iconName: "figure.run", subcategories: [
            Category(name: "Bikes", iconName: "bicycle"),
            Category(name: "Fitness", iconName: "dumbbell"),
            Category(name: "Team Sports", iconName: "sportscourt"),
            Category(name: "Outdoor", iconName: "mountain.2")
        ]),
        Category(name: "Books", iconName: "books.vertical", subcategories: [
            Category(name: "Fiction", iconName: "book"),
            Category(name: "Non-Fiction", iconName: "book.closed"),
            Category(name: "Educational", iconName: "graduationcap"),
            Category(name: "Children's", iconName: "book.pages")
        ]),
        Category(name: "Toys", iconName: "teddybear", subcategories: [
            Category(name: "Board Games", iconName: "dice"),
            Category(name: "Action Figures", iconName: "figure.stand"),
            Category(name: "Building Sets", iconName: "building.columns"),
            Category(name: "Outdoors", iconName: "sun.max")
        ]),
        Category(name: "Vehicles", iconName: "car", subcategories: [
            Category(name: "Cars", iconName: "car.fill"),
            Category(name: "Motorcycles", iconName: "motorcycle"),
            Category(name: "Parts", iconName: "wrench.and.screwdriver"),
            Category(name: "Boats", iconName: "ferry")
        ]),
        Category(name: "Home & Garden", iconName: "house", subcategories: [
            Category(name: "Kitchen", iconName: "fork.knife"),
            Category(name: "Garden", iconName: "leaf"),
            Category(name: "Tools", iconName: "hammer"),
            Category(name: "Decor", iconName: "paintpalette")
        ])
    ]
}
