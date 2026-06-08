import SwiftUI

struct JobsListView: View {
    @StateObject var viewModel: JobsListViewModel
    @ObservedObject var activityStore: JobsActivityStore
    @State private var selectedJob: Job?

    var body: some View {
        NavigationStack {
            ZStack {
                background

                content
                    .accessibilityIdentifier("jobs-content")
                    .navigationTitle("Jobs")
                    .navigationBarTitleDisplayMode(.large)
                    .searchable(text: $viewModel.searchQuery, prompt: "Title or company")
                    .task {
                        if case .idle = viewModel.state {
                            await viewModel.loadJobs()
                        }
                    }
                    .sheet(item: $selectedJob) { job in
                        NavigationStack {
                            JobDetailView(job: job, activityStore: activityStore)
                        }
                    }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            JobsStateView(state: .loading)
        case .content(let sections):
            jobsContent(sections)
        case .empty(let message):
            JobsStateView(state: .empty(message: message))
        case .error(let message):
            JobsStateView(state: .error(message: message)) {
                Task {
                    await viewModel.loadJobs()
                }
            }
        }
    }

    private var background: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.08, blue: 0.14),
                    Color(red: 0.08, green: 0.12, blue: 0.19),
                    Color(red: 0.15, green: 0.20, blue: 0.30)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(Color(red: 0.40, green: 0.58, blue: 0.98).opacity(0.18))
                .frame(width: 260, height: 260)
                .blur(radius: 70)
                .offset(x: 140, y: -220)

            Circle()
                .fill(Color(red: 0.97, green: 0.67, blue: 0.35).opacity(0.14))
                .frame(width: 220, height: 220)
                .blur(radius: 70)
                .offset(x: -120, y: 260)
        }
        .ignoresSafeArea()
    }

    private func jobsContent(_ sections: [JobsListViewModel.Section]) -> some View {
        let personalizedSections = sections.map { section in
            JobsListViewModel.Section(
                category: section.category,
                jobs: rankedJobs(section.jobs)
            )
        }
        let featuredJob = personalizedSections
            .flatMap { $0.jobs }
            .max(by: { personalizationScore(for: $0) < personalizationScore(for: $1) })

        return ScrollView {
            LazyVStack(alignment: .leading, spacing: 22) {
                JobsHeroCard(
                    totalJobs: personalizedSections.reduce(0) { $0 + $1.jobs.count },
                    sectionCount: personalizedSections.count,
                    savedCount: activityStore.savedJobs.count,
                    recentCount: activityStore.recentJobs.count,
                    featuredJob: featuredJob
                )

                ForEach(personalizedSections) { section in
                    VStack(alignment: .leading, spacing: 14) {
                        JobsSectionHeader(title: section.title)

                        LazyVStack(spacing: 14) {
                            ForEach(section.jobs) { job in
                                JobCardView(
                                    job: job,
                                    isSaved: activityStore.isSaved(job),
                                    onToggleSave: { activityStore.toggleSaved(job) }
                                )
                                    .onTapGesture {
                                        activityStore.recordViewed(job)
                                        selectedJob = job
                                    }
                                .accessibilityIdentifier("jobs-list-card-\(job.id)")
                            }
                        }
                        .padding(14)
                        .background(.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(.white.opacity(0.08), lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 28)
            .accessibilityIdentifier("jobs-list")
        }
    }

    private func rankedJobs(_ jobs: [Job]) -> [Job] {
        jobs.sorted { personalizationScore(for: $0) > personalizationScore(for: $1) }
    }

    private func personalizationScore(for job: Job) -> Int {
        var score = 0

        if activityStore.isSaved(job) {
            score += 100
        }

        if let recentIndex = activityStore.recentJobs.firstIndex(where: { $0.id == job.id }) {
            score += max(0, 80 - (recentIndex * 12))
        }

        switch job.category {
        case .profile:
            score += 35
        case .recent:
            score += 20
        case .explore:
            score += 5
        }

        if job.title.localizedCaseInsensitiveContains("ios") {
            score += 10
        }

        if job.companyName.localizedCaseInsensitiveContains("apple") {
            score += 8
        }

        return score
    }
}

private struct JobsSectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 4)
            .accessibilityIdentifier("jobs-section-\(title.lowercased().replacingOccurrences(of: " ", with: "-"))")
    }
}

private struct JobsHeroCard: View {
    let totalJobs: Int
    let sectionCount: Int
    let savedCount: Int
    let recentCount: Int
    let featuredJob: Job?

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 14) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Find your next iOS role")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                        .lineSpacing(1.5)

                    Text("Curated roles tailored to your profile, recent activity, and fresh opportunities worth exploring.")
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.78))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)

                Image(systemName: "briefcase.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(16)
                    .background(Color.white.opacity(0.12), in: Circle())
            }

            HStack(spacing: 10) {
                HeroStatPill(value: "\(totalJobs)", label: "Open roles")
                HeroStatPill(value: "\(sectionCount)", label: "Collections")
                HeroStatPill(value: "\(savedCount + recentCount)", label: "Personalized")
            }

            if let featuredJob {
                VStack(alignment: .leading, spacing: 10) {
                    Text(recentCount > 0 ? "Featured from your activity" : "Featured for you")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.72))
                        .textCase(.uppercase)

                    Text(featuredJob.title)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)

                    HStack(spacing: 14) {
                        Label(featuredJob.companyName, systemImage: "building.2")
                        Label(featuredJob.location, systemImage: "mappin.and.ellipse")
                    }
                    .font(.footnote.weight(.medium))
                    .foregroundStyle(.white.opacity(0.82))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            }

            if savedCount > 0 || recentCount > 0 {
                HStack(spacing: 10) {
                    PersonalizationChip(title: "Saved", value: "\(savedCount)")
                    PersonalizationChip(title: "Recently viewed", value: "\(recentCount)")
                }
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.24, green: 0.43, blue: 0.95).opacity(0.95),
                    Color(red: 0.16, green: 0.22, blue: 0.46).opacity(0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 30, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(.white.opacity(0.14), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.28), radius: 30, x: 0, y: 18)
        .accessibilityIdentifier("jobs-hero-card")
    }
}

private struct PersonalizationChip: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
            Text(title)
                .font(.caption.weight(.medium))
                .foregroundStyle(.white.opacity(0.72))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.09), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

private struct HeroStatPill: View {
    let value: String
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
            Text(label)
                .font(.caption.weight(.medium))
                .foregroundStyle(.white.opacity(0.75))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.10), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
