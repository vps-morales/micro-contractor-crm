import XCTest
@testable import ContractorCRM

final class ContractorViewModelTests: XCTestCase {
    var sut: ContractorViewModel!

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "contractors")
        sut = ContractorViewModel()
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "contractors")
        sut = nil
        super.tearDown()
    }

    func testLoadContractorsInitially() {
        XCTAssertEqual(sut.contractors.count, 0)
        XCTAssertFalse(sut.isLoading)
    }

    func testAddContractor() {
        let contractor = Contractor(
            name: "John Smith",
            email: "john@example.com",
            phone: "555-1234",
            address: "123 Main St",
            specialty: "Plumbing",
            hourlyRate: 75.0
        )

        sut.addContractor(contractor)

        XCTAssertEqual(sut.contractors.count, 1)
        XCTAssertEqual(sut.contractors.first?.name, "John Smith")
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

        sut.addContractor(contractor)
        sut.deleteContractor(contractor.id)

        XCTAssertEqual(sut.contractors.count, 0)
    }

    func testGetContractorById() {
        let contractor = Contractor(
            name: "John Smith",
            email: "john@example.com",
            phone: "555-1234",
            address: "123 Main St",
            specialty: "Plumbing",
            hourlyRate: 75.0
        )

        sut.addContractor(contractor)
        let retrieved = sut.getContractor(by: contractor.id)

        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved?.name, "John Smith")
    }
}

final class JobViewModelTests: XCTestCase {
    var sut: JobViewModel!

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "jobs")
        sut = JobViewModel()
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "jobs")
        sut = nil
        super.tearDown()
    }

    func testLoadJobsInitially() {
        XCTAssertEqual(sut.jobs.count, 0)
        XCTAssertFalse(sut.isLoading)
    }

    func testAddJob() {
        let contractorId = UUID()
        let job = Job(
            contractorId: contractorId,
            title: "Plumbing Repair",
            description: "Fix leaky faucet",
            estimatedHours: 2.0
        )

        sut.addJob(job)

        XCTAssertEqual(sut.jobs.count, 1)
        XCTAssertEqual(sut.jobs.first?.title, "Plumbing Repair")
    }

    func testGetJobsForContractor() {
        let contractorId = UUID()
        let otherContractorId = UUID()

        let job1 = Job(
            contractorId: contractorId,
            title: "Job 1",
            description: "Description 1",
            estimatedHours: 2.0
        )

        let job2 = Job(
            contractorId: otherContractorId,
            title: "Job 2",
            description: "Description 2",
            estimatedHours: 3.0
        )

        sut.addJob(job1)
        sut.addJob(job2)

        let contractorJobs = sut.getJobsForContractor(contractorId)

        XCTAssertEqual(contractorJobs.count, 1)
        XCTAssertEqual(contractorJobs.first?.title, "Job 1")
    }
}

final class InvoiceViewModelTests: XCTestCase {
    var sut: InvoiceViewModel!

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "invoices")
        sut = InvoiceViewModel()
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "invoices")
        sut = nil
        super.tearDown()
    }

    func testLoadInvoicesInitially() {
        XCTAssertEqual(sut.invoices.count, 0)
        XCTAssertFalse(sut.isLoading)
    }

    func testAddInvoice() {
        let contractorId = UUID()
        let invoice = Invoice(
            contractorId: contractorId,
            jobIds: [],
            invoiceNumber: "INV-001",
            amount: 500.0
        )

        sut.addInvoice(invoice)

        XCTAssertEqual(sut.invoices.count, 1)
        XCTAssertEqual(sut.invoices.first?.invoiceNumber, "INV-001")
    }

    func testGetTotalRevenue() {
        let contractorId = UUID()

        let invoice1 = Invoice(
            contractorId: contractorId,
            jobIds: [],
            invoiceNumber: "INV-001",
            amount: 500.0,
            paymentStatus: .paid
        )

        let invoice2 = Invoice(
            contractorId: contractorId,
            jobIds: [],
            invoiceNumber: "INV-002",
            amount: 300.0,
            paymentStatus: .draft
        )

        let invoice3 = Invoice(
            contractorId: contractorId,
            jobIds: [],
            invoiceNumber: "INV-003",
            amount: 200.0,
            paymentStatus: .paid
        )

        sut.addInvoice(invoice1)
        sut.addInvoice(invoice2)
        sut.addInvoice(invoice3)

        let totalRevenue = sut.getTotalRevenue()

        XCTAssertEqual(totalRevenue, 700.0)
    }

    func testGetInvoicesForContractor() {
        let contractorId = UUID()
        let otherContractorId = UUID()

        let invoice1 = Invoice(
            contractorId: contractorId,
            jobIds: [],
            invoiceNumber: "INV-001",
            amount: 500.0
        )

        let invoice2 = Invoice(
            contractorId: otherContractorId,
            jobIds: [],
            invoiceNumber: "INV-002",
            amount: 300.0
        )

        sut.addInvoice(invoice1)
        sut.addInvoice(invoice2)

        let contractorInvoices = sut.getInvoicesForContractor(contractorId)

        XCTAssertEqual(contractorInvoices.count, 1)
        XCTAssertEqual(contractorInvoices.first?.invoiceNumber, "INV-001")
    }
}
