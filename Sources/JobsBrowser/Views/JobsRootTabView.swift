import SwiftUI

struct JobsRootTabView: View {
    @StateObject private var homeViewModel: JobsListViewModel
    @StateObject private var activityStore: JobsActivityStore

    init(homeViewModel: JobsListViewModel, activityStore: JobsActivityStore) {
        _homeViewModel = StateObject(wrappedValue: homeViewModel)
        _activityStore = StateObject(wrappedValue: activityStore)
    }

    var body: some View {
        TabView {
            JobsListView(viewModel: homeViewModel, activityStore: activityStore)
            .tabItem {
                Label(AppConstants.Text.homeTab, systemImage: AppConstants.Icons.home)
            }
            .accessibilityIdentifier(AppConstants.Accessibility.tabHome)

            NavigationStack {
                MyJobsView(activityStore: activityStore)
            }
            .tabItem {
                Label(AppConstants.Text.myJobsTab, systemImage: AppConstants.Icons.bookmarkFilled)
            }
            .accessibilityIdentifier(AppConstants.Accessibility.tabMyJobs)

            NavigationStack {
                MessagesView()
            }
            .tabItem {
                Label(AppConstants.Text.messagesTab, systemImage: AppConstants.Icons.messages)
            }
            .accessibilityIdentifier(AppConstants.Accessibility.tabMessages)

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label(AppConstants.Text.profileTab, systemImage: AppConstants.Icons.profile)
            }
            .accessibilityIdentifier(AppConstants.Accessibility.tabProfile)
        }
    }
}

private struct MyJobsView: View {
    @ObservedObject var activityStore: JobsActivityStore
    @State private var selectedJob: Job?

    var body: some View {
        ZStack {
            TabBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    TabScreenHero(
                        title: AppConstants.Text.myJobsTab,
                        subtitle: AppConstants.Text.myJobsHeroSubtitle
                    )

                    TabCard(
                        title: AppConstants.Text.savedRoles,
                        value: "\(activityStore.savedJobs.count)",
                        subtitle: AppConstants.Text.myJobsSavedSubtitle
                    )

                    if activityStore.savedJobs.isEmpty {
                        EmptyJobsPocket(
                            title: AppConstants.Text.noSavedJobsYet,
                            subtitle: AppConstants.Text.savedJobsHint
                        )
                    } else {
                        VStack(alignment: .leading, spacing: 14) {
                            SectionHeader(title: AppConstants.Text.savedRoles)

                            LazyVStack(spacing: 14) {
                                ForEach(activityStore.savedJobs) { job in
                                    JobCardView(
                                        job: job,
                                        isSaved: activityStore.isSaved(job),
                                        onToggleSave: { activityStore.toggleSaved(job) }
                                    )
                                    .onTapGesture {
                                        selectedJob = job
                                    }
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        SectionHeader(title: AppConstants.Text.recentlyViewed)

                        if activityStore.recentJobs.isEmpty {
                            EmptyJobsPocket(
                                title: AppConstants.Text.noRecentActivity,
                                subtitle: AppConstants.Text.recentActivityHint
                            )
                        } else {
                            LazyVStack(spacing: 14) {
                                ForEach(activityStore.recentJobs) { job in
                                    JobCardView(
                                        job: job,
                                        isSaved: activityStore.isSaved(job),
                                        onToggleSave: { activityStore.toggleSaved(job) }
                                    )
                                    .onTapGesture {
                                        selectedJob = job
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(AppConstants.Text.myJobsNavigationTitle)
        .navigationBarTitleDisplayMode(.large)
        .sheet(item: $selectedJob) { job in
            NavigationStack {
                JobDetailView(job: job, activityStore: activityStore)
            }
        }
    }
}

private struct MessagesView: View {
    var body: some View {
        ZStack {
            TabBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    TabScreenHero(
                        title: AppConstants.Text.messagesHeroTitle,
                        subtitle: AppConstants.Text.messagesHeroSubtitle
                    )

                    TabCard(
                        title: AppConstants.Text.inbox,
                        value: AppConstants.Text.noUnreadMessages,
                        subtitle: AppConstants.Text.inboxHint
                    )
                }
                .padding()
            }
        }
        .navigationTitle(AppConstants.Text.messagesNavigationTitle)
        .navigationBarTitleDisplayMode(.large)
    }
}

private struct ProfileView: View {
    var body: some View {
        ZStack {
            TabBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    TabScreenHero(
                        title: AppConstants.Text.profileHeroTitle,
                        subtitle: AppConstants.Text.profileHeroSubtitle
                    )

                    TabCard(
                        title: AppConstants.Text.yourProfile,
                        value: AppConstants.Text.profileValue,
                        subtitle: AppConstants.Text.profileSubtitle
                    )

                    TabCard(
                        title: AppConstants.Text.jobPreferences,
                        value: AppConstants.Text.remoteFriendly,
                        subtitle: AppConstants.Text.jobPreferencesSubtitle
                    )
                }
                .padding()
            }
        }
        .navigationTitle(AppConstants.Text.profileNavigationTitle)
        .navigationBarTitleDisplayMode(.large)
    }
}

private struct TabScreenHero: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(.white)

            Text(subtitle)
                .font(.body)
                .foregroundStyle(.white.opacity(0.78))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(22)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.24, green: 0.43, blue: 0.95).opacity(0.92),
                    Color(red: 0.16, green: 0.22, blue: 0.46).opacity(0.92)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 28, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.18), radius: 24, x: 0, y: 14)
    }
}

private struct TabCard: View {
    let title: String
    let value: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)

            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.74))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        )
    }
}

private struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 4)
    }
}

private struct EmptyJobsPocket: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.74))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        )
    }
}

private struct TabBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.05, green: 0.08, blue: 0.14),
                Color(red: 0.08, green: 0.12, blue: 0.19),
                Color(red: 0.15, green: 0.20, blue: 0.30)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
