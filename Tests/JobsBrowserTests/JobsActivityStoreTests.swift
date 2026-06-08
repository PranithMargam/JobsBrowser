import XCTest
#if SWIFT_PACKAGE
@testable import JobsBrowserCore
#else
@testable import JobsBrowser
#endif

@MainActor
final class JobsActivityStoreTests: XCTestCase {
    private var defaults: UserDefaults!
    private var suiteName: String!

    override func setUp() {
        super.setUp()

        suiteName = "jobs.activity.tests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
        defaults.removePersistentDomain(forName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        suiteName = nil

        super.tearDown()
    }

    func testToggleSavedAddsAndRemovesJob() {
        let store = JobsActivityStore(defaults: defaults)
        let job = Self.sampleJobs[0]

        XCTAssertFalse(store.isSaved(job))

        store.toggleSaved(job)
        XCTAssertTrue(store.isSaved(job))
        XCTAssertEqual(store.savedJobs.map(\.id), [job.id])

        store.toggleSaved(job)
        XCTAssertFalse(store.isSaved(job))
        XCTAssertTrue(store.savedJobs.isEmpty)
    }

    func testRecordViewedDeduplicatesAndMovesMostRecentToFront() {
        let store = JobsActivityStore(defaults: defaults)
        let firstJob = Self.sampleJobs[0]
        let secondJob = Self.sampleJobs[1]

        store.recordViewed(firstJob)
        store.recordViewed(secondJob)
        store.recordViewed(firstJob)

        XCTAssertEqual(store.recentJobs.map(\.id), [firstJob.id, secondJob.id])
    }

    func testStorePersistsSavedAndRecentJobs() {
        let job = Self.sampleJobs[0]
        let anotherJob = Self.sampleJobs[1]

        do {
            let store = JobsActivityStore(defaults: defaults)
            store.toggleSaved(job)
            store.recordViewed(anotherJob)
        }

        let reloadedStore = JobsActivityStore(defaults: defaults)
        XCTAssertEqual(reloadedStore.savedJobs.map(\.id), [job.id])
        XCTAssertEqual(reloadedStore.recentJobs.map(\.id), [anotherJob.id])
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
            category: .recent
        )
    ]
}
