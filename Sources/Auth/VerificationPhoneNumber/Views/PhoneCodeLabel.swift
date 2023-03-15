import Foundation
import UIKit

public protocol POTPLabel: UIView {
    var active: Bool { get set }
    var text: String? { get set }
    var textColor: UIColor! { get set }
    var font: UIFont! { get set }
    func updateState()
}

@IBDesignable
open class CHIOTPField<Label: POTPLabel>: UITextField, UITextFieldDelegate {

    @IBInspectable
    public var numberOfDigits: Int = 4 {
        didSet { redraw() }
    }

    @IBInspectable
    public var spacing: Int = 8 {
        didSet { redraw() }
    }

    public var labels: [Label] {
        return stackView.arrangedSubviews.compactMap({ $0 as? Label })
    }

    open override var text: String? {
        didSet {
            self.changeText(oldValue: oldValue, newValue: text)
        }
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: self.bounds)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.isUserInteractionEnabled = false
        stackView.spacing = CGFloat(spacing)
        return stackView
    }()

    private var _textColor: UIColor?
    open override var textColor: UIColor? {
        didSet {
            if _textColor == nil {
                _textColor = oldValue
            }
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        textColor = .clear
        keyboardType = .numberPad
        borderStyle = .none
        textContentType = .oneTimeCode
        delegate = self
        addTarget(self, action: #selector(textChanged), for: .editingChanged)
        addSubview(stackView)
    }

    open override func setNeedsLayout() {
        super.setNeedsLayout()
        stackView.frame = bounds
    }

    open func redraw() {
        stackView.spacing = CGFloat(spacing)

        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        for _ in 0 ..< self.numberOfDigits {
            let label = Label(frame: .zero)
            label.textColor = _textColor
            label.font = font
            label.isUserInteractionEnabled = false
            self.stackView.addArrangedSubview(label)
        }
    }

    private func updateFocus() {
        let focusIndex = text?.count ?? 0
        labels.enumerated().forEach { (index, label) in
            label.active = index == focusIndex
        }
    }

    private func removeFocus() {
        let focusIndex = text?.count ?? 0
        guard focusIndex < numberOfDigits else {
            return
        }
        labels[focusIndex].active = false
    }

    public func textField(_ textField: UITextField,
                          houldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        guard var text = self.text else {
            return false
        }

        if string.isEmpty, text.isEmpty == false {
            labels[text.count - 1].text = nil
            text.removeLast()
            self.text = text
            updateFocus()
            return false
        }

        return text.count < numberOfDigits
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateFocus()
    }

    @objc private func textChanged() {
        guard let text = text, text.count <= numberOfDigits else { return }

        labels.enumerated().forEach({ (ind, label) in

            if ind < text.count {
                let index = text.index(text.startIndex, offsetBy: ind)
                let char = isSecureTextEntry ? "●" : String(text[index])
                label.text = char
            }
        })
        updateFocus()
    }

    private func changeText(oldValue: String?, newValue: String?) {
        guard let text = text, text.count <= numberOfDigits else { return }

        labels.enumerated().forEach({ (ind, label) in

            if ind < text.count {
                let index = text.index(text.startIndex, offsetBy: ind)
                let char = isSecureTextEntry ? "●" : String(text[index])
                label.text = char
                label.updateState()
            }
        })
        if self.isFirstResponder {
            updateFocus()
        }
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        removeFocus()
    }

    open override func caretRect(for position: UITextPosition) -> CGRect {
        let index = self.text?.count ?? 0
        guard index < stackView.arrangedSubviews.count else {
            return .zero
        }
        let viewFrame = self.stackView.arrangedSubviews[index].frame
        let caretHeight = self.font?.pointSize ?? ceil(self.frame.height * 0.6)
        return CGRect(
            x: viewFrame.midX - 1,
            y: ceil((self.frame.height - caretHeight) / 2),
            width: 2,
            height: caretHeight
        )
    }
}

final public class CHIOTPFieldOneLabel: UIView, POTPLabel {
    public var text: String? {
        didSet {
            label.text = text
        }
    }

    public var font: UIFont! {
        didSet { label.font = font }
    }

    public var active = false {
        didSet {
            updateActive(oldValue: oldValue, newValue: active)
        }
    }

    var borderColor: UIColor? {
        didSet { redraw() }
    }

    var cornerRadius: CGFloat = 0 {
        didSet { redraw() }
    }

    var activeShadowColor: UIColor? {
        didSet { redraw() }
    }

    var placeholder: String? {
        didSet { redraw() }
    }

    var placeholderColor: UIColor? {
        didSet { redraw() }
    }

    var activeShadowOpacity: Float = 0

    public var textColor: UIColor! {
        didSet {
            self.label.textColor = textColor
        }
    }

    private var animator = UIViewPropertyAnimator()

    private let label: UILabel

    override init(frame: CGRect) {
        self.label = UILabel(frame: frame)
        super.init(frame: frame)
        self.addSubview(label)
        self.label.textAlignment = .center
        self.clipsToBounds = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func updateState() {
        self.stopAnimation()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.label.frame = self.bounds
    }

    private func updateActive(oldValue: Bool, newValue: Bool) {
        guard oldValue != newValue else { return }

        if newValue == true {
            self.startAnimation()
        } else {
            self.stopAnimation()
        }
    }

    private func redraw() {
        self.layer.borderColor = self.borderColor?.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = self.cornerRadius
        if let placeholder = placeholder {
            self.label.textColor = placeholderColor
            self.label.text = placeholder
        }
    }

    private func startAnimation() {
        animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.9, animations: {
            self.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1)
            self.layer.borderColor = UIColor.systemBlue.cgColor
            self.layer.shadowColor = self.activeShadowColor?.cgColor
            self.layer.shadowRadius = ceil(self.frame.height / 8)
            self.layer.shadowOpacity = self.activeShadowOpacity
            self.layer.borderWidth = 0.75
            self.layer.shadowOffset = CGSize(width: 0, height: self.layer.shadowRadius / 2)
            self.layer.backgroundColor = UIColor.systemGray6.cgColor
            self.label.textColor = self.textColor
            self.text = nil
        })
        animator.startAnimation()
    }

    private func stopAnimation() {
        animator.addAnimations {
            self.layer.transform = CATransform3DIdentity
            self.layer.borderColor = self.text?.isEmpty == false ? UIColor.clear.cgColor : self.borderColor?.cgColor
            self.layer.shadowColor = UIColor.clear.cgColor
            self.layer.shadowRadius = 0
            self.layer.shadowOpacity = 0
            self.layer.backgroundColor = UIColor.clear.cgColor
            self.layer.borderColor = self.borderColor?.cgColor
            self.layer.borderWidth = 1
            if self.placeholder != nil {
                self.label.textColor = self.text != nil ? self.textColor : self.placeholderColor
            }
            self.text = self.text ?? self.placeholder
        }
        animator.startAnimation()
    }
}

