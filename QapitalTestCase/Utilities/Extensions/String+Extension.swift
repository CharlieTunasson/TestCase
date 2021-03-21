//
//  String+Extension.swift
//  QapitalTestCase
//
//  Created by Charlie Tuna on 2021-03-18.
//

import UIKit

private let bundle = Bundle(identifier: "com.tunasson.QapitalTestCase")!

extension String {
    static func localized(key: String) -> String {
        return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
    }

    /* Unused */
    func htmlAttributed(font: UIFont, size: CGFloat, color: UIColor, strongColor: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = """
                <style>
                    html * {
                        font-size: \(size)px;
                        color: \(color.toHexString());
                        font-family: \(font.familyName);
                        font-weight: 400;
                        line-height: 20px;
                        letter-spacing: -0.5px;
                    }
                    strong {
                        color: \(strongColor.toHexString());
                        font-weight: normal;
                    }
                </style> \(self)
            """

            guard let data = htmlCSSString.data(using: .utf8) else {
                return nil
            }

            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return nil
        }
    }

    func attributedStringWithTags(attributes: [NSAttributedString.Key: Any],
                                  tagAttributes: [String: [NSAttributedString.Key: Any]]) -> NSMutableAttributedString? {
        var stringWithoutTags = self
        tagAttributes.forEach { tagAttributes in
            stringWithoutTags = stringWithoutTags.deleteHTMLTag(tag: tagAttributes.key)
        }

        let mutableAttributedString = NSMutableAttributedString(string: stringWithoutTags,
                                                                attributes: attributes)

        tagAttributes.forEach { tagAttributes in

            let startTag = "<\(tagAttributes.key)>"
            let endTag = "</\(tagAttributes.key)>"

            let startIndexes: [Int] = self.indicesOf(string: startTag)
            let endIndexes: [Int] = self.indicesOf(string: endTag)

            guard startIndexes.count == endIndexes.count else { return }

            let ranges: [NSRange] = startIndexes.enumerated().map { (arrayIndex, startIndex) -> NSRange in
                var startIndexWithoutATag = startIndex - (arrayIndex * startTag.count) - (arrayIndex * endTag.count)
                if startIndexWithoutATag < 0 { startIndexWithoutATag = 0 }
                let endIndex = endIndexes[arrayIndex] - startTag.count - (arrayIndex * startTag.count) - (arrayIndex * endTag.count)
                return NSRange(location: startIndexWithoutATag, length: endIndex - startIndexWithoutATag)
            }

            ranges.forEach { range in
                mutableAttributedString.addAttributes(tagAttributes.value, range: range)
            }
        }

        return mutableAttributedString
    }

    func deleteHTMLTag(tag:String) -> String {
        return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }

    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex

        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }

        return indices
    }
}
