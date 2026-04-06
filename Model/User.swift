import Foundation

struct User : Codable, Identifiable {
    var id: String { name }
    let name: String
    var isSelected: Bool = false

    enum CodingKeys: String, CodingKey {
        case name
    }
}
