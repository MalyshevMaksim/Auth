import UIKit

final class MaskedTextField: UITextField {

    var textMask: String? {
        didSet {
            self.text = textMask
            textColor = .secondaryLabel
            if #available(iOS 16.0, *) {
                text?.replace("X", with: "0")
            } else {
                // Fallback on earlier versions
            }
        }
    }

    private var filledString = "" {
        didSet {
            guard let text = text else { return }
            let attrubutedText = NSMutableAttributedString(string: text)
            attrubutedText.addAttribute(
                NSAttributedString.Key.foregroundColor,
                value: UIColor.black,
                range: NSRange(location: 0, length: filledString.count)
            )
            self.attributedText = attrubutedText
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        textAlignment = .left
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITextFieldDelegate
extension MaskedTextField: UITextFieldDelegate {

    func maskedText(_ text: String) -> String {
        guard let textMask else { return text }

        let cleanPhoneNumber = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var result = ""
        var index = cleanPhoneNumber.startIndex

        for character in textMask where index < cleanPhoneNumber.endIndex {
             if character == "X" {
                 result.append(cleanPhoneNumber[index])
                 index = cleanPhoneNumber.index(after: index)
             } else {
                 result.append(character)
             }
         }
        return result
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            self.selectedTextRange = self.textRange(from: self.beginningOfDocument, to: self.beginningOfDocument)
        }
        return true
    }

     func textField(_ textField: UITextField,
                    shouldChangeCharactersIn range: NSRange,
                    replacementString string: String) -> Bool {

         guard let text = textField.text, filledString.count < textMask!.count else { return false }

         var isDigit = true

         let char: Character = Array(textMask!)[range.upperBound]

         if char != "X" {
             isDigit = false
         }

         let position = textField.beginningOfDocument
         let offset = isDigit ? range.upperBound + 1 : range.upperBound + 2

         if let carriagePosition = textField.position(from: position, offset: offset) {
            setCarriagePosition(position: carriagePosition)
         }

         if string.isEmpty {
             filledString.removeLast()
         } else {
             filledString = text.substring(to: offset)
         }
         print("RANGE:", range)
         print("FILLED:", filledString)

         return false
     }

    private func setCarriagePosition(position: UITextPosition) {
        DispatchQueue.main.async {
            self.selectedTextRange = self.textRange(from: position, to: position)
        }
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to offset: Int) -> String {
        let toIndex = index(from: offset)
        return String(self[..<toIndex])
    }

    func substring(with range: Range<Int>) -> String {
        let startIndex = index(from: range.lowerBound)
        let endIndex = index(from: range.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
