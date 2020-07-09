import Foundation

struct JSEP: Codable {
    let type: JSEPType
    let sdp: String
    
    enum JSEPType: String, Codable {
        case offer = "offer"
        case answer = "answer"
    }
}
