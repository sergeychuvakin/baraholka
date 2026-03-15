import SwiftUI
import BaraholkaCore

/// Horizontally scrollable category chip filter bar.
struct CategoryFilterView: View {
    let categories: [Category]
    @Binding var selectedCategory: Category?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                chip(for: nil, label: "All", icon: "square.grid.2x2")
                ForEach(categories) { category in
                    chip(for: category, label: category.name, icon: category.iconName)
                }
            }
            .padding(.horizontal)
        }
    }

    private func chip(for category: Category?, label: String, icon: String) -> some View {
        let isSelected = selectedCategory?.id == category?.id || (category == nil && selectedCategory == nil)
        return Button {
            selectedCategory = category
        } label: {
            Label(label, systemImage: icon)
                .font(.subheadline.weight(isSelected ? .semibold : .regular))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.orange : Color(.systemGray6), in: Capsule())
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: selectedCategory?.id)
    }
}

#Preview {
    @Previewable @State var selected: Category? = nil
    CategoryFilterView(categories: Category.sampleCategories, selectedCategory: $selected)
}
