import XCTest
#if SWIFT_PACKAGE
@testable import JobsBrowserCore
#else
@testable import JobsBrowser
#endif

final class JobsBrowserUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
    }

    func testLaunchShowsJobList() {
        app.launch()

        let homeTab = app.tabBars.buttons[AppConstants.Text.homeTab]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        homeTab.tap()

        let heroCard = element(identifier: "jobs-hero-card")
        XCTAssertTrue(heroCard.waitForExistence(timeout: 5))

        let firstJob = element(identifier: AppConstants.Accessibility.jobsListCard(id: "ios-senior-001"))
        XCTAssertTrue(firstJob.waitForExistence(timeout: 5))
        XCTAssertTrue(app.navigationBars[AppConstants.Text.jobsNavigationTitle].exists)
    }

    func testSearchFiltersJobsByCompany() {
        app.launch()

        let homeTab = app.tabBars.buttons[AppConstants.Text.homeTab]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        homeTab.tap()

        let heroCard = element(identifier: "jobs-hero-card")
        XCTAssertTrue(heroCard.waitForExistence(timeout: 5))

        let searchField = app.searchFields[AppConstants.Text.searchPrompt]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("Trailblaze")

        let matchingJob = element(identifier: AppConstants.Accessibility.jobsListCard(id: "mobile-product-002"))
        XCTAssertTrue(matchingJob.waitForExistence(timeout: 5))

        let nonMatchingJob = element(identifier: AppConstants.Accessibility.jobsListCard(id: "ios-senior-001"))
        XCTAssertFalse(nonMatchingJob.waitForExistence(timeout: 1))
    }

    func testTapJobOpensDetailScreen() {
        app.launch()

        let homeTab = app.tabBars.buttons[AppConstants.Text.homeTab]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        homeTab.tap()

        let heroCard = element(identifier: "jobs-hero-card")
        XCTAssertTrue(heroCard.waitForExistence(timeout: 5))

        let searchField = app.searchFields[AppConstants.Text.searchPrompt]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("Trailblaze")

        let jobCard = element(identifier: AppConstants.Accessibility.jobsListCard(id: "mobile-product-002"))
        XCTAssertTrue(jobCard.waitForExistence(timeout: 5))
        jobCard.tap()

        let detailScreen = element(identifier: "job-detail-screen")
        XCTAssertTrue(detailScreen.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Trailblaze"].exists)
        XCTAssertTrue(app.staticTexts["New York, NY"].exists)
        XCTAssertTrue(app.staticTexts["$145k - $180k"].exists)
    }

    func testTappingJobKeepsVisibleListOrderStable() {
        app.launch()

        let homeTab = app.tabBars.buttons[AppConstants.Text.homeTab]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        homeTab.tap()

        let heroCard = element(identifier: "jobs-hero-card")
        XCTAssertTrue(heroCard.waitForExistence(timeout: 5))

        let firstCard = element(identifier: AppConstants.Accessibility.jobsListCard(id: "ios-senior-001"))
        XCTAssertTrue(firstCard.waitForExistence(timeout: 5))

        app.swipeUp()

        let secondCard = element(identifier: AppConstants.Accessibility.jobsListCard(id: "mobile-product-002"))
        XCTAssertTrue(secondCard.waitForExistence(timeout: 5))

        let initialOrder = visibleOrder(
            firstCard: firstCard,
            secondCard: secondCard
        )
        XCTAssertEqual(initialOrder, [
            AppConstants.Accessibility.jobsListCard(id: "ios-senior-001"),
            AppConstants.Accessibility.jobsListCard(id: "mobile-product-002")
        ])

        firstCard.tap()

        let detailScreen = element(identifier: "job-detail-screen")
        XCTAssertTrue(detailScreen.waitForExistence(timeout: 5))

        let closeButton = element(identifier: "job-detail-close-button")
        XCTAssertTrue(closeButton.waitForExistence(timeout: 5))
        closeButton.tap()

        XCTAssertTrue(heroCard.waitForExistence(timeout: 5))
        XCTAssertFalse(detailScreen.waitForExistence(timeout: 1))

        let finalOrder = visibleOrder(
            firstCard: firstCard,
            secondCard: secondCard
        )
        XCTAssertEqual(finalOrder, initialOrder)
    }

    func testSavedJobAppearsInMyJobsTab() {
        app.launch()

        let homeTab = app.tabBars.buttons[AppConstants.Text.homeTab]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        homeTab.tap()

        let heroCard = element(identifier: "jobs-hero-card")
        XCTAssertTrue(heroCard.waitForExistence(timeout: 5))

        let saveButton = element(identifier: AppConstants.Accessibility.jobSaveButton(id: "ios-senior-001"))
        XCTAssertTrue(saveButton.waitForExistence(timeout: 5))
        saveButton.tap()

        let myJobsTab = app.tabBars.buttons[AppConstants.Text.myJobsTab]
        XCTAssertTrue(myJobsTab.waitForExistence(timeout: 5))
        myJobsTab.tap()

        app.swipeUp()

        let savedCard = element(identifier: AppConstants.Accessibility.jobCard(id: "ios-senior-001"))
        XCTAssertTrue(savedCard.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts[AppConstants.Text.savedRoles].exists)
    }

    private func visibleOrder(firstCard: XCUIElement, secondCard: XCUIElement) -> [String] {
        let orderedCards = [
            (id: "jobs-list-card-ios-senior-001", element: firstCard),
            (id: "jobs-list-card-mobile-product-002", element: secondCard)
        ]
        .filter { $0.element.exists }
        .sorted { $0.element.frame.minY < $1.element.frame.minY }

        return orderedCards.map(\.id)
    }

    private func element(identifier: String) -> XCUIElement {
        app.descendants(matching: .any).matching(identifier: identifier).firstMatch
    }
}
