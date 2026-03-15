import SwiftUI
import BaraholkaCore

/// A card displaying an item's key info in lists and grids.
struct ItemCardView: View {
    let item: Item
    var style: Style = .grid

    enum Style { case grid, list }

    var body: some View {
        switch style {
        case .grid: gridCard
        case .list: listCard
        }
    }

    // MARK: - Grid style

    private var gridCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            imagePlaceholder
                .frame(height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(alignment: .topTrailing) { favoriteButton }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)
                    .foregroundStyle(.primary)

                Text(item.formattedPrice)
                    .font(.headline)
                    .foregroundStyle(.orange)

                HStack {
                    ConditionBadge(condition: item.condition)
                    Spacer()
                    Text(item.timeAgoText)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.top, 8)
        }
    }

    // MARK: - List style

    private var listCard: some View {
        HStack(alignment: .top, spacing: 12) {
            imagePlaceholder
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)

                Text(item.formattedPrice)
                    .font(.headline)
                    .foregroundStyle(.orange)

                ConditionBadge(condition: item.condition)

                HStack {
                    Image(systemName: "mappin")
                        .font(.caption2)
                    Text(item.location)
                        .font(.caption)
                    Spacer()
                    Text(item.timeAgoText)
                        .font(.caption2)
                }
                .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Helpers

    private var imagePlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.systemGray5))
            Image(systemName: item.category.iconName)
                .font(.largeTitle)
                .foregroundStyle(.secondary)
        }
    }

    private var favoriteButton: some View {
        Image(systemName: item.isFavorite ? "heart.fill" : "heart")
            .foregroundStyle(item.isFavorite ? .red : .white)
            .padding(8)
            .background(.ultraThinMaterial, in: Circle())
            .padding(8)
    }
}

// MARK: - Condition Badge

struct ConditionBadge: View {
    let condition: ItemCondition

    var body: some View {
        Text(condition.description)
            .font(.caption2.weight(.medium))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(badgeColor.opacity(0.15), in: Capsule())
            .foregroundStyle(badgeColor)
    }

    private var badgeColor: Color {
        switch condition {
        case .brandNew: return .green
        case .likeNew: return .mint
        case .good: return .blue
        case .fair: return .orange
        case .forParts: return .red
        }
    }
}

#Preview("Grid") {
    ItemCardView(item: Item.sampleItems[0], style: .grid)
        .padding()
}

#Preview("List") {
    ItemCardView(item: Item.sampleItems[0], style: .list)
        .padding()
}
