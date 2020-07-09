import Foundation

struct StartRequest: Encodable {
    let janus = "message"
    let transaction: String
    let body: Body = Body()
    let jsep: JSEP

    struct Body: Encodable {
        let request = "start"
    }
}
