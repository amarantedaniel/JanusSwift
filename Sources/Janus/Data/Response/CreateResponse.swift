import Foundation

struct CreateResponse: Decodable {
    let transaction: String
    let data: Session

    struct Session: Decodable {
        let id: Int
    }
}
