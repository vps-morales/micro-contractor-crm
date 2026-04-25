import Foundation

@MainActor
class InvoiceViewModel: ObservableObject {
    @Published var invoices: [Invoice] = []
    @Published var isLoading = false

    private let dataService: DataService

    init(dataService: DataService = DataService.shared) {
        self.dataService = dataService
        loadInvoices()
    }

    func loadInvoices() {
        isLoading = true
        invoices = dataService.getAllInvoices()
        isLoading = false
    }

    func addInvoice(_ invoice: Invoice) {
        dataService.saveInvoice(invoice)
        loadInvoices()
    }

    func updateInvoice(_ invoice: Invoice) {
        dataService.updateInvoice(invoice)
        loadInvoices()
    }

    func deleteInvoice(_ id: UUID) {
        dataService.deleteInvoice(id)
        loadInvoices()
    }

    func getInvoicesForContractor(_ contractorId: UUID) -> [Invoice] {
        invoices.filter { $0.contractorId == contractorId }
    }

    func getTotalRevenue() -> Double {
        invoices
            .filter { $0.paymentStatus == .paid }
            .reduce(0) { $0 + $1.amount }
    }
}
