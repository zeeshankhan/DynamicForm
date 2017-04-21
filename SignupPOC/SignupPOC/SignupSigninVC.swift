//
//  SignupSigninVC.swift
//  ZKSignup
//
//  Created by Zeeshan Khan on 2/20/17.
//  Copyright © 2017 Zeeshan Khan. All rights reserved.
//

import UIKit
import SafariServices

enum SignUpSignInViewType {
    case signUp, signIn, forgotPassword
}

class SignupSigninVC: UIViewController {

    var viewType = SignUpSignInViewType.signUp
    var rows: [CellType] = []

    @IBOutlet weak var entryTableView: UITableView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var forgotPassTnCButton: UIButton!
    @IBOutlet weak var tableBottomMargin: NSLayoutConstraint!

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        signupButton.layer.cornerRadius = 4.0

        switch viewType {
            case .signIn: configureSignIN()
            case .signUp: configureSignUP()
            case .forgotPassword: configureForgotPass()
        }
        
        checkAllFieldValidationAndUpdateSignupButtonState()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

     // MARK: - Configurations

    func configureSignUP() {
        
        self.title = "Sign Up"
        signupButton.setTitle("Sign up", for: .normal)
        // Not required to set ATTRIBUTED title as default is already set for terms and conditions
        forgotPassTnCButton.addTarget(self, action: #selector(pushTermsConditionAction), for: .touchUpInside)
        
        let name = CellType.name("")
        rows.append(name)
        
        let email = CellType.email("")
        rows.append(email)

        let password = CellType.password("")
        rows.append(password)
        
        let phone = CellType.phone(imageCode: "AE", code: "971", number: "")
        rows.append(phone)
        
        let invitationCode = CellType.invitationCode("")
        rows.append(invitationCode)

        addKeyboardNotification()
    }
    
    func configureSignIN() {

        self.title = "Sign In"
        signupButton.setTitle("Sign in", for: .normal)
        forgotPassTnCButton.setAttributedTitle(NSAttributedString(string: "Forgot Password?"), for: .normal)
        forgotPassTnCButton.setAttributedTitle(NSAttributedString(string: "Forgot Password?",
                                                                  attributes: [NSForegroundColorAttributeName: #colorLiteral(red: 0.5723067522, green: 0.5723067522, blue: 0.5723067522, alpha: 1)]), for: .highlighted)
        forgotPassTnCButton.addTarget(self, action: #selector(pushForgotPasswordAction), for: .touchUpInside)
        
        let email = CellType.email("")
        rows.append(email)
        
        let password = CellType.password("")
        rows.append(password)
    }

    func configureForgotPass() {

        self.title = "Forgot Password"
        signupButton.setTitle("Send me a new password", for: .normal)
        forgotPassTnCButton.setAttributedTitle(nil, for: .normal)
        
        let email = CellType.email("")
        rows.append(email)
    }

    
    // MARK:- Validations
    
    func textFieldDidChange() -> EntryCellCallback {
        let callback: EntryCellCallback = { [weak self] indexPath, item in
            self?.rows[indexPath.row] = item
            self?.checkAllFieldValidationAndUpdateSignupButtonState()
        }
        return callback
    }

    func checkAllFieldValidationAndUpdateSignupButtonState() {

        var isAllValid = true
        for item in rows {
            if !item.isValid(item.value) {
                isAllValid = false
                break
            }
        }

        self.signupButton.isEnabled = isAllValid
        self.signupButton.backgroundColor = isAllValid ? #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) : #colorLiteral(red: 0.6980392157, green: 0.8431372549, blue: 1, alpha: 1)
    }

    // MARK:- IBAction

    @IBAction func signupSigninAction() {
        switch viewType {
        case .signUp: register()
        case .signIn: login()
        case .forgotPassword: forgotPassword()
        }
    }

    func pushForgotPasswordAction() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupSigninVC") as! SignupSigninVC
        vc.viewType = .forgotPassword
        navigationController?.pushViewController(vc, animated: true)
    }

    func pushTermsConditionAction() {

        let tncUrl = URL(string: "http://www.example.com/")
        guard let url = tncUrl else {
            return
        }

        if #available(iOS 9.0, *) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
            present(vc, animated: true, completion: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    func register() {
        dump(rows)
    }

    func login() {
        dump(rows)
    }

    func forgotPassword() {
        dump(rows)
    }

}

// MARK: - Datasource, Delegate

extension SignupSigninVC : UITableViewDataSource, PhoneCodeDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = rows[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath) as! CommonEntryCell
        cell.populateCell(for: indexPath, with: item)
        cell.textDidChange = textFieldDidChange()

        if case .phone(let imgC, let code, _) = item {
            let phoneCell = cell as! PhoneEntryCell
            phoneCell.delegate = self
            phoneCell.countryIcon.image = UIImage(named: imgC)
            phoneCell.code.text = "+" + code
        }

        return cell
    }

    func phoneCodeAction(with indexPath: IndexPath, item: CellType) {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryListVC") as! CountryListVC
        vc.didSelectCountry = { [weak self] (code) in

            //print("Code: \(code) \(indexPath) \(item)")
            self?.rows[indexPath.row] = CellType.phone(imageCode: code[kCountryFlag]!,  code: code[kPhoneCode]!, number: item.value)
            self?.entryTableView.reloadRows(at: [indexPath], with: .automatic)
        }

        navigationController?.pushViewController(vc, animated: true)
    }

}
// MARK: - Keyboard handling

extension SignupSigninVC {

    func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(notification:)),
                                               name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(notification:)),
                                               name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    func keyboardWasShown(notification: Notification) {

        guard let info: [AnyHashable:Any] = notification.userInfo,
            let keyboardSize: CGSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size else { return }

        tableBottomMargin.constant = keyboardSize.height
        view.layoutIfNeeded()
    }

    func keyboardWillBeHidden(notification: Notification) {
        tableBottomMargin.constant = 0.0
        view.layoutIfNeeded()
    }
}
