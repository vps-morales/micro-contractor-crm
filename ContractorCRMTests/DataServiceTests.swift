import XCTest
@testable import ContractorCRM

final class DataServiceTests: XCTestCase {
    var sut: DataService!

    override func setUp() {
        super.setUp()
        sut = DataService.shared

        // Clear UserDefaults for each test
        UserDefaults.standard.removeObject(forKey: "contractors")
        UserDefaults.standard.removeObject(forKey: "jobs")
        UserDefaults.standard.removeObject(forKey: "invoices")
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "contractors")
        UserDefaults.standard.removeObject(forKey: "jobs")
        UserDefaults.standard.removeObject(forKey: "invoices")
        sut = nil
        super.tearDown()
    }

    // MARK: - Contractor Tests
    func testSaveAndRetrieveContractor() {
        let contractor = Contractor(
            name: "John Smith",
            email: "john@example.com",
            phone: "555-1234",
            address: "123 Main St",
            specialty: "Plumbing",
            hourlyRate: 75.0
        )

        sut.saveContractor(contractor)
        let retrievedContractors = sut.getAllContractors()

        XCTAssertEqual(retrievedContractors.count, 1)
        XCTAssertEqual(retrievedContractors.first?.name, "John Smith")
    }

    func testUpdateContractor() {
        let contractor = Contractor(
            name: "John Smith",
            email: "john@example.com",
            phone: "555-1234",
            address: "123 Main St",
            specialty: "Plumbing",
            hourlyRate: 75.0
        )

        sut.saveContractor(contractor)

        var updatedContractor = contractor
        updatedContractor.hourlyRate = 85.0
        sut.updateContractor(updatedContractor)

        let retrievedContractors = sut.getAllContractors()
        XCTAssertEqual(retrievedContractors.first?.hourlyRate, 85.0)
    }

    func testDeleteContractor() {
        let contractor = Contractor(
            name: "John Smith",
            email: "john@example.com",
            phone: "555-1234",
            address: "123 Main St",
            specialty: "Plumbing",
            hourlyRate: 75.0
        )

        sut.saveContractor(contractor)
        sut.deleteContractor(contractor.id)

        let retrievedContractors = sut.getAllContractors()
        XCTAssertEqual(retrievedContractors.count, 0)
    }

    // MARK: - Job Tests
    func testSaveAndRetrieveJob() {
        let contractorId = UUID()
        let job = Job(
            contractorId: contractorId,
            title: "Plumbing Repair",
            description: "Fix leaky faucet",
            estimatedHours: 2.0
        )

        sut.saveJob(job)
        let retrievedJobs = sut.getAllJobs()

        XCTAssertEqual(retrievedJobs.count, 1)
        XCTAssertEqual(retrievedJobs.first?.title, "Plumbing Repair")
    }

    func testUpdateJob() {
        let contractorId = UUID()
        let job = Job(
            contractorId: contractorId,
            title: "Plumbing Repair",
            description: "Fix leaky faucet",
            estimatedHours: 2.0
        )

        sut.saveJob(job)

        var updatedJob = job
        updatedJob.status = .completed
        updatedJob.actualHours = 1.5
        sut.updateJob(updatedJob)

        let retrievedJobs = sut.getAllJobs()
        XCTAssertEqual(retrievedJobs.first?.status, .completed)
        XCTAssertEqual(retrievedJobs.first?.actualHours, 1.5)
    }

    func testDeleteJob() {
        let contractorId = UUID()
        let job = Job(
            contractorId: contractorId,
            title: "Plumbing Repair",
            description: "Fix leaky faucet",
            estimatedHours: 2.0
        )

        sut.saveJob(job)
        sut.deleteJob(job.id)

        let retrievedJobs = sut.getAllJobs()
        XCTAssertEqual(retrievedJobs.count, 0)
    }

    // MARK: - Invoice Tests
    func testSaveAndRetrieveInvoice() {
        let contractorId = UUID()
        let invoice = Invoice(
            contractorId: contractorId,
            jobIds: [],
            invoiceNumber: "INV-001",
            amount: 500.0
        )

        sut.saveInvoice(invoice)
        let retrievedInvoices = sut.getAllInvoices()

        XCTAssertEqual(retrievedInvoices.count, 1)
        XCTAssertEqual(retrievedInvoices.first?.invoiceNumber, "INV-001")
    }

    func testUpdateInvoice() {
        let contractorId = UUID()
        let invoice = Invoice(
            contractorId: contractorId,
            jobIds: [],
            invoiceNumber: "INV-001",
            amount: 500.0
        )

        sut.saveInvoice(invoice)

        var updatedInvoice = invoice
        updatedInvoice.paymentStatus = .paid
        updatedInvoice.paidDate = Date()
        sut.updateInvoice(updatedInvoice)

        let retrievedInvoices = sut.getAllInvoices()
        XCTAssertEqual(retrievedInvoices.first?.paymentStatus, .paid)
        XCTAssertNotNil(retrievedInvoices.first?.paidDate)
    }

    func testDeleteInvoice() {
        let contractorId = UUID()
        let invoice = Invoice(
            contractorId: contractorId,
            jobIds: [],
            invoiceNumber: "INV-001",
            amount: 500.0
        )

        sut.saveInvoice(invoice)
        sut.deleteInvoice(invoice.id)

        let retrievedInvoices = sut.getAllInvoices()
        XCTAssertEqual(retrievedInvoices.count, 0)
    }
}
