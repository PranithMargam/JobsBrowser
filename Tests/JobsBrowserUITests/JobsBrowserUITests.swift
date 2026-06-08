import XCTest

final class JobsBrowserUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["-ui-testing"]
    }

    func testLaunchShowsJobList() {
        app.launch()

        let list = app.scrollViews["jobs-list"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))

        let firstJob = app.otherElements["job-card-ios-senior-001"]
        XCTAssertTrue(firstJob.waitForExistence(timeout: 5))
        XCTAssertTrue(app.navigationBars["Jobs"].exists)
    }

    func testSearchFiltersJobsByCompany() {
        app.launch()

        let list = app.scrollViews["jobs-list"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))

        let searchField = app.searchFields["Title or company"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("Trailblaze")

        let matchingJob = app.otherElements["job-card-mobile-product-002"]
        XCTAssertTrue(matchingJob.waitForExistence(timeout: 5))

        let nonMatchingJob = app.otherElements["job-card-ios-senior-001"]
        XCTAssertFalse(nonMatchingJob.waitForExistence(timeout: 1))
    }

    func testTapJobOpensDetailScreen() {
        app.launch()

        let list = app.scrollViews["jobs-list"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))

        let searchField = app.searchFields["Title or company"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 5))
        searchField.tap()
        searchField.typeText("Trailblaze")

        let jobCard = app.otherElements["job-card-mobile-product-002"]
        XCTAssertTrue(jobCard.waitForExistence(timeout: 5))
        jobCard.tap()

        let detailScreen = app.otherElements["job-detail-screen"]
        XCTAssertTrue(detailScreen.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Trailblaze"].exists)
        XCTAssertTrue(app.staticTexts["New York, NY"].exists)
        XCTAssertTrue(app.staticTexts["$145k - $180k"].exists)
    }

    func testSavedJobAppearsInMyJobsTab() {
        app.launch()

        let list = app.scrollViews["jobs-list"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))

        let saveButton = app.buttons["job-save-button-ios-senior-001"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 5))
        saveButton.tap()

        app.buttons["tab-my-jobs"].tap()

        let savedCard = app.otherElements["job-card-ios-senior-001"]
        XCTAssertTrue(savedCard.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Saved roles"].exists)
    }
}
