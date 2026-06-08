import XCTest
#if SWIFT_PACKAGE
@testable import JobsBrowserCore
#else
@testable import JobsBrowser
#endif

final class JobRepositoryTests: XCTestCase {
    func testFetchJobsDecodesLocalJSON() async throws {
        let repository = BundleJobRepository()

        let jobs = try await repository.fetchJobs()

        XCTAssertGreaterThan(jobs.count, 0)
        XCTAssertEqual(jobs.first?.title, "Senior iOS Engineer")
        XCTAssertEqual(jobs.first?.category, .profile)
    }
}
