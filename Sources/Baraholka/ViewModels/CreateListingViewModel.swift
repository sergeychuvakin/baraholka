import Foundation
import BaraholkaCore

/// View model for creating a new listing.
@MainActor
@Observable
final class CreateListingViewModel {
    var title: String = ""
    var description: String = ""
    var priceText: String = ""
    var condition: ItemCondition = .good
    var selectedCategory: Category? = nil
    var location: String = ""
    var isSubmitting: Bool = false
    var didSubmit: Bool = false
    var errorMessage: String? = nil

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !priceText.isEmpty &&
        Decimal(string: priceText) != nil &&
        selectedCategory != nil
    }

    func submit(seller: User) {
        guard isValid else {
            errorMessage = "Please fill in all required fields."
            return
        }
        isSubmitting = true
        errorMessage = nil
        // In a real app this would POST to the server; here we just simulate success.
        let price = Decimal(string: priceText) ?? 0
        let _ = Item(
            title: title,
            description: description,
            price: price,
            condition: condition,
            category: selectedCategory!,
            seller: seller,
            location: location
        )
        isSubmitting = false
        didSubmit = true
    }

    func reset() {
        title = ""
        description = ""
        priceText = ""
        condition = .good
        selectedCategory = nil
        location = ""
        isSubmitting = false
        didSubmit = false
        errorMessage = nil
    }
}
