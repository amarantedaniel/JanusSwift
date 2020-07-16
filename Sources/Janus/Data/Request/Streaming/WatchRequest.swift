import Foundation

struct WatchRequest: Encodable {
    let janus = "message"
    let transaction: String
    let body: Body

    init(transaction: String, streamId: String, pin: String?) {
        self.transaction = transaction
        self.body = Body(id: .string(streamId), pin: pin)
    }
    
    init(transaction: String, streamId: Int, pin: String?) {
        self.transaction = transaction
        self.body = Body(id: .int(streamId), pin: pin)
    }

    struct Body: Encodable {
        let request = "watch"
        let id: StreamId
        let pin: String?
    }
}

enum StreamId: Encodable {
    case string(String)
    case int(Int)
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .string(value):
            try container.encode(value)
        case let .int(value):
            try container.encode(value)
        }
    }
}
