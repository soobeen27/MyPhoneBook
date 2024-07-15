//
//  AddNewNumController.swift
//  MyPhoneBook
//
//  Created by Soo Jang on 7/11/24.
//

import UIKit
import CoreData
import Alamofire
import RxSwift

class AddNewNumController: UIViewController {
    
    lazy var addBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(addBtnPressed))
        return btn
    }()
    
    var imageUrl: String?
    var addNewNumView: AddNewNumView!
    let coreDataManager = CoreDataManager()
    var nameForUpdate: String?
    var callBack: (() -> PhoneBook)?
    
    
    let networkManager = NetworkManager()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        setValues()
        
        addNewNumView.randImgBtn.addAction( UIAction {_ in
            self.fetchData()
        }, for: .touchDown)
    }
    
    override func loadView() {
        super.loadView()
        addNewNumView = AddNewNumView(frame: self.view.frame)
        self.view = addNewNumView
    }
    
    func setNav() {
        title = "연락처 추가"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        navigationItem.rightBarButtonItem = self.addBtn
    }
    
    func setValues() {
        guard let phoneBook = callBack?() else { return }
        guard let name = phoneBook.name else { return }
        self.nameForUpdate = name
        self.addNewNumView.nameTextView.text = phoneBook.name
        self.addNewNumView.numTextView.text = phoneBook.number
        self.imageUrl = phoneBook.profileImg
        guard let url = URL(string: self.imageUrl!) else { return }
        networkManager.fetchImage(url).subscribe(onNext: { [weak self] image in
            guard let self = self else { return }
            self.addNewNumView.profileImgView.image = image
        }).disposed(by: disposeBag)
    }
    
    func updateData(currentName: String) {
        coreDataManager.updateData(currentName: currentName) { result in
            for data in result as [NSManagedObject] {
                data.setValue(self.addNewNumView.nameTextView.text, forKey: PhoneBook.Key.name)
                data.setValue(self.addNewNumView.numTextView.text, forKey: PhoneBook.Key.number)
                data.setValue(self.imageUrl, forKey: PhoneBook.Key.profileImg)

                print("데이터 수정 완료")
            }
        }
    }
    
    @objc
    func addBtnPressed() {
        print("add btn pressed")
        guard let name = addNewNumView.nameTextView.text else { print("name error") 
            return }
        guard let number = addNewNumView.numTextView.text else {print("num error") 
            return }
        guard let profileImg = imageUrl else { print("img error") 
            return }
        guard let nameForUpdate else {
            coreDataManager.createData(name: name, number: number, profileImg: profileImg)
            navigationController?.popViewController(animated: true)
            return
        }
        updateData(currentName: nameForUpdate)
        navigationController?.popViewController(animated: true)
    }
    
    func fetchData() {
        let urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon/\(Int.random(in: 1...10))/")
        
        guard let url = urlComponents?.url else {
            print("잘못된 URL")
            return
        }
        networkManager.fetchData(url)
            .subscribe(onNext: { [weak addNewNumView] (result: Pokemon) in
                guard let addNewNumView else { return }
                self.imageUrl = result.sprites.imgUrlString
                guard let imageUrl = URL(string:result.sprites.imgUrlString) else { return }
                self.networkManager.fetchImage(imageUrl)
                    .subscribe(onNext: { image in
                        addNewNumView.profileImgView.image = image
                    }).disposed(by: self.disposeBag)
            }
                       ,onError: { error in
                print(error)
            }
            ).disposed(by: disposeBag)
    }
}

