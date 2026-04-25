import Foundation

struct Invoice: Identifiable, Codable {
    enum PaymentStatus: String, Codable {
        case draft = "Draft"
        case sent = "Sent"
        case paid = "Paid"
        case overdue = "Overdue"
    }

    let id: UUID
    var contractorId: UUID
    var jobIds: [UUID]
    var invoiceNumber: String
    var amount: Double
    var paymentStatus: PaymentStatus
    var issuedDate: Date
    var dueDate: Date
    var paidDate: Date?
    var notes: String

    init(
        id: UUID = UUID(),
        contractorId: UUID,
        jobIds: [UUID],
        invoiceNumber: String,
        amount: Double,
        paymentStatus: PaymentStatus = .draft,
        issuedDate: Date = Date(),
        dueDate: Date = Date().addingTimeInterval(2592000),
        paidDate: Date? = nil,
        notes: String = ""
    ) {
        self.id = id
        self.contractorId = contractorId
        self.jobIds = jobIds
        self.invoiceNumber = invoiceNumber
        self.amount = amount
        self.paymentStatus = paymentStatus
        self.issuedDate = issuedDate
        self.dueDate = dueDate
        self.paidDate = paidDate
        self.notes = notes
    }
}
