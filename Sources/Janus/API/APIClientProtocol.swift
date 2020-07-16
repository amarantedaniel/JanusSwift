import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(_ route: APIRoute, completion: @escaping (Result<T, Error>) -> Void)
}
