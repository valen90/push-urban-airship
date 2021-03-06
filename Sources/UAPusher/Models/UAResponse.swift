import Vapor
import HTTP

final public class UAResponse {
    public let responses: [Response]
    
    public var status: Status {
        for response in responses {
            if response.status != .accepted {
                return response.status
            }
        }
        
        return .accepted
    }
    
    init(responses: [Response]) {
        self.responses = responses
    }
}
