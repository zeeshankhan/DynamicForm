//
//  SignupSignCellItem.swift
//  ZKSignup
//
//  Created by Zeeshan Khan on 2/25/17.
//  Copyright © 2017 Zeeshan Khan. All rights reserved.
//

import Foundation
import UIKit

let kCountryFlag        = "code"
let kPhoneCode          = "country_code"
let kPhoneNumber        = "number"

enum CellType {
    case name(String)
    case email(String)
    case password(String)
    case phone(imageCode: String, code: String, number: String)
    case invitationCode(String)

    var value: String {
        switch self {
        case .name(let n): return n
        case .email(let e): return e
        case .password(let p): return p
        case .phone(_, _, let n): return n
        case .invitationCode(let i): return i
        }
    }

    func new(_ value: String) -> CellType {
        switch self {
        case .name: return .name(value)
        case .email: return .email(value)
        case .password: return .password(value)
        case .phone(let imgC, let c, _): return .phone(imageCode: imgC, code: c, number: value)
        case .invitationCode: return .invitationCode(value)
        }
    }

    var identifier: String {
        switch self {
        case .name, .email, .password, .invitationCode: return "CommonEntryCell"
        case .phone: return "PhoneEntryCell"
        }
    }

    var keyboard: UIKeyboardType {
        switch self {
        case .name: return .namePhonePad
        case .email: return .emailAddress
        case .password: return .default
        case .phone: return .phonePad
        case .invitationCode: return .default
        }
    }

    var placeholder: String {
        switch self {
        case .name: return "full name"
        case .email: return "name@example.com"
        case .password: return "password"
        case .phone: return "050 123 4567"
        case .invitationCode: return "Invitation Code (Optional)"
        }
    }

    var iconName: String {
        switch self {
        case .name: return "nameIcon"
        case .email: return "emailIcon"
        case .password: return "passwordIcon"
        case .phone: return "phoneIcon"
        case .invitationCode: return "giftIcon"
        }
    }

    var isSecure: Bool {
        if case .password(_) = self {
            return true
        }
        return false
    }

    var shouldValidate: Bool {
        switch self {
        case .invitationCode: return false
        default: return true
        }
    }

    func isValid(_ text: String) -> Bool {
        switch self {
        case .name: return text.isValidName()
        case .email: return text.isValidEmail()
        case .password: return text.characters.count > 5
        case .phone: return text.characters.count == 9 //text.isValidPhone()
        case .invitationCode: return true //text.characters.count > 5
        }
    }

    func warningMessage(_ text: String) -> String {
        switch self {
        case .name: return "⚠️ Please fill in your name."
        case .email: return text.isEmpty ? "⚠️ Please fill in your email." : "⚠️ Invalid email format."
        case .password: return text.isEmpty ? "⚠️ Please fill in your password." : "⚠️ Password should be 6 characters long."
        case .phone: return text.isEmpty ? "⚠️ Please fill in your phone." : "⚠️ Invalid phone number."
        case .invitationCode: return ""
        }
    }
    
}
