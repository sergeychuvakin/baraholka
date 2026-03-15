import SwiftUI
import BaraholkaCore

/// The main home feed showing featured and recent listings.
struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var selectedItem: Item? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                    } else {
                        featuredSection
                        recentSection
                    }
                }
                .padding(.bottom)
            }
            .navigationTitle("Baraholka")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Notifications
                    } label: {
                        Image(systemName: "bell")
                    }
                }
            }
            .navigationDestination(item: $selectedItem) { item in
                ItemDetailView(item: item)
            }
        }
        .task { viewModel.loadData() }
    }

    // MARK: - Featured

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Featured", icon: "star.fill")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.featuredItems) { item in
                        Button { selectedItem = item } label: {
                            ItemCardView(item: item, style: .grid)
                                .frame(width: 200)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Recent

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Recently Added", icon: "clock.fill")

            LazyVStack(spacing: 12) {
                ForEach(viewModel.recentItems) { item in
                    Button { selectedItem = item } label: {
                        ItemCardView(item: item, style: .list)
                            .padding(.horizontal)
                    }
                    .buttonStyle(.plain)

                    if item.id != viewModel.recentItems.last?.id {
                        Divider().padding(.horizontal)
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    private func sectionHeader(title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(.title3.weight(.semibold))
            .foregroundStyle(.primary)
            .padding(.horizontal)
    }
}

#Preview {
    HomeView()
}
