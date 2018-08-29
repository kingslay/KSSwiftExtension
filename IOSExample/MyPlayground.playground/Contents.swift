//: Playground - noun: a place where people can play

import UIKit

protocol Formattable {
    /// A string.
    var content: String { get }

    /// An formatting function.
    func formattedContent() -> String
}

extension Formattable {
    func formattedContent() -> String {
        return content
    }

    func debugFormattedContent() -> String {
        return "Content: \(content)"
    }
}

extension Formattable {}

struct Day: Formattable {
    var content: String

    func formattedContent() -> String {
        return "Today is \(content)"
    }

    func debugFormattedContent() -> String {
        return "Day: \(content)"
    }
}

let a = Day(content: "Monday")
let b: Formattable = Day(content: "Monday")

a.formattedContent()
b.formattedContent()
a.debugFormattedContent()
b.debugFormattedContent()
