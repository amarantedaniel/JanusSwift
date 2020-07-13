import Foundation

protocol URLRequestConvertible {
    func asURLRequest(baseUrl: URL) -> URLRequest
}
