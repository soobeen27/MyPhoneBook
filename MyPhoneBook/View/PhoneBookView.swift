//
//  PhoneBookView.swift
//  MyPhoneBook
//
//  Created by Soo Jang on 7/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneBookView: UIView {
    let tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 80
        tv.register(PhoneBookTableViewCell.self, forCellReuseIdentifier: TableView.cellIdent)
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [ tableView ].forEach {
            self.addSubview($0)
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        }
    }

}
