import Foundation

/// A message exchanged between a buyer and a seller.
public struct Message: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public let senderId: UUID
    public let receiverId: UUID
    public let itemId: UUID?
    public let content: String
    public let sentAt: Date
    public var isRead: Bool

    public init(
        id: UUID = UUID(),
        senderId: UUID,
        receiverId: UUID,
        itemId: UUID? = nil,
        content: String,
        sentAt: Date = Date(),
        isRead: Bool = false
    ) {
        self.id = id
        self.senderId = senderId
        self.receiverId = receiverId
        self.itemId = itemId
        self.content = content
        self.sentAt = sentAt
        self.isRead = isRead
    }
}

/// A conversation thread between two users about a listing.
public struct Conversation: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public let participants: [User]
    public let item: Item?
    public var messages: [Message]
    public var lastUpdated: Date

    public init(
        id: UUID = UUID(),
        participants: [User],
        item: Item? = nil,
        messages: [Message] = [],
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.participants = participants
        self.item = item
        self.messages = messages
        self.lastUpdated = lastUpdated
    }

    public var lastMessage: Message? { messages.last }

    public func unreadCount(for userId: UUID) -> Int {
        messages.filter { !$0.isRead && $0.receiverId == userId }.count
    }

    public func otherParticipant(currentUserId: UUID) -> User? {
        participants.first { $0.id != currentUserId }
    }
}

public extension Conversation {
    static func sampleConversations(currentUser: User) -> [Conversation] {
        let items = Item.sampleItems
        let users = User.sampleUsers.filter { $0.id != currentUser.id }

        return [
            Conversation(
                id: UUID(uuidString: "c0000001-0000-0000-0000-000000000001")!,
                participants: [currentUser, users[0]],
                item: items[0],
                messages: [
                    Message(senderId: users[0].id, receiverId: currentUser.id, itemId: items[0].id,
                            content: "Hi! Is the iPhone still available?",
                            sentAt: Date().addingTimeInterval(-3600), isRead: true),
                    Message(senderId: currentUser.id, receiverId: users[0].id, itemId: items[0].id,
                            content: "Yes, it's still available. Would you like to meet?",
                            sentAt: Date().addingTimeInterval(-3000), isRead: true),
                    Message(senderId: users[0].id, receiverId: currentUser.id, itemId: items[0].id,
                            content: "Great! Can we meet tomorrow afternoon?",
                            sentAt: Date().addingTimeInterval(-1800), isRead: false)
                ],
                lastUpdated: Date().addingTimeInterval(-1800)
            ),
            Conversation(
                id: UUID(uuidString: "c0000002-0000-0000-0000-000000000002")!,
                participants: [currentUser, users[1]],
                item: items[3],
                messages: [
                    Message(senderId: currentUser.id, receiverId: users[1].id, itemId: items[3].id,
                            content: "Is there any room to negotiate on the bike price?",
                            sentAt: Date().addingTimeInterval(-86400), isRead: true),
                    Message(senderId: users[1].id, receiverId: currentUser.id, itemId: items[3].id,
                            content: "I could do $400 if you can pick up today.",
                            sentAt: Date().addingTimeInterval(-82800), isRead: true)
                ],
                lastUpdated: Date().addingTimeInterval(-82800)
            )
        ]
    }
}
