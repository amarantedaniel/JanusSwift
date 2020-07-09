import Foundation

enum APIRoute: URLRequestConvertible {
    case create(CreateRequest)
    case attachPlugin(Int, AttachPluginRequest)
    case watch(Int, Int, WatchRequest)
    case start(Int, Int, StartRequest)
    case longPoll(Int)
    
    private var method: String {
        switch self {
        case .longPoll:
            return "GET"
        case .create, .attachPlugin, .watch, .start:
            return "POST"
        }
    }
    
    private var url: URL {
        let baseURL = URL(string: "https://janus.conf.meetecho.com/janus")!
        switch self {
        case .create:
            return baseURL
        case let .attachPlugin(sessionId, _):
            return baseURL.appendingPathComponent("/\(sessionId)")
        case let .longPoll(sessionId):
            return baseURL.appendingPathComponent("/\(sessionId)")
        case let .watch(sessionId, handleId, _):
            return baseURL.appendingPathComponent("/\(sessionId)/\(handleId)")
        case let .start(sessionId, handleId, _):
            return baseURL.appendingPathComponent("/\(sessionId)/\(handleId)")
        }
    }
    
    private var body: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        switch self {
        case let .create(request):
            return try? encoder.encode(request)
        case let .attachPlugin(_, request):
            return try? encoder.encode(request)
        case let .watch(_, _, request):
            return try? encoder.encode(request)
        case let .start(_, _, request):
            return try? encoder.encode(request)
        case .longPoll:
            return nil
        }
    }
    
    func asURLRequest() -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.httpBody = body
        return urlRequest
    }
}
