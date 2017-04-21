//
//  String+Validation.swift
//  ZKSignup
//
//  Created by Zeeshan Khan on 3/31/17.
//  Copyright © 2017 Zeeshan Khan. All rights reserved.
//

import Foundation

extension String {

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    func isValidPhone() -> Bool {
        let phoneRegEx = "^09[0-9'@s]{9,9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: self)
    }

    func isValidName() -> Bool {
        return !self.isEmpty
    }
}
