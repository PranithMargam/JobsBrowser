import Foundation

protocol JobRepository {
    func fetchJobs() async throws -> [Job]
}

enum JobRepositoryError: LocalizedError, Equatable {
    case resourceNotFound
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .resourceNotFound:
            return AppConstants.Text.jobsDataFileMissing
        case .decodingFailed:
            return AppConstants.Text.jobsDataUnreadable
        }
    }
}

final class BundleJobRepository: JobRepository {
    private let bundle: Bundle
    private let resourceName: String

    init(bundle: Bundle, resourceName: String = "jobs") {
        self.bundle = bundle
        self.resourceName = resourceName
    }

    #if SWIFT_PACKAGE
    convenience init(resourceName: String = "jobs") {
        self.init(bundle: .module, resourceName: resourceName)
    }
    #else
    convenience init(resourceName: String = "jobs") {
        self.init(bundle: .main, resourceName: resourceName)
    }
    #endif

    func fetchJobs() async throws -> [Job] {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            throw JobRepositoryError.resourceNotFound
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Job].self, from: data)
        } catch let error as DecodingError {
            _ = error
            throw JobRepositoryError.decodingFailed
        } catch {
            throw JobRepositoryError.decodingFailed
        }
    }
}
