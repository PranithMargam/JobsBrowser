# JobsBrowser

JobsBrowser is a production-oriented iOS job browsing app built for an interview-style assessment. The app focuses on a scalable, maintainable, and testable implementation for browsing jobs, searching by title or company, viewing job details, and managing saved jobs.

## Setup Instructions

### Prerequisites

- macOS with the latest stable Xcode that supports Swift 5+
- iOS Simulator or a physical iPhone for testing
- Git installed for source control

### Run the App

1. Open `JobsBrowser.xcodeproj` in Xcode.
2. Select the desired simulator or device target.
3. Build and run the app using `Cmd + R`.

### Run Tests

1. Open the Test navigator in Xcode.
2. Run the unit test target to verify view model and service behavior.
3. Run the UI test target to validate the list, search, and detail flows.

### Data Source

This project is designed to work with either:

- A mock JSON file bundled with the app
- A local mock server such as JSON Server or Mockoon
- A public jobs API, if wired in later

If you use a mock file, make sure it is included in the app target and decoded through the networking/data layer.

## Architecture Explanation

The app follows a clean MVVM-style architecture with clear separation of responsibilities:

- `View` layer: SwiftUI screens and reusable UI components
- `ViewModel` layer: presentation logic, loading/error/empty state management, and search behavior
- `Service` or `Repository` layer: fetches and decodes job data
- `Model` layer: strongly typed job, company, and location structures
- `Dependency Injection`: dependencies are passed into view models and screens to keep the code testable and flexible

### Suggested Structure

```text
JobsBrowser
├── App
├── Models
├── Services
├── Repositories
├── ViewModels
├── Views
│   ├── Components
│   ├── Screens
│   └── Tabs
└── Tests
    ├── UnitTests
    └── UITests
```

### Atomic Design Approach

Reusable UI is organized using atomic design principles:

- `Atoms`: buttons, chips, labels, icons, price tags, and status pills
- `Molecules`: job cards, search bars, section headers, and detail rows
- `Organisms`: job lists, featured hero card, tab content containers
- `Templates`: screen layouts for home, detail, and tab-based navigation

This keeps the design consistent and makes future UI changes easier to manage.

## Assumptions Made

- The app is built with SwiftUI for faster, more maintainable UI composition.
- Job data is mocked locally or provided by a lightweight API layer, since the challenge does not require a production backend.
- Search is performed over job title and company name.
- Saved jobs are persisted locally so the `My Jobs` tab can function independently of the API.
- Personalized sections on the home screen are driven by simple client-side ranking logic, recent activity, and saved job signals.
- UI and business logic are intentionally separated so unit tests can cover the important application behavior.

## Feature Details

### Home Screen

- Displays a hero card for the most relevant or recommended job
- Groups jobs into three sections:
  - Jobs based on your Profile
  - Jobs based on your recent activity
  - Explore more jobs
- Highlights personalized content to make the home screen feel more intelligent and relevant

### Job Listing

- Shows:
  - Job title
  - Company name
  - Location
  - Salary range
- Supports sectioned browsing and reusable cards
- Handles loading, empty, and error states cleanly

### Search

- Lets users search jobs by:
  - Title
  - Company
- Updates results in a responsive way
- Shows an empty state when no matches are found

### Job Details

- Shows:
  - Job description
  - Company information
  - Salary range
  - Job location
- Designed to keep the content scannable and easy to compare

### Save Jobs

- Users can save and unsave jobs from the listing and detail screens
- Saved jobs are surfaced in the `My Jobs` tab
- This supports a practical interview task: solving a real job-portal use case with useful user value

### Tab Bar Navigation

- `Home`
- `My Jobs`
- `Messages`
- `Profile`

### State Handling

The app explicitly handles:

- Loading state
- Empty state
- Error state

This ensures the UI remains stable and understandable even when data is unavailable.

### Testing

- Unit tests cover view models and data services
- UI tests cover:
  - job list flow
  - search flow
  - job detail flow
  - saved jobs flow

The goal is to keep business logic coverage strong and make the app safer to extend.

## Notes

- The project is intentionally structured for scalability so new filters, categories, and personalization rules can be added without large rewrites.
- The UI is designed to be production-ready rather than demo-only, with reusable components and predictable state management.
