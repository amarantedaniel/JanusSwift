import Foundation

struct WatchResponse: Decodable {
    let janus = "ack"
    let sessionId: Int
    let transaction: String
}
