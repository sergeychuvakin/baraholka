import SwiftUI
import BaraholkaCore

/// Inbox showing all conversations.
struct MessagesView: View {
    private let currentUser = User.currentUser
    private var conversations: [Conversation] {
        Conversation.sampleConversations(currentUser: currentUser)
    }

    var body: some View {
        NavigationStack {
            Group {
                if conversations.isEmpty {
                    emptyState
                } else {
                    List(conversations) { conversation in
                        NavigationLink {
                            ConversationView(conversation: conversation, currentUser: currentUser)
                        } label: {
                            conversationRow(conversation)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Messages")
        }
    }

    // MARK: - Row

    private func conversationRow(_ conversation: Conversation) -> some View {
        let other = conversation.otherParticipant(currentUserId: currentUser.id)
        let unread = conversation.unreadCount(for: currentUser.id)

        return HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color(.systemGray4))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(other?.displayName.prefix(1) ?? "?")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.secondary)
                )

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(other?.displayName ?? "Unknown")
                        .font(.subheadline.weight(unread > 0 ? .bold : .regular))
                    Spacer()
                    if let lastMessage = conversation.lastMessage {
                        Text(lastMessage.sentAt, style: .relative)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                if let item = conversation.item {
                    Text(item.title)
                        .font(.caption)
                        .foregroundStyle(.orange)
                        .lineLimit(1)
                }

                if let lastMessage = conversation.lastMessage {
                    Text(lastMessage.content)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            if unread > 0 {
                Text("\(unread)")
                    .font(.caption2.weight(.bold))
                    .padding(6)
                    .background(.orange, in: Circle())
                    .foregroundStyle(.white)
            }
        }
        .padding(.vertical, 4)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "message")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)
            Text("No messages yet")
                .font(.headline)
            Text("Contact a seller to start a conversation")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

// MARK: - Conversation view

struct ConversationView: View {
    let conversation: Conversation
    let currentUser: User
    @State private var messageText = ""

    var body: some View {
        VStack(spacing: 0) {
            if let item = conversation.item {
                listingBanner(item: item)
                Divider()
            }

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(conversation.messages) { message in
                            messageBubble(message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: conversation.messages.count) { _, _ in
                    if let last = conversation.messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }

            Divider()
            inputBar
        }
        .navigationTitle(conversation.otherParticipant(currentUserId: currentUser.id)?.displayName ?? "Chat")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func listingBanner(item: Item) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                Image(systemName: item.category.iconName)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                Text(item.formattedPrice)
                    .font(.subheadline)
                    .foregroundStyle(.orange)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
    }

    private func messageBubble(_ message: Message) -> some View {
        let isMine = message.senderId == currentUser.id

        return HStack {
            if isMine { Spacer(minLength: 60) }
            Text(message.content)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(isMine ? Color.orange : Color(.systemGray5),
                            in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .foregroundStyle(isMine ? .white : .primary)
            if !isMine { Spacer(minLength: 60) }
        }
        .frame(maxWidth: .infinity, alignment: isMine ? .trailing : .leading)
    }

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Message…", text: $messageText, axis: .vertical)
                .lineLimit(1...4)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 20))

            Button {
                // Send message
                messageText = ""
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(messageText.isEmpty ? .secondary : .orange)
            }
            .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty)
        }
        .padding()
        .background(.regularMaterial)
    }
}

#Preview {
    MessagesView()
}
