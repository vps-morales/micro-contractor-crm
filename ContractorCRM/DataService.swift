import Foundation

class DataService {
    static let shared = DataService()

    private let contractorsKey = "contractors"
    private let jobsKey = "jobs"
    private let invoicesKey = "invoices"

    func getAllContractors() -> [Contractor] {
        guard let data = UserDefaults.standard.data(forKey: contractorsKey) else {
            return []
        }
        let decoder = JSONDecoder()
        return (try? decoder.decode([Contractor].self, from: data)) ?? []
    }

    func saveContractor(_ contractor: Contractor) {
        var contractors = getAllContractors()
        contractors.append(contractor)
        saveContractors(contractors)
    }

    func updateContractor(_ contractor: Contractor) {
        var contractors = getAllContractors()
        if let index = contractors.firstIndex(where: { $0.id == contractor.id }) {
            contractors[index] = contractor
            saveContractors(contractors)
        }
    }

    func deleteContractor(_ id: UUID) {
        var contractors = getAllContractors()
        contractors.removeAll { $0.id == id }
        saveContractors(contractors)
    }

    private func saveContractors(_ contractors: [Contractor]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(contractors) {
            UserDefaults.standard.set(encoded, forKey: contractorsKey)
        }
    }

    func getAllJobs() -> [Job] {
        guard let data = UserDefaults.standard.data(forKey: jobsKey) else {
            return []
        }
        let decoder = JSONDecoder()
        return (try? decoder.decode([Job].self, from: data)) ?? []
    }

    func saveJob(_ job: Job) {
        var jobs = getAllJobs()
        jobs.append(job)
        saveJobs(jobs)
    }

    func updateJob(_ job: Job) {
        var jobs = getAllJobs()
        if let index = jobs.firstIndex(where: { $0.id == job.id }) {
            jobs[index] = job
            saveJobs(jobs)
        }
    }

    func deleteJob(_ id: UUID) {
        var jobs = getAllJobs()
        jobs.removeAll { $0.id == id }
        saveJobs(jobs)
    }

    private func saveJobs(_ jobs: [Job]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(jobs) {
            UserDefaults.standard.set(encoded, forKey: jobsKey)
        }
    }

    func getAllInvoices() -> [Invoice] {
        guard let data = UserDefaults.standard.data(forKey: invoicesKey) else {
            return []
        }
        let decoder = JSONDecoder()
        return (try? decoder.decode([Invoice].self, from: data)) ?? []
    }

    func saveInvoice(_ invoice: Invoice) {
        var invoices = getAllInvoices()
        invoices.append(invoice)
        saveInvoices(invoices)
    }

    func updateInvoice(_ invoice: Invoice) {
        var invoices = getAllInvoices()
        if let index = invoices.firstIndex(where: { $0.id == invoice.id }) {
            invoices[index] = invoice
            saveInvoices(invoices)
        }
    }

    func deleteInvoice(_ id: UUID) {
        var invoices = getAllInvoices()
        invoices.removeAll { $0.id == id }
        saveInvoices(invoices)
    }

    private func saveInvoices(_ invoices: [Invoice]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(invoices) {
            UserDefaults.standard.set(encoded, forKey: invoicesKey)
        }
    }
}
