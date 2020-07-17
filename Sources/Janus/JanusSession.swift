import Foundation

public class JanusSession {
    private let apiClient: APIClientProtocol
    var sessionId: Int?
    var handleId: Int?

    public init(baseUrl: URL) {
        self.apiClient = APIClient(baseUrl: baseUrl)
    }

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    public func createSession(completion: @escaping () -> Void) {
        let transactionId = "create"
        let request = CreateRequest(transaction: transactionId)
        apiClient.request(.create(request)) { (result: Result<CreateResponse, Error>) in
            if case let .success(response) = result {
                self.sessionId = response.data.id
                completion()
            }
        }
    }

    public func attachPlugin(plugin: Plugin, completion: @escaping () -> Void) {
        guard let sessionId = sessionId else { return }
        let transaction = "attach"
        let request = AttachPluginRequest(transaction: transaction, plugin: plugin)
        apiClient.request(.attachPlugin(sessionId, request)) { (result: Result<AttachPluginResponse, Error>) in
            if case let .success(response) = result {
                self.handleId = response.data.id
                completion()
            }
        }
    }

    public func trickle(candidate: String, sdpMLineIndex: Int, sdpMid: String, completion: @escaping () -> Void) {
        guard let sessionId = sessionId else { return }
        guard let handleId = handleId else { return }
        let transaction = "trickle"
        let candidate = TrickleRequest.Candidate(candidate: candidate, sdpMLineIndex: sdpMLineIndex, sdpMid: sdpMid)
        let request = TrickleRequest(transaction: transaction, candidate: candidate)
        apiClient.request(.trickle(sessionId, handleId, request)) { (_: Result<TrickleResponse, Error>) in
            completion()
        }
    }

    public func watch(streamId: String, pin: String? = nil, completion: @escaping (String) -> Void) {
        guard let sessionId = sessionId else { return }
        guard let handleId = handleId else { return }
        let transaction = "watch"
        let request = WatchRequest(transaction: transaction, streamId: streamId, pin: pin)
        apiClient.request(.watch(sessionId, handleId, request)) { [weak self] result in
            self?.handleWatchResult(result: result, completion: completion)
        }
    }

    public func watch(streamId: Int, pin: String? = nil, completion: @escaping (String) -> Void) {
        guard let sessionId = sessionId else { return }
        guard let handleId = handleId else { return }
        let transaction = "watch"
        let request = WatchRequest(transaction: transaction, streamId: streamId, pin: pin)
        apiClient.request(.watch(sessionId, handleId, request)) { [weak self] result in
            self?.handleWatchResult(result: result, completion: completion)
        }
    }

    private func handleWatchResult(result: Result<WatchResponse, Error>, completion: @escaping (String) -> Void) {
        if case .success = result {
            self.sendLongPoll { (result: Result<LongPollWatchResult, Error>) in
                if case let .success(response) = result {
                    completion(response.jsep.sdp)
                }
            }
        }
    }

    public func list(completion: @escaping ([StreamInfo]) -> Void) {
        guard let sessionId = sessionId else { return }
        guard let handleId = handleId else { return }
        let transaction = "list"
        let request = ListRequest(transaction: transaction)
        apiClient.request(.list(sessionId, handleId, request)) { (result: Result<ListResult, Error>) in
            if case let .success(response) = result {
                completion(response.plugindata.data.list)
            }
        }
    }

    public func start(sdp: String, completion: @escaping () -> Void) {
        guard let sessionId = sessionId else { return }
        guard let handleId = handleId else { return }
        let transaction = "start"
        let jsep = JSEP(type: .answer, sdp: sdp)
        let request = StartRequest(transaction: transaction, jsep: jsep)
        apiClient.request(.start(sessionId, handleId, request)) { (result: Result<StartResponse, Error>) in
            if case .success = result {
                self.sendLongPoll { (_: Result<LongPollStartResult, Error>) in
                    completion()
                }
            }
        }
    }

    private func sendLongPoll<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
        guard let sessionId = sessionId else { return }
        apiClient.request(.longPoll(sessionId), completion: completion)
    }
}
