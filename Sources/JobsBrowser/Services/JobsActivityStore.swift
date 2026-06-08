import Foundation

@MainActor
final class JobsActivityStore: ObservableObject {
    @Published private(set) var savedJobs: [Job] = []
    @Published private(set) var recentJobs: [Job] = []

    private let defaults: UserDefaults
    private let savedJobsKey: String
    private let recentJobsKey: String
    private let recentLimit = 8

    init(
        defaults: UserDefaults = .standard,
        savedJobsKey: String = "jobs.activity.saved",
        recentJobsKey: String = "jobs.activity.recent"
    ) {
        self.defaults = defaults
        self.savedJobsKey = savedJobsKey
        self.recentJobsKey = recentJobsKey
        loadState()
    }

    func isSaved(_ job: Job) -> Bool {
        savedJobs.contains { $0.id == job.id }
    }

    func toggleSaved(_ job: Job) {
        if let index = savedJobs.firstIndex(where: { $0.id == job.id }) {
            savedJobs.remove(at: index)
        } else {
            savedJobs.insert(job, at: 0)
        }

        persist()
    }

    func recordViewed(_ job: Job) {
        recentJobs.removeAll { $0.id == job.id }
        recentJobs.insert(job, at: 0)
        recentJobs = Array(recentJobs.prefix(recentLimit))
        persist()
    }

    private func loadState() {
        savedJobs = decodeJobs(forKey: savedJobsKey)
        recentJobs = decodeJobs(forKey: recentJobsKey)
    }

    private func persist() {
        defaults.set(encodeJobs(savedJobs), forKey: savedJobsKey)
        defaults.set(encodeJobs(recentJobs), forKey: recentJobsKey)
    }

    private func decodeJobs(forKey key: String) -> [Job] {
        guard let data = defaults.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([Job].self, from: data)) ?? []
    }

    private func encodeJobs(_ jobs: [Job]) -> Data? {
        try? JSONEncoder().encode(jobs)
    }
}
