import SwiftUI

@main
struct JobsBrowserApp: App {
    private let repository: JobRepository
    private let homeViewModel: JobsListViewModel
    private let activityStore: JobsActivityStore

    init() {
        if ProcessInfo.processInfo.arguments.contains("-ui-testing") {
            let suiteName = AppConstants.Text.uiTestingSuiteName
            let defaults = UserDefaults(suiteName: suiteName) ?? .standard
            defaults.removePersistentDomain(forName: suiteName)
            let previewJobs = PreviewJobRepository.jobs
            repository = PreviewJobRepository()
            homeViewModel = JobsListViewModel(repository: repository, preloadedJobs: previewJobs)
            activityStore = JobsActivityStore(defaults: defaults)
        } else {
            repository = BundleJobRepository()
            homeViewModel = JobsListViewModel(repository: repository)
            activityStore = JobsActivityStore()
        }
    }

    var body: some Scene {
        WindowGroup {
            JobsRootTabView(
                homeViewModel: homeViewModel,
                activityStore: activityStore
            )
        }
    }
}

private struct PreviewJobRepository: JobRepository {
    func fetchJobs() async throws -> [Job] {
        PreviewJobRepository.jobs
    }

    static let jobs: [Job] = [
        Job(
            id: "ios-senior-001",
            title: "Senior iOS Engineer",
            companyName: "Northstar Health",
            location: "San Francisco, CA",
            salaryRange: "$160k - $200k",
            description: "Lead the architecture and delivery of patient-facing iOS experiences used by thousands of healthcare professionals and consumers.",
            companyInformation: "Northstar Health builds software that helps care teams coordinate, communicate, and deliver better outcomes.",
            category: .profile
        ),
        Job(
            id: "mobile-product-002",
            title: "iOS Product Engineer",
            companyName: "Trailblaze",
            location: "New York, NY",
            salaryRange: "$145k - $180k",
            description: "Join a product-focused team building consumer software with delightful onboarding and strong retention loops.",
            companyInformation: "Trailblaze helps small businesses manage customer engagement through modern mobile and web products.",
            category: .profile
        ),
        Job(
            id: "platform-003",
            title: "Mobile Platform Engineer",
            companyName: "Orbit Commerce",
            location: "Austin, TX",
            salaryRange: "$155k - $195k",
            description: "Own shared infrastructure that enables multiple mobile squads to move quickly with quality.",
            companyInformation: "Orbit Commerce is a growing marketplace platform focused on making online purchasing simpler.",
            category: .recent
        ),
        Job(
            id: "startup-004",
            title: "Lead iOS Developer",
            companyName: "Aster Labs",
            location: "Seattle, WA",
            salaryRange: "$170k - $215k",
            description: "Drive technical decisions for a fast-moving startup and shape the product experience from concept to release.",
            companyInformation: "Aster Labs is building workflow software for creative teams.",
            category: .recent
        ),
        Job(
            id: "consumer-005",
            title: "iOS Engineer",
            companyName: "Lumen Fit",
            location: "Remote",
            salaryRange: "$135k - $170k",
            description: "Build fitness experiences that motivate people to stay active.",
            companyInformation: "Lumen Fit creates consumer wellness experiences with a strong emphasis on habit formation.",
            category: .explore
        ),
        Job(
            id: "fintech-006",
            title: "Senior Mobile Engineer",
            companyName: "Harbor Finance",
            location: "Chicago, IL",
            salaryRange: "$165k - $205k",
            description: "Develop secure mobile banking features with strong attention to reliability, compliance, and user trust.",
            companyInformation: "Harbor Finance provides modern financial products for small teams and individuals.",
            category: .explore
        )
    ]
}
