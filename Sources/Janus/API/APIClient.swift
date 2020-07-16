import Foundation

struct APIClient: APIClientProtocol {
    let baseUrl: URL

    func request<T: Decodable>(_ route: APIRoute, completion: @escaping (Result<T, Error>) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = URLSession.shared.dataTask(with: route.asURLRequest(baseUrl: baseUrl)) { data, _, _ in
            let response = try! decoder.decode(T.self, from: data!)
            completion(.success(response))
        }
        task.resume()
    }
}
