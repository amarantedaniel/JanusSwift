import Foundation

struct TrickleRequest: Encodable {
    let janus = "trickle"
    let transaction: String
    let candidate: Candidate

    struct Candidate: Encodable {
        let candidate: String
        let sdpMLineIndex: Int
        let sdpMid: String
    }
}
