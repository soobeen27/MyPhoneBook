//
//  PhoneBookTableViewCell.swift
//  MyPhoneBook
//
//  Created by Soo Jang on 7/11/24.
//

import UIKit
import SnapKit

class PhoneBookTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let profileImgView: UIImageView = {
        let iv = UIImageView()
        iv.layer.borderColor = UIColor.label.cgColor
        iv.layer.borderWidth = 1
        return iv
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "name"
        return label
    }()
    let phoneNumLabel: UILabel = {
       let label = UILabel()
        label.text = "010-0000-0000"
        return label
    }()
    
    private func configureUI() {        
        [ profileImgView, nameLabel, phoneNumLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        profileImgView.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImgView.snp.trailing).offset(20)
        }
        phoneNumLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
        profileImgView.clipsToBounds = true
        profileImgView.layer.cornerRadius = 30
    }
}
