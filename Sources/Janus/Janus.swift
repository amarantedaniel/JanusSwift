import Foundation

struct Janus {
    let apiClient = APIClient()

    func createSession(completion: @escaping (Int) -> Void) {
        let transactionId = "create"
        let request = CreateRequest(transaction: transactionId)
        apiClient.request(request: .create(request)) { (result: Result<CreateResponse, Error>) in
            if case let .success(response) = result {
                completion(response.data.id)
            }
        }
    }

    func attachPlugin(sessionId: Int, plugin: Plugin, completion: @escaping (Int) -> Void) {
        let transaction = "attach"
        let request = AttachPluginRequest(transaction: transaction, plugin: plugin)
        apiClient.request(request: .attachPlugin(sessionId, request)) { (result: Result<AttachPluginResponse, Error>) in
            if case let .success(response) = result {
                completion(response.data.id)
            }
        }
    }

    func watch(sessionId: Int, handleId: Int, completion: @escaping (JSEP) -> Void) {
        let transaction = "watch"
        let request = WatchRequest(transaction: transaction,
                                   body: WatchRequest.Body())
        apiClient.request(request: .watch(sessionId, handleId, request)) { (result: Result<WatchResponse, Error>) in
            if case .success = result {
                self.sendLongPoll(sessionId: sessionId, completion: completion)
            }
        }
    }

    private func sendLongPoll(sessionId: Int, completion: @escaping (JSEP) -> Void) {
        apiClient.request(request: .longPoll(sessionId)) { (result: Result<LongPollResult, Error>) in
            if case let .success(response) = result {
                completion(response.jsep)
            }
        }
    }
}
