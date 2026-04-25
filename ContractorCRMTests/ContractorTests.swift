import XCTest
@testable import ContractorCRM

final class ContractorTests: XCTestCase {
    var sut: Contractor!

    override func setUp() {
        super.setUp()
        sut = Contractor(
            name: "John Smith",
            email: "john@example.com",
            phone: "555-1234",
            address: "123 Main St",
            specialty: "Plumbing",
            hourlyRate: 75.0
        )
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testContractorInitialization() {
        XCTAssertEqual(sut.name, "John Smith")
        XCTAssertEqual(sut.email, "john@example.com")
        XCTAssertEqual(sut.specialty, "Plumbing")
        XCTAssertEqual(sut.hourlyRate, 75.0)
        XCTAssertTrue(sut.isActive)
    }

    func testContractorCodable() {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        do {
            let encoded = try encoder.encode(sut)
            let decoded = try decoder.decode(Contractor.self, from: encoded)

            XCTAssertEqual(decoded.name, sut.name)
            XCTAssertEqual(decoded.email, sut.email)
            XCTAssertEqual(decoded.specialty, sut.specialty)
        } catch {
            XCTFail("Encoding/Decoding failed: \(error)")
        }
    }

    func testContractorIdentifiable() {
        let contractor1 = sut!
        let contractor2 = Contractor(
            id: contractor1.id,
            name: "Different Name",
            email: "different@example.com",
            phone: "555-5678",
            address: "456 Oak Ave",
            specialty: "Electrical",
            hourlyRate: 85.0
        )

        XCTAssertEqual(contractor1.id, contractor2.id)
    }
}
