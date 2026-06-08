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

                    Spacer(minLength: 12)

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.45))
                        .padding(.top, 4)
                }

                HStack(spacing: 8) {
                    Label(job.location, systemImage: "mappin.and.ellipse")
                    Spacer(minLength: 8)
                    Label(job.salaryRange, systemImage: "banknote")
                }
                .font(.footnote.weight(.medium))
                .foregroundStyle(.white.opacity(0.8))
                .lineLimit(1)
                .minimumScaleFactor(0.85)

                HStack(spacing: 8) {
                    JobPill(text: job.category.title)
                    if isSaved {
                        JobPill(text: "Saved")
                    }
                }
                .padding(.top, 2)
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.22), radius: 18, x: 0, y: 10)

            if let onToggleSave {
                Button(action: onToggleSave) {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(isSaved ? .black : .white)
                        .padding(10)
                        .background(isSaved ? Color.white : Color.white.opacity(0.12), in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isSaved ? "Remove from saved jobs" : "Save job")
                .accessibilityIdentifier("job-save-button-\(job.id)")
                .padding(14)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(job.title), \(job.companyName), \(job.location), \(job.salaryRange)")
        .accessibilityIdentifier("job-card-\(job.id)")
    }
}

private struct JobPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white.opacity(0.9))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(.white.opacity(0.10), in: Capsule())
    }
}
