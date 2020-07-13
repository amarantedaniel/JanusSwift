import Foundation

struct APIClient {
    let baseUrl: URL

    func request<T: Decodable>(request: APIRoute, completion: @escaping (Result<T, Error>) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let urlRequest = request.asURLRequest(baseUrl: baseUrl)
        print("REQUEST: ")
        if let body = urlRequest.httpBody {
            print(String(decoding: body, as: UTF8.self))
        } else {
            print("NO BODY")
        }

        let task = URLSession.shared.dataTask(with: request.asURLRequest(baseUrl: baseUrl)) { data, _, _ in
            print("RESPONSE: ")
            print(String(decoding: data!, as: UTF8.self))
            let response = try! decoder.decode(T.self, from: data!)
            completion(.success(response))
        }
        task.resume()
    }
}
