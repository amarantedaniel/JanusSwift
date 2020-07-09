import Foundation

struct JSEP: Decodable {
    let type: JSEPType
    let sdp: String
    
    enum JSEPType: String, Decodable {
        case offer = "offer"
        case answer = "answer"
    }
}
