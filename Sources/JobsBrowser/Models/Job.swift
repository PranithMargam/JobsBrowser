import Foundation

struct Job: Identifiable, Codable, Hashable {
    enum Category: String, Codable, CaseIterable, Hashable {
        case profile
        case recent
        case explore

        var title: String {
            switch self {
            case .profile:
                return "Jobs based on your Profile"
            case .recent:
                return "Jobs based on your recent activity"
            case .explore:
                return "Explore more jobs"
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
