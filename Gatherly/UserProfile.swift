import SwiftData
import Foundation

@Model
class UserProfile {
    var imageData: Data?

    init(imageData: Data? = nil) {
        self.imageData = imageData
    }
}
