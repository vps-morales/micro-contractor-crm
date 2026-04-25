import Foundation

struct Job: Identifiable, Codable {
    enum Status: String, Codable {
        case pending = "Pending"
        case inProgress = "In Progress"
        case completed = "Completed"
        case cancelled = "Cancelled"
    }

    let id: UUID
    var contractorId: UUID
    var title: String
    var description: String
    var status: Status
    var estimatedHours: Double
    var actualHours: Double?
    var startDate: Date
    var completionDate: Date?
    var createdAt: Date

    init(
        id: UUID = UUID(),
        contractorId: UUID,
        title: String,
        description: String,
        status: Status = .pending,
        estimatedHours: Double,
        actualHours: Double? = nil,
        startDate: Date = Date(),
        completionDate: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.contractorId = contractorId
        self.title = title
        self.description = description
        self.status = status
        self.estimatedHours = estimatedHours
        self.actualHours = actualHours
        self.startDate = startDate
        self.completionDate = completionDate
        self.createdAt = createdAt
    }
}
