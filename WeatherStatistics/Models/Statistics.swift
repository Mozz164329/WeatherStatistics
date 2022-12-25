
import Foundation

enum BaseRootKeys: String, CodingKey {
    case main, base
}

enum MainRootKeys: String, CodingKey {
    case tempMin = "temp_min"
    case tempMax = "temp_max"
    case pressure, humidity
}

struct Statistics: Codable {
    let base: String
    let tempMin: Float
    let tempMax: Float
    let pressure: Float
    let humidity: Float

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: BaseRootKeys.self)
        self.base = try rootContainer.decode(String.self, forKey: .base)
        let mainContainer = try rootContainer.nestedContainer(keyedBy: MainRootKeys.self, forKey: .main)
        self.tempMin = try mainContainer.decode(Float.self, forKey: .tempMin)
        self.tempMax = try mainContainer.decode(Float.self, forKey: .tempMax)
        self.pressure = try mainContainer.decode(Float.self, forKey: .pressure)
        self.humidity = try mainContainer.decode(Float.self, forKey: .humidity)
    }
}


