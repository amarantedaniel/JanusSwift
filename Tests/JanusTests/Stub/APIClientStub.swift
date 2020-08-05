import Foundation
@testable import Janus

class APIClientStub: APIClientProtocol {
    private var longpollRequest: LongpollRequest?

    func request<T: Decodable>(_ route: APIRoute, completion: @escaping (Result<T, APIError>) -> Void) {
        switch route {
        case let .create(request):
            let response = CreateResponse(transaction: request.transaction, data: .init(id: 123))
            completion(.success(response as! T))
        case let .attachPlugin(sessionId, request):
            let response = AttachPluginResponse(transaction: request.transaction, sessionId: sessionId, data: .init(id: 456))
            completion(.success(response as! T))
        case .trickle:
            let response = TrickleResponse()
            completion(.success(response as! T))
        case let .watch(sessionId, _, request):
            longpollRequest = .watch
            let response = WatchResponse(sessionId: sessionId, transaction: request.transaction)
            completion(.success(response as! T))
        case .start:
            let response = StartResponse()
            longpollRequest = .start
            completion(.success(response as! T))
        case let .longPoll(sessionId):
            switch longpollRequest {
            case .watch:
                let response = LongPollWatchResult(sessionId: sessionId, jsep: .init(type: .offer, sdp: "fake-sdp"))
                completion(.success(response as! T))
            case .start:
                let response = LongPollStartResult()
                completion(.success(response as! T))
            case nil:
                break
            }
        case .list(_, _, _):
            let streams = [StreamInfo(id: 10, description: "stream")]
            let response = ListResult(plugindata: .init(data: .init(list: streams)))
            completion(.success(response as! T))
        }
    }

    private enum LongpollRequest {
        case watch
        case start
    }
}
