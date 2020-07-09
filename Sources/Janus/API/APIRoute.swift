import Foundation

enum APIRoute: URLRequestConvertible {
    case create(CreateRequest)
    case attachPlugin(Int, AttachPluginRequest)
    
    private var method: String {
        switch self {
        case .create, .attachPlugin:
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
        }
    }
    
    func asURLRequest() -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.httpBody = body
        return urlRequest
    }
}
