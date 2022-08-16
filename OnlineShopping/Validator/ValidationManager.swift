//
//  Validator.swift
//  Choco
//
//  Created by Mozhgan on 9/27/21.
//

import Foundation
class ValidationManager {

    // MARK: validate emailID
    static func validateEmail(email: String) -> Bool {
        let regexEmail = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        guard email.isEmpty == false else {
            return false
        }
        let predicate = NSPredicate(format:"SELF MATCHES[c] %@", regexEmail)
        return predicate.evaluate(with: email)
    }
}
