import XCTest
#if SWIFT_PACKAGE
@testable import JobsBrowserCore
#else
@testable import JobsBrowser
#endif

@MainActor
final class JobsListViewModelTests: XCTestCase {
    func testLoadJobsTransitionsToContentState() async {
        let jobs = Self.sampleJobs
        let viewModel = JobsListViewModel(repository: MockJobRepository(result: .success(jobs)))

        await viewModel.loadJobs()

        guard case .content(let loadedSections) = viewModel.state else {
            return XCTFail("Expected content state")
        }

        XCTAssertEqual(loadedSections.map(\.title), [
            Job.Category.profile.title
        ])
        XCTAssertEqual(loadedSections.flatMap(\.jobs), jobs)
    }

    func testSearchFiltersByTitleAndCompany() async {
        let viewModel = JobsListViewModel(repository: MockJobRepository(result: .success(Self.sampleJobs)))

        await viewModel.loadJobs()
        viewModel.searchQuery = "trail"

        guard case .content(let filteredSections) = viewModel.state else {
            return XCTFail("Expected content state")
        }

        XCTAssertEqual(filteredSections.count, 1)
        XCTAssertEqual(filteredSections.first?.title, Job.Category.profile.title)
        XCTAssertEqual(filteredSections.flatMap(\.jobs).map(\.id), ["job-2"])
    }

    func testLoadJobsGroupsByCategoryOrder() async {
        let viewModel = JobsListViewModel(repository: MockJobRepository(result: .success(Self.groupedJobs)))

        await viewModel.loadJobs()

        guard case .content(let sections) = viewModel.state else {
            return XCTFail("Expected content state")
        }

        XCTAssertEqual(sections.map(\.title), [
            Job.Category.profile.title,
            Job.Category.recent.title,
            Job.Category.explore.title
        ])
    }

    func testSearchWithNoResultsShowsEmptyState() async {
        let viewModel = JobsListViewModel(repository: MockJobRepository(result: .success(Self.sampleJobs)))

        await viewModel.loadJobs()
        viewModel.searchQuery = "unknown"

        guard case .empty(let message) = viewModel.state else {
            return XCTFail("Expected empty state")
        }

        XCTAssertTrue(message.contains("unknown"))
    }

    func testLoadFailureShowsErrorState() async {
        let viewModel = JobsListViewModel(repository: MockJobRepository(result: .failure(JobRepositoryError.resourceNotFound)))

        await viewModel.loadJobs()

        guard case .error(let message) = viewModel.state else {
            return XCTFail("Expected error state")
        }

        XCTAssertFalse(message.isEmpty)
    }

    private static let sampleJobs: [Job] = [
        Job(
            id: "job-1",
            title: "Senior iOS Engineer",
            companyName: "Northstar Health",
            location: "San Francisco, CA",
            salaryRange: "$160k - $200k",
            description: "Build healthcare experiences.",
            companyInformation: "Northstar Health builds software.",
            category: .profile
        ),
        Job(
            id: "job-2",
            title: "iOS Product Engineer",
            companyName: "Trailblaze",
            location: "New York, NY",
            salaryRange: "$145k - $180k",
            description: "Join a product-focused team.",
            companyInformation: "Trailblaze helps small businesses.",
            category: .profile
        )
    ]

    private static let groupedJobs: [Job] = [
        Job(
            id: "job-1",
            title: "Senior iOS Engineer",
            companyName: "Northstar Health",
            location: "San Francisco, CA",
            salaryRange: "$160k - $200k",
            description: "Build healthcare experiences.",
            companyInformation: "Northstar Health builds software.",
            category: .profile
        ),
        Job(
            id: "job-2",
            title: "iOS Product Engineer",
            companyName: "Trailblaze",
            location: "New York, NY",
            salaryRange: "$145k - $180k",
            description: "Join a product-focused team.",
            companyInformation: "Trailblaze helps small businesses.",
            category: .recent
        ),
        Job(
            id: "job-3",
            title: "Mobile Platform Engineer",
            companyName: "Orbit Commerce",
            location: "Austin, TX",
            salaryRange: "$155k - $195k",
            description: "Own shared infrastructure.",
            companyInformation: "Orbit Commerce builds commerce tools.",
            category: .explore
        )
    ]
}

private struct MockJobRepository: JobRepository {
    let result: Result<[Job], Error>

    func fetchJobs() async throws -> [Job] {
        try result.get()
    }
}
