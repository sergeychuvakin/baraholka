import SwiftUI
import BaraholkaCore

/// Form view for creating a new marketplace listing.
struct CreateListingView: View {
    @State private var viewModel = CreateListingViewModel()
    @State private var showCategoryPicker = false

    private let currentUser = User.currentUser

    var body: some View {
        NavigationStack {
            Form {
                photosSection
                detailsSection
                pricingSection
                locationSection
            }
            .navigationTitle("New Listing")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Post") {
                        viewModel.submit(seller: currentUser)
                    }
                    .fontWeight(.semibold)
                    .disabled(!viewModel.isValid || viewModel.isSubmitting)
                }
            }
            .alert("Listing Posted!", isPresented: $viewModel.didSubmit) {
                Button("Great!") { viewModel.reset() }
            } message: {
                Text("Your item has been listed successfully.")
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK") {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .sheet(isPresented: $showCategoryPicker) {
                CategoryPickerSheet(selectedCategory: $viewModel.selectedCategory)
            }
        }
    }

    // MARK: - Sections

    private var photosSection: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    addPhotoButton
                        .frame(width: 100, height: 100)
                }
                .padding(.vertical, 8)
            }
        } header: {
            Text("Photos")
        } footer: {
            Text("Add up to 10 photos. The first photo will be the cover.")
        }
    }

    private var addPhotoButton: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color(.systemGray6))
            .overlay {
                VStack(spacing: 4) {
                    Image(systemName: "camera.fill")
                        .font(.title2)
                    Text("Add Photo")
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
            }
    }

    private var detailsSection: some View {
        Section("Details") {
            TextField("Title", text: $viewModel.title)
                .submitLabel(.next)

            Button {
                showCategoryPicker = true
            } label: {
                HStack {
                    Text("Category")
                        .foregroundStyle(.primary)
                    Spacer()
                    if let cat = viewModel.selectedCategory {
                        Label(cat.name, systemImage: cat.iconName)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Select…")
                            .foregroundStyle(.secondary)
                    }
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
            }

            Picker("Condition", selection: $viewModel.condition) {
                ForEach(ItemCondition.allCases, id: \.self) { c in
                    Text(c.description).tag(c)
                }
            }

            VStack(alignment: .leading) {
                TextField("Description", text: $viewModel.description, axis: .vertical)
                    .lineLimit(4...8)
            }
        }
    }

    private var pricingSection: some View {
        Section("Pricing") {
            HStack {
                Text("$")
                    .foregroundStyle(.secondary)
                TextField("Price", text: $viewModel.priceText)
                    .keyboardType(.decimalPad)
            }
        }
    }

    private var locationSection: some View {
        Section("Location") {
            HStack {
                Image(systemName: "mappin")
                    .foregroundStyle(.secondary)
                TextField("City, Region", text: $viewModel.location)
            }
        }
    }
}

// MARK: - Category picker sheet

struct CategoryPickerSheet: View {
    @Binding var selectedCategory: Category?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List(Category.sampleCategories) { category in
                Button {
                    selectedCategory = category
                    dismiss()
                } label: {
                    HStack {
                        Label(category.name, systemImage: category.iconName)
                        Spacer()
                        if selectedCategory?.id == category.id {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.orange)
                        }
                    }
                }
                .foregroundStyle(.primary)
            }
            .navigationTitle("Select Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    CreateListingView()
}
