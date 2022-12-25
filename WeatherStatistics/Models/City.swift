
import Foundation

enum CityJsonRootKeys: String, CodingKey {
    case id, name, country, state, coord
}

enum CoordCityJsonKeys: String, CodingKey {
    case lon, lat
}

struct City: Codable {
    let id: Int?
    let name: String
    let state: String?
    let country: String?
    let lon: Double
    let lat: Double

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CityJsonRootKeys.self)
        self.id = try rootContainer.decode(Int.self, forKey: .id)
        self.name = try rootContainer.decode(String.self, forKey: .name)
        self.state = try rootContainer.decode(String.self, forKey: .state)
        self.country = try rootContainer.decode(String.self, forKey: .country)
        let coordContainer = try rootContainer.nestedContainer(keyedBy: CoordCityJsonKeys.self, forKey: .coord)
        self.lon = try coordContainer.decode(Double.self, forKey: .lon)
        self.lat = try coordContainer.decode(Double.self, forKey: .lat)
    }
}


