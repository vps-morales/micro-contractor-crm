import Foundation
import Combine

class JobViewModel: ObservableObject {
    @Published var jobs: [Job] = []
    @Published var isLoading = false

    private let dataService: DataService

    init(dataService: DataService = DataService.shared) {
        self.dataService = dataService
        loadJobs()
    }

    func loadJobs() {
        isLoading = true
        jobs = dataService.getAllJobs()
        isLoading = false
    }

    func addJob(_ job: Job) {
        dataService.saveJob(job)
        loadJobs()
    }

    func updateJob(_ job: Job) {
        dataService.updateJob(job)
        loadJobs()
    }

    func deleteJob(_ id: UUID) {
        dataService.deleteJob(id)
        loadJobs()
    }

    func getJobsForContractor(_ contractorId: UUID) -> [Job] {
        jobs.filter { $0.contractorId == contractorId }
    }
}
