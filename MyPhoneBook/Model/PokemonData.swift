//
//  PokemonData.swift
//  MyPhoneBook
//
//  Created by Soo Jang on 7/11/24.
//

import UIKit
import Alamofire
import RxSwift

struct Pokemon: Codable {
    let sprites: Sprites
}

struct Sprites: Codable {
    let imgUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case imgUrlString = "front_default"
    }
}

class NetworkManager {
    func fetchData<T: Decodable>(_ url: URL) -> Observable<T> {
        return Observable.create() { observable in
            AF.request(url).responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let result):
                    observable.onNext(result)
                case .failure(let error):
                    observable.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    func fetchImage(_ url: URL) -> Observable<UIImage> {
        return Observable.create { observable in
            AF.request(url).responseData { response in
                if let data = response.data, let image = UIImage(data: data) {
                    observable.onNext(image)
                }
            }
            return Disposables.create()
        }
    }
}
