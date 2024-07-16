//
//  ViewController.swift
//  MyPhoneBook
//
//  Created by Soo Jang on 7/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneBookController: UIViewController {
    
    var phoneBookView: PhoneBookView!
    let coreDataManager = CoreDataManager()
    let networkManager = NetworkManager()
    private let disposeBag = DisposeBag()
    
    lazy var addBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addBtnPressed))
        btn.tintColor = .lightGray
        return btn
    }()
    override func loadView() {
        super.loadView()
        phoneBookView = PhoneBookView(frame: self.view.frame)
        self.view = phoneBookView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        setTableView()
        tableViewCellSelected()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneBookView.tableView.reloadData()
    }
    func setNav() {
        title = "친구목록"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        navigationItem.rightBarButtonItem = self.addBtn
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.shadowImage = UIImage()

    }
    func setTableView() {
        coreDataManager.readAllData().bind(to: phoneBookView.tableView.rx.items(cellIdentifier: TableView.cellIdent, cellType: PhoneBookTableViewCell.self)) { [weak self] (row, item, cell) in
            guard let self else { return }
            cell.nameLabel.text = item.name
            cell.phoneNumLabel.text = item.number
            guard let imageUrl = URL(string: item.profileImg!) else { return }
            self.networkManager.fetchImage(imageUrl)
                .subscribe(onNext: { image in
                    cell.profileImgView.image = image
                }
                           ,onError: { error in
                    print("이미지 로드 에러: \(error)")
                }
                ).disposed(by: disposeBag)
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)
    }
    
    func tableViewCellSelected() {
        phoneBookView.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let addNewVC = AddNewNumController()
                coreDataManager.readAllData().compactMap { array in
                    array.indices.contains(indexPath.row) ? array[indexPath.row] : nil
                }.subscribe(onNext: { value in
                    addNewVC.callBack = {
                        return value
                    }
                }).disposed(by: disposeBag)
                self.navigationController?.pushViewController(addNewVC, animated: true)
            }).disposed(by: disposeBag)
    }
    
    @objc
    func addBtnPressed() {
        let addNewVC = AddNewNumController()
        navigationController?.pushViewController(addNewVC, animated: true)
    }
}
