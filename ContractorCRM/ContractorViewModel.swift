import Foundation

@MainActor
class ContractorViewModel: ObservableObject {
    @Published var contractors: [Contractor] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let dataService: DataService

    init(dataService: DataService = DataService.shared) {
        self.dataService = dataService
        loadContractors()
    }

    func loadContractors() {
        isLoading = true
        contractors = dataService.getAllContractors()
        isLoading = false
    }

    func addContractor(_ contractor: Contractor) {
        dataService.saveContractor(contractor)
        loadContractors()
    }

    func updateContractor(_ contractor: Contractor) {
        dataService.updateContractor(contractor)
        loadContractors()
    }

    func deleteContractor(_ id: UUID) {
        dataService.deleteContractor(id)
        loadContractors()
    }

    func getContractor(by id: UUID) -> Contractor? {
        contractors.first { $0.id == id }
    }
}
