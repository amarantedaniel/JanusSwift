import Foundation

struct ListResult: Decodable {
    let plugindata: PluginData
    struct PluginData: Decodable {
        let data: Data
        struct Data: Decodable {
            let list: [StreamInfo]
        }
    }
}

public struct StreamInfo: Hashable, Decodable {
    public let id: Int
    public let description: String
}
