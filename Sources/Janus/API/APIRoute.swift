import Foundation

enum APIRoute: URLRequestConvertible {
    case create(CreateRequest)
    case attachPlugin(Int, AttachPluginRequest)
    case trickle(Int, Int, TrickleRequest)
    case watch(Int, Int, WatchRequest)
    case start(Int, Int, StartRequest)
    case list(Int, Int, ListRequest)
    case longPoll(Int)
    case keepAlive(Int, KeepAliveRequest)
    
    private var method: String {
        switch self {
        case .longPoll:
            return "GET"
        case .create, .attachPlugin, .watch, .start, .trickle, .list, .keepAlive:
            return "POST"
        }
    }
    
    private func url(baseUrl: URL) -> URL {
        switch self {
        case .create:
            return baseUrl
        case let .attachPlugin(sessionId, _):
            return baseUrl.appendingPathComponent("/\(sessionId)")
        case let .longPoll(sessionId):
            return baseUrl.appendingPathComponent("/\(sessionId)")
        case let .watch(sessionId, handleId, _):
            return baseUrl.appendingPathComponent("/\(sessionId)/\(handleId)")
        case let .start(sessionId, handleId, _):
            return baseUrl.appendingPathComponent("/\(sessionId)/\(handleId)")
        case let .trickle(sessionId, handleId, _):
            return baseUrl.appendingPathComponent("/\(sessionId)/\(handleId)")
        case let .list(sessionId, handleId, _):
            return baseUrl.appendingPathComponent("/\(sessionId)/\(handleId)")
        case  let .keepAlive(sessionId, _):
            return baseUrl.appendingPathComponent("/\(sessionId)")
        }
    }
    
    private var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case let .create(request):
            return try? encoder.encode(request)
        case let .attachPlugin(_, request):
            return try? encoder.encode(request)
        case let .watch(_, _, request):
            return try? encoder.encode(request)
        case let .start(_, _, request):
            return try? encoder.encode(request)
        case let .trickle(_, _, request):
            return try? encoder.encode(request)
        case let .list(_, _, request):
            return try? encoder.encode(request)
        case .longPoll:
            return nil
        case let .keepAlive(_, request):
            return try? encoder.encode(request)
        }
    }
    
    func asURLRequest(baseUrl: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url(baseUrl: baseUrl))
        urlRequest.httpMethod = method
        urlRequest.httpBody = body
        return urlRequest
    }
}
