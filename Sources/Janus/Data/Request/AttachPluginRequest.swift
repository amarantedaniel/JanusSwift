import Foundation

struct AttachPluginRequest: Encodable {
    let janus = "attach"
    let transaction: String
    let plugin: Plugin
}