@IBDesignable
open class CHIOTPFieldOne: CHIOTPField<CHIOTPFieldOneLabel> {

    @IBInspectable
    public override var numberOfDigits: Int { didSet { redraw() } }

    @IBInspectable
    public override var spacing: Int { didSet { redraw() } }

    @IBInspectable
    public var boxBackgroundColor: UIColor = .white {
        didSet { redraw() }
    }

    @IBInspectable
    public var borderColor: UIColor = .lightGray {
        didSet { redraw() }
    }

    @IBInspectable
    public var cornerRadius: CGFloat = 0 {
        didSet { redraw() }
    }

    @IBInspectable
    public var activeShadowColor: UIColor? = .lightGray {
        didSet { redraw() }
    }

    @IBInspectable
    public var activeShadowOpacity: CGFloat = 0.4 {
        didSet { redraw() }
    }

    @IBInspectable
    public var boxPlaceholder: String? {
        didSet { redraw() }
    }

    @IBInspectable
    public var boxPlaceholderColor: UIColor? = .lightGray {
        didSet { redraw() }
    }

    public override func redraw() {
        super.redraw()
        labels.forEach { (label) in
            label.layer.backgroundColor = boxBackgroundColor.cgColor
            label.borderColor = borderColor
            label.cornerRadius = cornerRadius
            label.activeShadowColor = activeShadowColor
            label.activeShadowOpacity = Float(activeShadowOpacity)
            label.placeholder = boxPlaceholder
            label.placeholderColor = boxPlaceholderColor
        }
    }
}
