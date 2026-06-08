import SwiftUI

enum AppConstants {
    enum Accessibility {
        static let jobsContent = "jobs-content"
        static let jobsList = "jobs-list"
        static let jobsHeroCard = "jobs-hero-card"
        static let jobsLoadingState = "jobs-loading-state"
        static let jobsEmptyState = "jobs-empty-state"
        static let jobDetailScreen = "job-detail-screen"
        static let jobDetailHero = "job-detail-hero"
        static let jobHighlightsCard = "job-highlights-card"
        static let jobDetailSaveButton = "job-detail-save-button"
        static let jobDetailCloseButton = "job-detail-close-button"
        static let tabHome = "tab-home"
        static let tabMyJobs = "tab-my-jobs"
        static let tabMessages = "tab-messages"
        static let tabProfile = "tab-profile"

        static func jobsSection(_ title: String) -> String {
            "jobs-section-\(slug(title))"
        }

        static func jobsListCard(id: String) -> String {
            "jobs-list-card-\(id)"
        }

        static func jobCard(id: String) -> String {
            "job-card-\(id)"
        }

        static func jobSaveButton(id: String) -> String {
            "job-save-button-\(id)"
        }

        static func jobDetailSection(_ title: String) -> String {
            "job-detail-section-\(slug(title))"
        }

        static func jobDetailMetric(_ title: String) -> String {
            "job-detail-metric-\(slug(title))"
        }

        private static func slug(_ value: String) -> String {
            value.lowercased().replacingOccurrences(of: " ", with: "-")
        }
    }

    enum Text {
        static let homeTab = "Home"
        static let myJobsTab = "My Jobs"
        static let messagesTab = "Messages"
        static let profileTab = "Profile"

        static let jobsNavigationTitle = "Jobs"
        static let searchPrompt = "Title or company"
        static let loadingJobs = "Loading jobs"

        static let jobsHeroTitle = "Find your next iOS role"
        static let jobsHeroSubtitle = "Curated roles tailored to your profile, recent activity, and fresh opportunities worth exploring."
        static let openRoles = "Open roles"
        static let collections = "Collections"
        static let personalized = "Personalized"
        static let featuredFromYourActivity = "Featured from your activity"
        static let featuredForYou = "Featured for you"

        static let jobsBasedOnYourProfile = "Jobs based on your Profile"
        static let jobsBasedOnYourRecentActivity = "Jobs based on your recent activity"
        static let exploreMoreJobs = "Explore more jobs"

        static let savedRoles = "Saved roles"
        static let saved = "Saved"
        static let recentlyViewed = "Recently viewed"
        static let noSavedJobsYet = "No saved jobs yet"
        static let savedJobsHint = "Tap the bookmark on any job card to save it here."
        static let noRecentActivity = "No recent activity"
        static let recentActivityHint = "Open a job to see it appear here."
        static let myJobsHeroSubtitle = "Track the roles you’ve saved and recently explored."
        static let myJobsSavedSubtitle = "Save interesting jobs to revisit later."

        static let messagesHeroTitle = "Messages"
        static let messagesHeroSubtitle = "Stay in sync with recruiters and hiring teams in one place."
        static let inbox = "Inbox"
        static let noUnreadMessages = "No unread messages"
        static let inboxHint = "New recruiter messages will appear here."

        static let profileHeroTitle = "Profile"
        static let profileHeroSubtitle = "Review your professional snapshot and keep your preferences up to date."
        static let yourProfile = "Your profile"
        static let jobPreferences = "Job preferences"
        static let profileValue = "iOS Engineer"
        static let profileSubtitle = "Swift, SwiftUI, MVVM, async/await"
        static let remoteFriendly = "Remote friendly"
        static let jobPreferencesSubtitle = "Location, role type, and salary preferences live here."

        static let jobDescription = "Job Description"
        static let companyInformation = "Company Information"
        static let highlights = "Highlights"
        static let location = "Location"
        static let salaryRange = "Salary Range"

        static let myJobsNavigationTitle = "My Jobs"
        static let messagesNavigationTitle = "Messages"
        static let profileNavigationTitle = "Profile"
        static let close = "Close"
        static let saveJob = "Save job"
        static let removeFromSavedJobs = "Remove from saved jobs"
        static let tryAgain = "Try Again"
        static let noResults = "No Results"
        static let somethingWentWrong = "Something Went Wrong"
        static let noJobsAvailable = "No jobs are available right now."
        static let jobsDataFileMissing = "We couldn't find the jobs data file."
        static let jobsDataUnreadable = "The jobs data could not be read."
        static let uiTestingSuiteName = "jobs.browser.ui-testing"

        static func noJobsMatch(_ query: String) -> String {
            "No jobs match \"\(query)\"."
        }
    }

    enum Icons {
        static let home = "house.fill"
        static let bookmarkFilled = "bookmark.fill"
        static let bookmark = "bookmark"
        static let messages = "message.fill"
        static let profile = "person.crop.circle.fill"
        static let briefcaseFilled = "briefcase.fill"
        static let briefcase = "briefcase"
        static let location = "mappin.and.ellipse"
        static let salary = "banknote"
        static let company = "building.2"
        static let warning = "exclamationmark.triangle"
    }

    enum Layout {
        static let heroCircleLarge: CGFloat = 260
        static let heroCircleSmall: CGFloat = 220
        static let heroCircleBlur: CGFloat = 70
        static let heroIconSize: CGFloat = 28
        static let heroIconPadding: CGFloat = 16
        static let heroCardPadding: CGFloat = 22
        static let heroCardCornerRadius: CGFloat = 30
        static let featuredCardCornerRadius: CGFloat = 18
        static let sectionCardCornerRadius: CGFloat = 24
        static let jobCardCornerRadius: CGFloat = 22
        static let sectionCardPadding: CGFloat = 14
        static let jobCardPadding: CGFloat = 18
        static let sectionSpacing: CGFloat = 22
        static let cardSpacing: CGFloat = 14
        static let heroStatSpacing: CGFloat = 10
        static let heroStatCornerRadius: CGFloat = 16
        static let heroStatVerticalPadding: CGFloat = 12
        static let heroStatHorizontalPadding: CGFloat = 14
        static let chipVerticalPadding: CGFloat = 10
        static let chipHorizontalPadding: CGFloat = 12
        static let chipCornerRadius: CGFloat = 14
        static let detailCardPadding: CGFloat = 20
        static let detailCardCornerRadius: CGFloat = 24
        static let detailSmallCornerRadius: CGFloat = 22
        static let closeButtonIconSize: CGFloat = 16
        static let saveButtonIconSize: CGFloat = 15
        static let detailSaveButtonIconSize: CGFloat = 16
        static let loadingIconSize: CGFloat = 38
        static let loadingTextHorizontalPadding: CGFloat = 24
        static let locationRowWidth: CGFloat = 24
        static let jobsListHorizontalPadding: CGFloat = 14
        static let jobsListTopPadding: CGFloat = 10
        static let jobsListBottomPadding: CGFloat = 28
        static let searchFieldFontWeight: Font.Weight = .medium
        static let footerPadding: CGFloat = 4
    }
}
