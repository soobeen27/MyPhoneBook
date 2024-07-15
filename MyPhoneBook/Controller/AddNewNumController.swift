//
//  AddNewNumController.swift
//  MyPhoneBook
//
//  Created by Soo Jang on 7/11/24.
//

import UIKit
import CoreData
import Alamofire

class AddNewNumController: UIViewController {
    
    lazy var addBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(addBtnPressed))
        return btn
    }()
    
    var imageUrl: String?
    var addNewNumView: AddNewNumView!
    let dataManager = DataManager()
    let coreDataManager = CoreDataManager()
    var nameForUpdate: String?
    var callBack: (() -> PhoneBook)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        setValues()
//        let vc = PhoneBookController()
        
        addNewNumView.randImgBtn.addAction( UIAction {_ in
            self.fetchPokemon()
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
        dataManager.getImg(urlString: phoneBook.profileImg!) { img in
            img.prepareForDisplay { decodedImage in
                DispatchQueue.main.async {
                    self.addNewNumView.profileImgView.image = decodedImage
                }
            }
        }
    }
    
    func updateData(currentName: String) {
        var container: NSPersistentContainer!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        container = appDelegate.persistentContainer
        // 수정할 데이터를 찾기 위한 fetch request 생성
        let fetchRequest = PhoneBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", currentName) // 예시: 이름이 "Adam"인 데이터 수정
        
        do {
            // fetch request 실행
            let result = try container.viewContext.fetch(fetchRequest)
            
            // 결과 처리
            for data in result as [NSManagedObject] {
                // 데이터 수정
                data.setValue(self.addNewNumView.nameTextView.text, forKey: PhoneBook.Key.name)
                data.setValue(self.addNewNumView.numTextView.text, forKey: PhoneBook.Key.number)
                data.setValue(self.imageUrl, forKey: PhoneBook.Key.profileImg)
                
                // 변경 사항 저장
                try container.viewContext.save()
                print("데이터 수정 완료")
            }
            
        } catch {
            print("데이터 수정 실패")
        }
    }
    
    @objc
    func addBtnPressed() {
        guard let name = addNewNumView.nameTextView.text else { return }
        guard let number = addNewNumView.numTextView.text else { return }
        guard let profileImg = imageUrl else { return }
        guard let nameForUpdate else {
            coreDataManager.createData(name: name, number: number, profileImg: profileImg)
            navigationController?.popViewController(animated: true)
            return
        }
        updateData(currentName: nameForUpdate)
        navigationController?.popViewController(animated: true)
    }
    
    private func fetchPokemon() {
        let urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon/\(Int.random(in: 1...10))/")
        print("https://pokeapi.co/api/v2/pokemon/\(Int.random(in: 1...10))/")
        
        guard let url = urlComponents?.url else {
            print("잘못된 URL")
            return
        }
        
        dataManager.fetchData(url: url) { [self, weak addNewNumView] (result: Result<Pokemon, AFError>) in
            switch result {
            case .success(let result):
                guard let addNewNumView else { return }
                self.imageUrl = result.sprites.imgUrlString
                dataManager.getImg(urlString: self.imageUrl!) { image in
                    image.prepareForDisplay { decodedImg in
                        DispatchQueue.main.async {
                            addNewNumView.profileImgView.image = decodedImg
                        }
                    }
                }
            case .failure(let error):
                print("데이터 로드 실패: \(error)")
            }

        }
    }
}

