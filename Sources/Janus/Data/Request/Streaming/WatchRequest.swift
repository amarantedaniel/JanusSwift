import Foundation

struct WatchRequest: Encodable {
    let janus = "message"
    let transaction: String
    let body: Body
    
    init(transaction: String, streamId: String, pin: String?) {
        self.transaction = transaction
        self.body = Body(id: streamId, pin: pin)
    }
    
    struct Body: Encodable {
        let request = "watch"
        let id: String
        let pin: String?
    }
}
