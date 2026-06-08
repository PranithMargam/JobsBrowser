import SwiftUI

struct JobDetailView: View {
    let job: Job
    @ObservedObject var activityStore: JobsActivityStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                JobDetailHeroCard(job: job)
                JobDetailSection(title: AppConstants.Text.jobDescription, text: job.description)
                JobDetailSection(title: AppConstants.Text.companyInformation, text: job.companyInformation)
                JobHighlightsCard(job: job)
            }
            .padding()
        }
        .background(detailBackground.ignoresSafeArea())
        .navigationTitle(job.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(AppConstants.Text.close) {
                    dismiss()
                }
                .accessibilityIdentifier(AppConstants.Accessibility.jobDetailCloseButton)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { activityStore.toggleSaved(job) }) {
                    Image(systemName: activityStore.isSaved(job) ? AppConstants.Icons.bookmarkFilled : AppConstants.Icons.bookmark)
                        .font(.system(size: AppConstants.Layout.detailSaveButtonIconSize, weight: .semibold))
                }
                .accessibilityLabel(activityStore.isSaved(job) ? AppConstants.Text.removeFromSavedJobs : AppConstants.Text.saveJob)
                .accessibilityIdentifier(AppConstants.Accessibility.jobDetailSaveButton)
            }
        }
        .onAppear {
            activityStore.recordViewed(job)
        }
        .accessibilityIdentifier(AppConstants.Accessibility.jobDetailScreen)
    }

    private var detailBackground: some View {
        LinearGradient(
            colors: [
                Color(red: 0.94, green: 0.96, blue: 0.99),
                Color(red: 0.88, green: 0.91, blue: 0.96)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

private struct JobDetailHeroCard: View {
    let job: Job

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(job.companyName)
                .font(.title2.weight(.semibold))
            Text(job.location)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Divider().opacity(0.3)

            Label(job.salaryRange, systemImage: AppConstants.Icons.salary)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppConstants.Layout.detailCardPadding)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: AppConstants.Layout.detailCardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppConstants.Layout.detailCardCornerRadius, style: .continuous)
                .stroke(.secondary.opacity(0.15), lineWidth: 1)
        )
        .accessibilityIdentifier(AppConstants.Accessibility.jobDetailHero)
    }
}

private struct JobDetailSection: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            Text(text)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppConstants.Layout.detailCardPadding)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: AppConstants.Layout.detailCardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppConstants.Layout.detailCardCornerRadius, style: .continuous)
                .stroke(.secondary.opacity(0.15), lineWidth: 1)
        )
        .accessibilityIdentifier(AppConstants.Accessibility.jobDetailSection(title))
    }
}

private struct JobHighlightsCard: View {
    let job: Job

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(AppConstants.Text.highlights)
                .font(.headline)

            VStack(spacing: 12) {
                JobDetailMetricRow(title: AppConstants.Text.location, value: job.location, systemImage: AppConstants.Icons.location)
                JobDetailMetricRow(title: AppConstants.Text.salaryRange, value: job.salaryRange, systemImage: AppConstants.Icons.salary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppConstants.Layout.detailCardPadding)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: AppConstants.Layout.detailCardCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppConstants.Layout.detailCardCornerRadius, style: .continuous)
                .stroke(.secondary.opacity(0.15), lineWidth: 1)
        )
        .accessibilityIdentifier(AppConstants.Accessibility.jobHighlightsCard)
    }
}

private struct JobDetailMetricRow: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .frame(width: AppConstants.Layout.locationRowWidth)
                .foregroundStyle(.primary.opacity(0.8))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.body.weight(.medium))
            }

            Spacer(minLength: 0)
        }
        .accessibilityIdentifier(AppConstants.Accessibility.jobDetailMetric(title))
    }
}
