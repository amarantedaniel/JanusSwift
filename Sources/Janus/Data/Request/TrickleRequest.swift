import Foundation

struct TrickleRequest: Encodable {
    let janus = "trickle"
    let transaction: String
    let candidate: Candidate

    struct Candidate: Encodable {
        let candidate: String
        let sdpMLineIndex: Int32
        let sdpMid: String?
    }
}
