import Foundation

struct LongPollResult: Decodable {
    let sessionId: Int
    let jsep: JSEP
}
