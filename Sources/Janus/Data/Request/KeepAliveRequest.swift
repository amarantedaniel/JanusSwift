import Foundation

struct KeepAliveRequest: Encodable {
    let janus = "keepalive"
    let transaction: String
}
