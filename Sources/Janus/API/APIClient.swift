import Foundation

struct APIClient: APIClientProtocol {
    let baseUrl: URL

    func request<T: Decodable>(_ route: APIRoute, completion: @escaping (Result<T, APIError>) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = URLSession.shared.dataTask(with: route.asURLRequest(baseUrl: baseUrl)) { data, _, _ in
            do {
                let response = try decoder.decode(T.self, from: data!)
                completion(.success(response))
            } catch {
                let jsonResponse = String(decoding: data!, as: UTF8.self)
                print(jsonResponse)
                completion(.failure(.error(jsonResponse)))
            }
        }
        task.resume()
    }
}
