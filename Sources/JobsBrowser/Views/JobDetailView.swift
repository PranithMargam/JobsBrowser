import SwiftUI

struct JobDetailView: View {
    let job: Job
    @ObservedObject var activityStore: JobsActivityStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                JobDetailHeroCard(job: job)
                JobDetailSection(title: "Job Description", text: job.description)
                JobDetailSection(title: "Company Information", text: job.companyInformation)
                JobHighlightsCard(job: job)
            }
            .padding()
        }
        .background(detailBackground.ignoresSafeArea())
        .navigationTitle(job.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { activityStore.toggleSaved(job) }) {
                    Image(systemName: activityStore.isSaved(job) ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 16, weight: .semibold))
                }
                .accessibilityLabel(activityStore.isSaved(job) ? "Remove from saved jobs" : "Save job")
                .accessibilityIdentifier("job-detail-save-button")
            }
        }
        .onAppear {
            activityStore.recordViewed(job)
        }
        .accessibilityIdentifier("job-detail-screen")
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

            Label(job.salaryRange, systemImage: "banknote")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.secondary.opacity(0.15), lineWidth: 1)
        )
        .accessibilityIdentifier("job-detail-hero")
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
        .padding(20)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.secondary.opacity(0.15), lineWidth: 1)
        )
        .accessibilityIdentifier("job-detail-section-\(title.lowercased().replacingOccurrences(of: " ", with: "-"))")
    }
}

private struct JobHighlightsCard: View {
    let job: Job

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Highlights")
                .font(.headline)

            VStack(spacing: 12) {
                JobDetailMetricRow(title: "Location", value: job.location, systemImage: "mappin.and.ellipse")
                JobDetailMetricRow(title: "Salary Range", value: job.salaryRange, systemImage: "banknote")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.secondary.opacity(0.15), lineWidth: 1)
        )
        .accessibilityIdentifier("job-highlights-card")
    }
}

private struct JobDetailMetricRow: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .frame(width: 24)
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
        .accessibilityIdentifier("job-detail-metric-\(title.lowercased().replacingOccurrences(of: " ", with: "-"))")
    }
}
