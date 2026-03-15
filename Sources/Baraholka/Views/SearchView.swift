import SwiftUI
import BaraholkaCore

/// Browse and search the marketplace with filters.
struct SearchView: View {
    @State private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CategoryFilterView(
                    categories: Category.sampleCategories,
                    selectedCategory: Binding(
                        get: { viewModel.selectedCategory },
                        set: { viewModel.selectCategory($0) }
                    )
                )
                .padding(.vertical, 10)

                Divider()

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.results.isEmpty {
                    emptyState
                } else {
                    resultsList
                }
            }
            .navigationTitle("Browse")
            .navigationBarTitleDisplayMode(.large)
            .searchable(
                text: Binding(
                    get: { viewModel.filter.query },
                    set: {
                        viewModel.filter.query = $0
                        viewModel.search()
                    }
                ),
                prompt: "Search listings…"
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Button {
                                viewModel.filter.sortBy = option
                                viewModel.search()
                            } label: {
                                if viewModel.filter.sortBy == option {
                                    Label(option.rawValue, systemImage: "checkmark")
                                } else {
                                    Text(option.rawValue)
                                }
                            }
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
        }
        .task { viewModel.search() }
    }

    // MARK: - Results

    private var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.results) { item in
                    NavigationLink(value: item) {
                        ItemCardView(item: item, style: .list)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.plain)

                    Divider().padding(.horizontal)
                }
            }
        }
        .navigationDestination(for: Item.self) { item in
            ItemDetailView(item: item)
        }
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)
            Text(viewModel.filter.query.isEmpty ? "No listings yet" : "No results for \"\(viewModel.filter.query)\"")
                .font(.headline)
            Text("Try adjusting your search or filters")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if !viewModel.filter.isEmpty {
                Button("Clear Filters", action: viewModel.resetFilters)
                    .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    SearchView()
}
