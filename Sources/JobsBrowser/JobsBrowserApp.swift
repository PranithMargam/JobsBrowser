import SwiftUI

@main
struct JobsBrowserApp: App {
    private let repository = BundleJobRepository()
    private let activityStore = JobsActivityStore()

    var body: some Scene {
        WindowGroup {
            JobsRootTabView(
                homeViewModel: JobsListViewModel(repository: repository),
                activityStore: activityStore
            )
        }
    }
}
