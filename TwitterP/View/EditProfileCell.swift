//
//  EditProfileCell.swift
//  TwitterP
//
//  Created by Damian Piszcz on 02/02/2023.
//

import UIKit

protocol EditProfileCellDelegate: AnyObject {
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {
    
    var viewModel: EditProfileViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: EditProfileCellDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Test title"
        return label
    }()
    
     let infoTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .left
        tf.textColor = .twitterBlue
        tf.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        tf.text = "test user attribute"
        return tf
    }()
    
     let bioTextView: CaptionTextView =  {
        let tv = CaptionTextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = .twitterBlue
        tv.placeholderLabel.text = "bio"
        return tv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 16)
        
        contentView.addSubview(infoTextField)
        infoTextField.anchor(top: topAnchor, left: titleLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 8)
        
        contentView.addSubview(bioTextView)
        bioTextView.anchor(top: topAnchor, left: titleLabel.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserInfo), name: UITextView.textDidEndEditingNotification, object: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleUpdateUserInfo() {
        delegate?.updateUserInfo(self)
    }
    
    func configure() {
        guard let viewModel = viewModel else {return}
        
        infoTextField.isHidden = viewModel.shouldHideTextField
        bioTextView.isHidden = viewModel.shouldHideTextView
        
        titleLabel.text = viewModel.titleText
        infoTextField.text = viewModel.optionValue
        
        bioTextView.placeholderLabel.isHidden = viewModel.shouldHidePlaceholderLabel
        bioTextView.text = viewModel.optionValue
    }
}
