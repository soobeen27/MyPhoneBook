//
//  ViewController.swift
//  MyPhoneBook
//
//  Created by Soo Jang on 7/11/24.
//

import UIKit
import SnapKit

class PhoneBookController: UIViewController {

    var phoneBookView: PhoneBookView!
    let coreDataManager = CoreDataManager()
    let dataManager = DataManager()
    var phoneBooks: [PhoneBook] = [] {
        didSet {
            phoneBookView.tableView.reloadData()
        }
    }
//    var profileImgs: [UIImage]?
    
    lazy var addBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addBtnPressed))
        //        btn.setTitleTextAttributes([ NSAttributedString.Key.foregroundColor : UIColor.lightGray ], for: .normal)
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
        configureTableView()
        loadData()
        setNav()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    func configureTableView() {
        phoneBookView.tableView.dataSource = self
        phoneBookView.tableView.delegate = self
    }
    func setNav() {
        title = "친구목록"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        navigationItem.rightBarButtonItem = self.addBtn
    }
    
    @objc
    func addBtnPressed() {
        let addNewVC = AddNewNumController()
        navigationController?.pushViewController(addNewVC, animated: true)
    }
    
    func loadData() {
        coreDataManager.readAllData { phoneBooks in
            self.phoneBooks = phoneBooks
        }
    }
}

extension PhoneBookController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phoneBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableView.cellIdent, for: indexPath) as? PhoneBookTableViewCell else { return UITableViewCell() }
        cell.nameLabel.text = phoneBooks[indexPath.row].name
        cell.phoneNumLabel.text = phoneBooks[indexPath.row].number
        dataManager.getImg(urlString: phoneBooks[indexPath.row].profileImg!) { img in
            img.prepareForDisplay { decodedImage in
                DispatchQueue.main.async {
                    cell.profileImgView.image = decodedImage
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addNewVC = AddNewNumController()
        addNewVC.callBack = {
            self.phoneBooks[indexPath.row]
        }
        navigationController?.pushViewController(addNewVC, animated: true)
    }
}
