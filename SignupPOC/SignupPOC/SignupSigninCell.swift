//
//  SignupSigninCell.swift
//  ZKSignup
//
//  Created by Zeeshan Khan on 2/25/17.
//  Copyright © 2017 Zeeshan Khan. All rights reserved.
//

import Foundation
import UIKit

typealias EntryCellCallback = ((_ indexPath: IndexPath, _ item: CellType) -> Void)

class CommonEntryCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var lblWarning: UILabel!

    fileprivate var item: CellType?
    fileprivate var indexPath: IndexPath?

    var isModified = false
    var textDidChange: EntryCellCallback?
    var didEndEditing: EntryCellCallback?
    var didBeginEditing: ((_ textField: UITextField) -> Void)?

    override func awakeFromNib() {
        separator.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        lblWarning.text = ""
    }

    func populateCell(for indexPath: IndexPath, with item: CellType) {

        self.indexPath = indexPath
        self.item = item

        icon.image = UIImage(named: item.iconName)
        textField.placeholder = item.placeholder
        textField.keyboardType = item.keyboard
        textField.isSecureTextEntry = item.isSecure
        textField.text = item.value

        textField.delegate = self

        validateCell(text: item.value)
    }

    func validateCell(text: String) {
        if isModified == false { return }
        guard let item = item else { return }

        if item.isValid(text) {
            separator.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
            lblWarning.text = ""
        } else {
            separator.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            lblWarning.text = item.warningMessage(text)
        }
    }
}

extension CommonEntryCell: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        separator.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        validateCell(text: textField.text!)
        if let callback = didEndEditing {
            item = item?.new(textField.text!)
            callback(indexPath!, item!)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        separator.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lblWarning.text = ""
        if let callback = didBeginEditing {
            callback(textField)
        }
    }

    // Called from addTarget selector on UIControlEvents.editingChanged
    func textFieldDidChange(_ textField: UITextField) {
        guard let item = item else { return }
        isModified = item.shouldValidate

        if let callback = textDidChange {
            self.item = item.new(textField.text!)
            callback(indexPath!, self.item!)
        }
    }

}

protocol PhoneCodeDelegate {
    func phoneCodeAction(with indexPath: IndexPath, item: CellType)
}

class PhoneEntryCell: CommonEntryCell {

    @IBOutlet weak var countryIcon: UIImageView!
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var codeListButton: UIButton!

    var delegate: PhoneCodeDelegate?

    @IBAction func codeListAction() {
        if delegate != nil && indexPath != nil {
            delegate?.phoneCodeAction(with: indexPath!, item: item!)
        }
    }
}
