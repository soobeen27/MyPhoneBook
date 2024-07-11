//
//  AddNewNumView.swift
//  MyPhoneBook
//
//  Created by Soo Jang on 7/11/24.
//

import UIKit
import SnapKit

class AddNewNumView: UIView {

    let profileImgView: UIImageView = {
        let iv = UIImageView()
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.label.cgColor
        return iv
    }()
    
    let randImgBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("랜덤 이미지 생성", for: .normal)
        btn.setTitleColor(.lightGray, for: .normal)
        return btn
    }()
    
    let nameTextView: UITextView = {
        let tv = UITextView()
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 10
        tv.textContainer.maximumNumberOfLines = 1
        tv.font = .systemFont(ofSize: 18)
        tv.isScrollEnabled = false
        tv.sizeToFit()

        return tv
    }()
    let numTextView: UITextView = {
        let tv = UITextView()
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 10
        tv.textContainer.maximumNumberOfLines = 1
        tv.font = .systemFont(ofSize: 18)
        tv.isScrollEnabled = false
        tv.sizeToFit()
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func configureUI() {
        self.backgroundColor = .systemBackground
        
//        [profileImgView, randImgBtn, textViewStackView].forEach{
//            self.addSubview($0)
//        }
        [profileImgView, randImgBtn, nameTextView, numTextView].forEach{
            self.addSubview($0)
        }
        
        profileImgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(150)
            $0.size.equalTo(200)
        }
        profileImgView.clipsToBounds = true
        profileImgView.layer.cornerRadius = 100
        
        randImgBtn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImgView.snp.bottom).offset(30)
        }
        nameTextView.snp.makeConstraints {
            $0.top.equalTo(randImgBtn.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)

        }
        numTextView.snp.makeConstraints {
            $0.top.equalTo(nameTextView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)

        }
    }
}
