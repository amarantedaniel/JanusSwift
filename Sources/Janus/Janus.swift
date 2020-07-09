import Foundation

struct Janus {
    let apiClient = APIClient()

    func createSession(completion: @escaping (Int) -> Void) {
        let transactionId = "asdasd"
        let request = CreateRequest(transaction: transactionId)
        apiClient.request(request: .create(request)) { (result: Result<CreateResponse, Error>) in
            if case let .success(response) = result {
                completion(response.data.id)
            }
        }
    }

    func attachPlugin(sessionId: Int, plugin: Plugin, completion: @escaping (Int) -> Void) {
        let transaction = "other_transaction"
        let request = AttachPluginRequest(transaction: transaction, plugin: plugin)
        apiClient.request(request: .attachPlugin(sessionId, request)) { (result: Result<AttachPluginResponse, Error>) in
            if case let .success(response) = result {
                print(response)
            }
            completion(1)
        }
    }
}
