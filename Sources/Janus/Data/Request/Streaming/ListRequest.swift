import Foundation

struct ListRequest: Encodable {
    let janus = "message"
    let transaction: String
    let body: Body = Body()

    struct Body: Encodable {
        let request = "list"
    }
}
