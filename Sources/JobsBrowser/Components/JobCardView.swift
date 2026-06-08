import SwiftUI

struct JobCardView: View {
    let job: Job
    var isSaved: Bool = false
    var onToggleSave: (() -> Void)?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(job.title)
                            .font(.headline)
                            .foregroundStyle(.white)

                        Text(job.companyName)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.78))
                    }

                    Spacer(minLength: AppConstants.Layout.footerPadding * 3)

                }

                HStack(spacing: 8) {
                    Label(job.location, systemImage: AppConstants.Icons.location)
                    Spacer(minLength: 8)
                    Label(job.salaryRange, systemImage: AppConstants.Icons.salary)
                }
                .font(.footnote.weight(.medium))
                .foregroundStyle(.white.opacity(0.8))
                .lineLimit(1)
                .minimumScaleFactor(0.85)

                if isSaved {
                    HStack(spacing: 8) {
                        JobPill(text: AppConstants.Text.saved)
                    }
                    .padding(.top, 2)
                }
            }
            .padding(AppConstants.Layout.jobCardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: AppConstants.Layout.jobCardCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppConstants.Layout.jobCardCornerRadius, style: .continuous)
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.22), radius: 18, x: 0, y: 10)

            if let onToggleSave {
                Button(action: onToggleSave) {
                    Image(systemName: isSaved ? AppConstants.Icons.bookmarkFilled : AppConstants.Icons.bookmark)
                        .font(.system(size: AppConstants.Layout.saveButtonIconSize, weight: .semibold))
                        .foregroundStyle(isSaved ? .black : .white)
                        .padding(10)
                        .background(isSaved ? Color.white : Color.white.opacity(0.12), in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isSaved ? AppConstants.Text.removeFromSavedJobs : AppConstants.Text.saveJob)
                .accessibilityIdentifier(AppConstants.Accessibility.jobSaveButton(id: job.id))
                .padding(AppConstants.Layout.cardSpacing)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(job.title), \(job.companyName), \(job.location), \(job.salaryRange)")
        .accessibilityIdentifier(AppConstants.Accessibility.jobCard(id: job.id))
    }
}

private struct JobPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white.opacity(0.9))
            .padding(.horizontal, AppConstants.Layout.chipHorizontalPadding)
            .padding(.vertical, AppConstants.Layout.chipVerticalPadding)
            .background(.white.opacity(0.10), in: Capsule())
    }
}
