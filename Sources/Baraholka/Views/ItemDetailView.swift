import SwiftUI
import BaraholkaCore

/// Detail view for a single marketplace listing.
struct ItemDetailView: View {
    let item: Item
    @State private var viewModel: ItemDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showContactSheet = false
    @State private var currentImageIndex = 0

    init(item: Item) {
        self.item = item
        self._viewModel = State(initialValue: ItemDetailViewModel(item: item))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                imageCarousel
                    .frame(height: 300)

                VStack(alignment: .leading, spacing: 16) {
                    titleAndPrice
                    Divider()
                    metaInfo
                    Divider()
                    descriptionSection
                    Divider()
                    sellerSection
                    if !viewModel.sellerItems.isEmpty {
                        Divider()
                        moreFromSeller
                    }
                }
                .padding()
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button { viewModel.toggleFavorite() } label: {
                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(viewModel.isFavorite ? .red : .primary)
                    }
                    ShareLink(item: item.title) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) { contactBar }
        .task { viewModel.loadSellerItems() }
        .sheet(isPresented: $showContactSheet) {
            ContactSellerSheet(item: item, seller: item.seller)
        }
    }

    // MARK: - Image carousel

    private var imageCarousel: some View {
        ZStack {
            Color(.systemGray5)
            Image(systemName: item.category.iconName)
                .font(.system(size: 72))
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Title & price

    private var titleAndPrice: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                Text(item.title)
                    .font(.title3.weight(.bold))
                Spacer()
                ConditionBadge(condition: item.condition)
            }

            Text(item.formattedPrice)
                .font(.title.weight(.bold))
                .foregroundStyle(.orange)
        }
    }

    // MARK: - Meta info

    private var metaInfo: some View {
        HStack(spacing: 20) {
            Label(item.location, systemImage: "mappin")
            Label(item.timeAgoText, systemImage: "clock")
            Spacer()
            Label("\(item.viewCount)", systemImage: "eye")
            Label("\(item.favoriteCount)", systemImage: "heart")
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }

    // MARK: - Description

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.headline)
            Text(item.description)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Seller

    private var sellerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Seller")
                .font(.headline)

            HStack(spacing: 12) {
                Circle()
                    .fill(Color(.systemGray4))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(item.seller.displayName.prefix(1))
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.secondary)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(item.seller.displayName)
                            .font(.subheadline.weight(.semibold))
                        if item.seller.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundStyle(.blue)
                                .font(.caption)
                        }
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill").foregroundStyle(.yellow)
                        Text(item.seller.formattedRating)
                        Text("(\(item.seller.reviewCount) reviews)")
                            .foregroundStyle(.secondary)
                    }
                    .font(.caption)
                    Text(item.seller.memberSinceText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - More from seller

    private var moreFromSeller: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("More from \(item.seller.displayName)")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.sellerItems.prefix(4)) { relatedItem in
                        NavigationLink(value: relatedItem) {
                            ItemCardView(item: relatedItem, style: .grid)
                                .frame(width: 150)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .navigationDestination(for: Item.self) { relatedItem in
            ItemDetailView(item: relatedItem)
        }
    }

    // MARK: - Contact bar

    private var contactBar: some View {
        HStack(spacing: 12) {
            Button {
                showContactSheet = true
            } label: {
                Label("Contact Seller", systemImage: "message.fill")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(.orange, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .foregroundStyle(.white)
                    .font(.headline)
            }
        }
        .padding()
        .background(.regularMaterial)
    }
}

// MARK: - Contact Seller Sheet

struct ContactSellerSheet: View {
    let item: Item
    let seller: User
    @State private var messageText = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Message to \(seller.displayName)")
                            .font(.headline)
                        Text("About: \(item.title)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(item.formattedPrice)
                        .font(.headline)
                        .foregroundStyle(.orange)
                }
                .padding()

                Divider()

                VStack(alignment: .leading) {
                    Text("Suggested messages")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(["Is this still available?", "Can you do a lower price?", "Can we meet today?"], id: \.self) { suggestion in
                                Button {
                                    messageText = suggestion
                                } label: {
                                    Text(suggestion)
                                        .font(.subheadline)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color(.systemGray6), in: Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                TextEditor(text: $messageText)
                    .frame(minHeight: 120)
                    .padding(8)
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Contact Seller")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Send") {
                        // In a real app, send the message
                        dismiss()
                    }
                    .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ItemDetailView(item: Item.sampleItems[0])
    }
}
