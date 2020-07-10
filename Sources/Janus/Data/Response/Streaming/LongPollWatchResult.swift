import Foundation

struct LongPollWatchResult: Decodable {
    let sessionId: Int
    let jsep: JSEP
}
