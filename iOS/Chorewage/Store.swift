import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [Payout] = []
    @Published var isPro: Bool = false

    // Free-tier limit is intentionally well above the seed data count (3)
    // so a fresh install never hits the paywall immediately.
    static let freeLimit = 40

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("chorewage_items.json")
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: Payout) {
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: Payout) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Payout) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([Payout].self, from: data) {
            items = decoded
        } else {
            items = Self.seedData()
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    static func seedData() -> [Payout] {
        [
            Payout(person: "Sample A", chore: "Sample A", amount: 12.5, date: Date().addingTimeInterval(-259200)),
            Payout(person: "Sample B", chore: "Sample B", amount: 8.0, date: Date().addingTimeInterval(-518400)),
            Payout(person: "Sample C", chore: "Sample C", amount: 21.75, date: Date().addingTimeInterval(-777600))
        ]
    }
}
