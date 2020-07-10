import Foundation

struct AttachPluginResponse: Decodable {
    let transaction: String
    let sessionId: Int
    let data: Handle

    struct Handle: Decodable {
        let id: Int
    }
}
