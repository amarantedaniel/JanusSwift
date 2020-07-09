import Foundation

public struct Janus {
    private let apiClient = APIClient()

    public init() {}

    public func createSession(completion: @escaping (Int) -> Void) {
        let transactionId = "create"
        let request = CreateRequest(transaction: transactionId)
        apiClient.request(request: .create(request)) { (result: Result<CreateResponse, Error>) in
            if case let .success(response) = result {
                completion(response.data.id)
            }
        }
    }

    public func attachPlugin(sessionId: Int, plugin: Plugin, completion: @escaping (Int) -> Void) {
        let transaction = "attach"
        let request = AttachPluginRequest(transaction: transaction, plugin: plugin)
        apiClient.request(request: .attachPlugin(sessionId, request)) { (result: Result<AttachPluginResponse, Error>) in
            if case let .success(response) = result {
                completion(response.data.id)
            }
        }
    }

    public func watch(sessionId: Int, handleId: Int, completion: @escaping (String) -> Void) {
        let transaction = "watch"
        let request = WatchRequest(transaction: transaction,
                                   body: WatchRequest.Body())
        apiClient.request(request: .watch(sessionId, handleId, request)) { (result: Result<WatchResponse, Error>) in
            if case .success = result {
                self.sendLongPoll(sessionId: sessionId) { (result: Result<LongPollWatchResult, Error>) in
                    if case let .success(response) = result {
                        completion(response.jsep.sdp)
                    }
                }
            }
        }
    }

    private func sendLongPoll<T: Decodable>(sessionId: Int, completion: @escaping (Result<T, Error>) -> Void) {
        apiClient.request(request: .longPoll(sessionId), completion: completion)
    }

    public func start(sessionId: Int, handleId: Int, sdp: String, completion: @escaping () -> Void) {
        let transaction = "start"
        let jsep = JSEP(type: .answer, sdp: sdp)
        let request = StartRequest(transaction: transaction, jsep: jsep)
        apiClient.request(request: .start(sessionId, handleId, request)) { (result: Result<StartResponse, Error>) in
            if case .success = result {
                self.sendLongPoll(sessionId: sessionId) { (_: Result<LongPollStartResult, Error>) in
                    completion()
                }
            }
        }
    }
}
