import Foundation

struct CreateRequest: Encodable {
    let janus = "create"
    let transaction: String
}
