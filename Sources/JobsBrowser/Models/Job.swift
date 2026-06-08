import Foundation

struct Job: Identifiable, Codable, Hashable {
    enum Category: String, Codable, CaseIterable, Hashable {
        case profile
        case recent
        case explore

        var title: String {
            switch self {
            case .profile:
                return AppConstants.Text.jobsBasedOnYourProfile
            case .recent:
                return AppConstants.Text.jobsBasedOnYourRecentActivity
            case .explore:
                return AppConstants.Text.exploreMoreJobs
            }
        }
    }

    let id: String
    let title: String
    let companyName: String
    let location: String
    let salaryRange: String
    let description: String
    let companyInformation: String
    let category: Category

    var searchableContent: String {
        [title, companyName].joined(separator: " ").lowercased()
    }
}
