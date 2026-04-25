import XCTest
@testable import ContractorCRM

final class JobTests: XCTestCase {
    var sut: Job!
    let contractorId = UUID()

    override func setUp() {
        super.setUp()
        sut = Job(
            contractorId: contractorId,
            title: "Plumbing Repair",
            description: "Fix leaky faucet",
            estimatedHours: 2.0
        )
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testJobInitialization() {
        XCTAssertEqual(sut.title, "Plumbing Repair")
        XCTAssertEqual(sut.description, "Fix leaky faucet")
        XCTAssertEqual(sut.estimatedHours, 2.0)
        XCTAssertEqual(sut.status, .pending)
        XCTAssertNil(sut.actualHours)
    }

    func testJobStatusTransitions() {
        let statuses: [Job.Status] = [.pending, .inProgress, .completed, .cancelled]
        for status in statuses {
            sut.status = status
            XCTAssertEqual(sut.status, status)
        }
    }

    func testJobWithActualHours() {
        sut.actualHours = 2.5
        sut.status = .completed

        XCTAssertEqual(sut.actualHours, 2.5)
        XCTAssertEqual(sut.status, .completed)
    }

    func testJobCodable() {
        sut.status = .inProgress
        sut.actualHours = 1.5

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        do {
            let encoded = try encoder.encode(sut)
            let decoded = try decoder.decode(Job.self, from: encoded)

            XCTAssertEqual(decoded.title, sut.title)
            XCTAssertEqual(decoded.status, sut.status)
            XCTAssertEqual(decoded.actualHours, sut.actualHours)
        } catch {
            XCTFail("Encoding/Decoding failed: \(error)")
        }
    }
}
