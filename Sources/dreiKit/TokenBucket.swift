import Foundation

public actor TokenBucket {
    private enum State {
        case full
        case empty(waiters: [CheckedContinuation<Void, Never>])
    }

    private var state: State

    public init() {
        self.state = .full
    }

    private func enter() async {
        switch self.state {
        case .full:
            self.state = .empty(waiters: [])
            return
        case .empty(waiters: var waiters):
            await withCheckedContinuation {
                waiters.append($0)
                self.state = .empty(waiters: waiters)
            }
        }
    }

    private func exit() {
        guard case .empty(waiters: var waiters) = self.state else {
            fatalError("Exiting in invalid state")
        }

        if waiters.isEmpty {
            self.state = .full
            return
        }

        let nextWaiter = waiters.removeFirst()
        self.state = .empty(waiters: waiters)
        nextWaiter.resume()
    }

    public func withToken<ReturnValue>(_ body: @Sendable () async throws -> ReturnValue) async rethrows -> ReturnValue {
        await self.enter()
        defer {
            self.exit()
        }
        return try await body()
    }
}
