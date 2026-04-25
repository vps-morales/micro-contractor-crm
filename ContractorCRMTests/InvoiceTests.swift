import XCTest
@testable import ContractorCRM

final class InvoiceTests: XCTestCase {
    var sut: Invoice!
    let contractorId = UUID()

    override func setUp() {
        super.setUp()
        sut = Invoice(
            contractorId: contractorId,
            jobIds: [],
            invoiceNumber: "INV-001",
            amount: 500.0
        )
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testInvoiceInitialization() {
        XCTAssertEqual(sut.invoiceNumber, "INV-001")
        XCTAssertEqual(sut.amount, 500.0)
        XCTAssertEqual(sut.paymentStatus, .draft)
        XCTAssertNil(sut.paidDate)
    }

    func testInvoicePaymentStatusTransitions() {
        let statuses: [Invoice.PaymentStatus] = [.draft, .sent, .paid, .overdue]
        for status in statuses {
            sut.paymentStatus = status
            XCTAssertEqual(sut.paymentStatus, status)
        }
    }

    func testInvoiceMarkAsPaid() {
        sut.paymentStatus = .paid
        sut.paidDate = Date()

        XCTAssertEqual(sut.paymentStatus, .paid)
        XCTAssertNotNil(sut.paidDate)
    }

    func testInvoiceDueDate() {
        let expectedDueDate = Calendar.current.date(byAdding: .day, value: 30, to: sut.issuedDate)

        XCTAssertNotNil(expectedDueDate)
        let daysDifference = Calendar.current.dateComponents([.day], from: sut.issuedDate, to: sut.dueDate).day
        XCTAssertEqual(daysDifference, 30)
    }

    func testInvoiceCodable() {
        sut.paymentStatus = .sent
        sut.notes = "Payment due within 30 days"

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        do {
            let encoded = try encoder.encode(sut)
            let decoded = try decoder.decode(Invoice.self, from: encoded)

            XCTAssertEqual(decoded.invoiceNumber, sut.invoiceNumber)
            XCTAssertEqual(decoded.amount, sut.amount)
            XCTAssertEqual(decoded.paymentStatus, sut.paymentStatus)
        } catch {
            XCTFail("Encoding/Decoding failed: \(error)")
        }
    }
}
