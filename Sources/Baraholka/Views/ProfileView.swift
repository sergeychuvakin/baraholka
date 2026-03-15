import SwiftUI
import BaraholkaCore

/// A user's public profile with their active listings.
struct ProfileView: View {
    let user: User
    var isCurrentUser: Bool = false

    private var userItems: [Item] {
        MockDataService.shared.items(for: user)
    }

    @State private var selectedItem: Item? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    header
                    Divider()
                    statsRow
                    Divider().padding(.top, 8)
                    listingsGrid
                }
            }
            .navigationTitle(isCurrentUser ? "My Profile" : user.displayName)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if isCurrentUser {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            // Settings
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
            }
            .navigationDestination(item: $selectedItem) { item in
                ItemDetailView(item: item)
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(Color(.systemGray4))
                .frame(width: 90, height: 90)
                .overlay(
                    Text(user.displayName.prefix(1))
                        .font(.largeTitle.weight(.semibold))
                        .foregroundStyle(.secondary)
                )

            VStack(spacing: 4) {
                HStack(spacing: 6) {
                    Text(user.displayName)
                        .font(.title2.weight(.bold))
                    if user.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundStyle(.blue)
                    }
                }
                Text("@\(user.username)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if !user.bio.isEmpty {
                    Text(user.bio)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 2)
                }
                Label(user.location, systemImage: "mappin")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if isCurrentUser {
                Button("Edit Profile") {}
                    .buttonStyle(.bordered)
                    .controlSize(.small)
            } else {
                Button("Follow") {}
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    .controlSize(.small)
            }
        }
        .padding()
    }

    // MARK: - Stats

    private var statsRow: some View {
        HStack {
            statCell(value: "\(user.activeListingCount)", label: "Listings")
            Divider().frame(height: 36)
            statCell(value: user.formattedRating, label: "Rating")
            Divider().frame(height: 36)
            statCell(value: "\(user.reviewCount)", label: "Reviews")
        }
        .padding(.vertical, 12)
    }

    private func statCell(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.title3.weight(.bold))
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Listings grid

    private var listingsGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Listings")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 12)

            if userItems.isEmpty {
                Text("No active listings")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: 16
                ) {
                    ForEach(userItems) { item in
                        Button { selectedItem = item } label: {
                            ItemCardView(item: item, style: .grid)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom)
    }
}

#Preview("Current User") {
    ProfileView(user: User.currentUser, isCurrentUser: true)
}

#Preview("Other User") {
    ProfileView(user: User.sampleUsers[1], isCurrentUser: false)
}
