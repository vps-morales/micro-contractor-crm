import Foundation

struct Contractor: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var phone: String
    var address: String
    var specialty: String
    var hourlyRate: Double
    var notes: String
    var createdAt: Date
    var isActive: Bool

    init(
        id: UUID = UUID(),
        name: String,
        email: String,
        phone: String,
        address: String,
        specialty: String,
        hourlyRate: Double,
        notes: String = "",
        createdAt: Date = Date(),
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.address = address
        self.specialty = specialty
        self.hourlyRate = hourlyRate
        self.notes = notes
        self.createdAt = createdAt
        self.isActive = isActive
    }
}
