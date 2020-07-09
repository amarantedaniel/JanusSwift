import Foundation

struct AttachPluginResponse: Decodable {
    let transaction: String
    let sessionId: Int
}

struct Handle: Decodable {
    let id: Int
}
