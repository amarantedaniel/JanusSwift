import Foundation

struct WatchRequest: Encodable {
    let janus = "message"
    let transaction: String
    let body: Body
    
    init(transaction: String, streamId: String) {
        self.transaction = transaction
        self.body = Body(id: streamId)
    }
    
    struct Body: Encodable {
        let request = "watch"
        let id: String
    }
}
