//
//  PokemonData.swift
//  MyPhoneBook
//
//  Created by Soo Jang on 7/11/24.
//

import UIKit
import Alamofire

struct Pokemon: Codable {
    let sprites: Sprites
}

struct Sprites: Codable {
    let imgUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case imgUrlString = "front_default"
    }
}

//class DataManager {
//    func fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void) {
//        let session = URLSession(configuration: .default)
//        session.dataTask(with: URLRequest(url: url)) { data, response, error in
//            guard let data = data, error == nil else {
//                print("데이터 로드 실패")
//                completion(nil)
//                return
//            }
//            // http status code 성공 범위.
//            let successRange = 200..<300
//            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
//                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
//                    print("JSON 디코딩 실패")
//                    completion(nil)
//                    return
//                }
//                completion(decodedData)
//            } else {
//                print("응답 오류")
//                completion(nil)
//            }
//        }.resume()
//    }
//    
//    func getImg(urlString: String, complitionHandler: @escaping (_: UIImage) -> Void) {
//        guard let imageUrl = URL(string: urlString) else { return }
//        DispatchQueue.global(qos: .background).async {
//            if let data = try? Data(contentsOf: imageUrl) {
//                if let image = UIImage(data: data) {
//                    complitionHandler(image)
//                }
//            }
//        }
//        
//    }
//}

class DataManager {
    func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    func getImg(urlString: String, completionHandler: @escaping (_: UIImage) -> Void) {
        guard let imageUrl = URL(string: urlString) else { return }
        AF.request(imageUrl).responseData { response in
            if let data = response.data, let image = UIImage(data: data) {
                completionHandler(image)
            }
        }
    }
}
