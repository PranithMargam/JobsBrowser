import SwiftUI

struct JobsStateView: View {
    enum State {
        case loading
        case empty(message: String)
        case error(message: String)
    }

    let state: State
    var retryAction: (() -> Void)?

    var body: some View {
        switch state {
        case .loading:
            ProgressView("Loading jobs")
                .progressViewStyle(.circular)
                .tint(.white)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityIdentifier("jobs-loading-state")
        case .empty(let message):
            JobsEmptyStateView(
                systemImage: "briefcase",
                title: "No Results",
                message: message
            )
        case .error(let message):
            JobsEmptyStateView(
                systemImage: "exclamationmark.triangle",
                title: "Something Went Wrong",
                message: message,
                actionTitle: "Try Again",
                action: retryAction
            )
        }
    }
}

private struct JobsEmptyStateView: View {
    let systemImage: String
    let title: String
    let message: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 38, weight: .semibold))
                .foregroundStyle(.white.opacity(0.9))
                .padding()
                .background(.white.opacity(0.12), in: Circle())

            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)

            Text(message)
                .font(.body)
                .foregroundStyle(.white.opacity(0.75))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    .foregroundStyle(.black)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .accessibilityIdentifier("jobs-empty-state")
    }
}
