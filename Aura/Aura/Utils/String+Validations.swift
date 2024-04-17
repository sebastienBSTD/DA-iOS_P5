//
//  String+Validations.swift
//  Aura
//
//  Created by Sebastien Bastide on 17/04/2024.
//

import Foundation

extension String {
    func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)

        return emailTest.evaluate(with: self)
    }

    func isPhoneNumber() -> Bool {
        let phoneRegex = "^0[67]\\d{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)

        return phoneTest.evaluate(with: self)
    }
}
