import Foundation

struct WatchRequest: Encodable {
    let janus = "message"
    let transaction: String
    let body: Body
    
    struct Body: Encodable {
        let request = "watch"
        let id = "1"
    }
}
