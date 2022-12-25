
import Foundation

class JSONService {

    enum FileName: String {
        case cityList = "city_list"
    }

    enum FileType: String {
        case json = "json"
    }

    enum JSONServiceErrors: Error {
        case invalidPath
        case invalidJSON
    }

    static func request<T: Decodable>(fileName name: FileName, fileType type: FileType, completion: @escaping (Result<T, Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: name.rawValue, ofType: type.rawValue)
        else {
            completion(.failure(JSONServiceErrors.invalidPath))
            return
        }

        guard let json = try? String(contentsOfFile: path).data(using: .utf8)
        else {
            completion(.failure(JSONServiceErrors.invalidPath))
            return
        }

        do {
            let data = try JSONDecoder().decode(T.self, from: json)
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
}
