import Foundation

struct Payout: Identifiable, Codable, Equatable {
    let id: UUID
    var person: String
    var chore: String
    var amount: Double
    var date: Date
    var createdAt: Date

    init(id: UUID = UUID(), person: String = "", chore: String = "", amount: Double = 0, date: Date = Date(), createdAt: Date = Date()) {
        self.id = id
        self.person = person
        self.chore = chore
        self.amount = amount
        self.date = date
        self.createdAt = createdAt
    }
}
