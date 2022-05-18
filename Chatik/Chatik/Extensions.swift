//
//  UIColor+Extension.swift
//  Chatik
//
//  Created by Vladislav Smetanin on 17.03.2022.
//

import Foundation
import UIKit

extension UIColor {
    static let classicColor: UIColor = .systemGray6
    static let dayColor: UIColor = .systemGray4
    static let nightColor: UIColor = .black
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension MutableCollection {
    subscript(safe index: Index) -> Element? {
        get {
            return indices.contains(index) ? self[index] : nil
        }

        set(newValue) {
            if let newValue = newValue, indices.contains(index) {
                self[index] = newValue
            }
        }
    }
}

extension Date {
    
    static func dateFromCustomString(customString: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.date(from: customString) ?? Date()
    }
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
