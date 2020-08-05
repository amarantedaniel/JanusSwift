import Foundation

public class JanusAPI {
    private let apiClient: APIClientProtocol

    public init(baseUrl: URL) {
        self.apiClient = APIClient(baseUrl: baseUrl)
    }

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    public func createSession(completion: @escaping (Int) -> Void) {
        let transactionId = "create"
        let request = CreateRequest(transaction: transactionId)
        apiClient.request(.create(request)) { (result: Result<CreateResponse, Error>) in
            if case let .success(response) = result {
                completion(response.data.id)
            }
        }
    }

    public func attachPlugin(sessionId: Int, plugin: Plugin, completion: @escaping (Int) -> Void) {
        let transaction = "attach"
        let request = AttachPluginRequest(transaction: transaction, plugin: plugin)
        apiClient.request(.attachPlugin(sessionId, request)) { (result: Result<AttachPluginResponse, Error>) in
            if case let .success(response) = result {
                completion(response.data.id)
            }
        }
    }

    public func trickle(
        sessionId: Int,
        handleId: Int,
        candidate: String,
        sdpMLineIndex: Int32,
        sdpMid: String?,
        completion: @escaping () -> Void)
    {
        let transaction = "trickle"
        let request = TrickleRequest(transaction: transaction,
                                     candidate: .init(candidate: candidate, sdpMLineIndex: sdpMLineIndex, sdpMid: sdpMid))
        apiClient.request(.trickle(sessionId, handleId, request)) { (_: Result<TrickleResponse, Error>) in
            completion()
        }
    }

    public func watch(
        sessionId: Int,
        handleId: Int,
        streamId: String,
        pin: String? = nil,
        completion: @escaping (String) -> Void)
    {
        let transaction = "watch"
        let request = WatchRequest(transaction: transaction, streamId: streamId, pin: pin)
        apiClient.request(.watch(sessionId, handleId, request)) { [weak self] result in
            self?.handleWatchResult(sessionId: sessionId, result: result, completion: completion)
        }
    }

    public func watch(
        sessionId: Int,
        handleId: Int,
        streamId: Int,
        pin: String? = nil,
        completion: @escaping (String) -> Void)
    {
        let transaction = "watch"
        let request = WatchRequest(transaction: transaction, streamId: streamId, pin: pin)
        apiClient.request(.watch(sessionId, handleId, request)) { [weak self] result in
            self?.handleWatchResult(sessionId: sessionId, result: result, completion: completion)
        }
    }

    private func handleWatchResult(sessionId: Int, result: Result<WatchResponse, Error>, completion: @escaping (String) -> Void) {
        if case .success = result {
            self.sendLongPoll(sessionId: sessionId) { (result: Result<LongPollWatchResult, Error>) in
                if case let .success(response) = result {
                    completion(response.jsep.sdp)
                }
            }
        }
    }

    public func list(sessionId: Int, handleId: Int, completion: @escaping ([StreamInfo]) -> Void) {
        let transaction = "list"
        let request = ListRequest(transaction: transaction)
        apiClient.request(.list(sessionId, handleId, request)) { (result: Result<ListResult, Error>) in
            if case let .success(response) = result {
                completion(response.plugindata.data.list)
            }
        }
    }

    public func start(sessionId: Int, handleId: Int, sdp: String, completion: @escaping () -> Void) {
        let transaction = "start"
        let jsep = JSEP(type: .answer, sdp: sdp)
        let request = StartRequest(transaction: transaction, jsep: jsep)
        apiClient.request(.start(sessionId, handleId, request)) { (result: Result<StartResponse, Error>) in
            if case .success = result {
                self.sendLongPoll(sessionId: sessionId) { (_: Result<LongPollStartResult, Error>) in
                    completion()
                }
            }
        }
    }

    private func sendLongPoll<T: Decodable>(sessionId: Int, completion: @escaping (Result<T, Error>) -> Void) {
        apiClient.request(.longPoll(sessionId), completion: completion)
    }
}
