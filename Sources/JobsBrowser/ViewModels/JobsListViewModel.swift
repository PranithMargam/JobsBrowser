import Foundation

@MainActor
final class JobsListViewModel: ObservableObject {
    struct Section: Identifiable, Equatable {
        let category: Job.Category
        let jobs: [Job]

        var id: Job.Category { category }
        var title: String { category.title }
    }

    enum State: Equatable {
        case idle
        case loading
        case content([Section])
        case empty(message: String)
        case error(message: String)
    }

    @Published private(set) var state: State = .idle
    @Published var searchQuery: String = "" {
        didSet { applySearch() }
    }

    private let repository: JobRepository
    private var allJobs: [Job] = []

    init(repository: JobRepository) {
        self.repository = repository
    }

    init(repository: JobRepository, preloadedJobs: [Job]) {
        self.repository = repository
        self.allJobs = preloadedJobs
        self.state = .content(Self.groupJobs(preloadedJobs))
    }

    func loadJobs() async {
        state = .loading

        do {
            allJobs = try await repository.fetchJobs()
            applySearch()
        } catch let repositoryError as JobRepositoryError {
            state = .error(message: repositoryError.localizedDescription)
        } catch {
            state = .error(message: error.localizedDescription)
        }
    }

    private func applySearch() {
        let normalizedQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let filteredJobs = normalizedQuery.isEmpty
            ? allJobs
            : allJobs.filter { $0.searchableContent.contains(normalizedQuery) }

        if filteredJobs.isEmpty {
            if allJobs.isEmpty {
                state = .empty(message: AppConstants.Text.noJobsAvailable)
            } else if normalizedQuery.isEmpty {
                state = .empty(message: AppConstants.Text.noJobsAvailable)
            } else {
                state = .empty(message: AppConstants.Text.noJobsMatch(searchQuery))
            }
        } else {
            state = .content(Self.groupJobs(filteredJobs))
        }
    }

    static func groupJobs(_ jobs: [Job]) -> [Section] {
        Job.Category.allCases.compactMap { category in
            let categoryJobs = jobs.filter { $0.category == category }
            return categoryJobs.isEmpty ? nil : Section(category: category, jobs: categoryJobs)
        }
    }
}
