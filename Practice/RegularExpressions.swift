//
//  RegularExpressions.swift
//  Practice
//
//  Created by 新龙科技 on 2016/12/27.
//  Copyright © 2016年 新龙科技. All rights reserved.
//

import UIKit

class RegularExpressions: NSObject {
    enum ValidatedType {
        case Email
        case PhoneNumber
    }
    func ValidateText(validatedType type: ValidatedType, validateString: String) -> Bool {
        do {
            let pattern: String
            if type == ValidatedType.Email {
                pattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            }
            else if type == ValidatedType.PhoneNumber {
                pattern = "^1[0-9]{10}$"
            } else {
                pattern = "^[0-9]"
            }
            
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: validateString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, validateString.characters.count))
            return matches.count > 0
        }
        catch {
            return false
        }
    }
    func EmailIsValidated(vStr: String) -> Bool {
        return ValidateText(validatedType: ValidatedType.Email, validateString: vStr)
    }
    func PhoneNumberIsValidated(vStr: String) -> Bool {
        return ValidateText(validatedType: ValidatedType.PhoneNumber, validateString: vStr)
    }
}
