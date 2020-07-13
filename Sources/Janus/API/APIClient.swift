import Foundation

struct APIClient {
    let baseUrl: URL
    
    func request<T: Decodable>(request: APIRoute, completion: @escaping (Result<T, Error>) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let task = URLSession.shared.dataTask(with: request.asURLRequest(baseUrl: baseUrl)) { data, _, _ in
            print(String.init(decoding: data!, as: UTF8.self))
            let response = try! decoder.decode(T.self, from: data!)
            completion(.success(response))
        }
        task.resume()
    }
}
