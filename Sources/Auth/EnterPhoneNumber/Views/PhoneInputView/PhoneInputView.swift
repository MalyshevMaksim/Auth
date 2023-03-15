import UIKit
import SnapKit

final class PhoneInputView: UIView {

    private(set) var bottomConstraint: Constraint?
    private var props: EnterPhoneNumber?

    private let strokeColor: UIColor = .systemGray3
    private let arrowSize: CGFloat = 10
    private let selectCountryButtonHeight: CGFloat = 64
    private let phoneInputHeight: CGFloat = 42
    private let inset: CGFloat = 24
    private let lineWidth: CGFloat = 1.0 / UIScreen.main.scale

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return phoneTextField.becomeFirstResponder()
    }

    override var intrinsicContentSize: CGSize {
        let height = selectCountryButtonHeight + phoneInputHeight
        return CGSize(width: frame.width, height: height)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawSelectCountryButtonBackground()
        drawDividerBetweenTextFields()
        drawBottomLine()
    }

    private lazy var selectCountryButton: SelectCountryButton = {
        let button = SelectCountryButton(type: .system)
        button.addTarget(self, action: #selector(onTapSelectCountryButton), for: .touchUpInside)
        return button
    }()

    private lazy var countryCodeTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .phonePad
        textField.addTarget(self, action: #selector(countryCodeTextFieldDidChange), for: .editingChanged)
        textField.textAlignment = .center
        return textField
    }()

    private lazy var phoneTextField: MaskedTextField = {
        let textField = MaskedTextField()
        textField.keyboardType = .phonePad
        textField.addTarget(self, action: #selector(countryCodeTextFieldDidChange), for: .editingChanged)
        textField.textAlignment = .center
        return textField
    }()

    private func drawSelectCountryButtonBackground() {
        let buttonBackgroundPath = UIBezierPath()
        strokeColor.setStroke()
        buttonBackgroundPath.lineWidth = lineWidth

        buttonBackgroundPath.move(to: CGPoint(x: inset, y: lineWidth / 2.0))
        buttonBackgroundPath.addLine(to: CGPoint(x: frame.width - inset, y: lineWidth / 2.0))
        buttonBackgroundPath.stroke()

        buttonBackgroundPath.move(to: CGPoint(
            x: frame.size.width - inset,
            y: selectCountryButtonHeight - arrowSize - lineWidth / 2.0)
        )
        buttonBackgroundPath.addLine(to: CGPoint(
            x: 69,
            y: selectCountryButtonHeight - arrowSize - lineWidth / 2.0)
        )
        buttonBackgroundPath.addLine(to: CGPoint(
            x: 69 - arrowSize,
            y: selectCountryButtonHeight - lineWidth / 2.0)
        )
        buttonBackgroundPath.addLine(to: CGPoint(
            x: 69 - arrowSize * 2,
            y: selectCountryButtonHeight - arrowSize - lineWidth / 2.0)
        )
        buttonBackgroundPath.addLine(to: CGPoint(
            x: inset,
            y: selectCountryButtonHeight - arrowSize - lineWidth / 2.0)
        )
        buttonBackgroundPath.stroke()
    }

    private func drawBottomLine() {
        let path = UIBezierPath()
        strokeColor.setStroke()
        path.lineWidth = lineWidth
        path.move(to: CGPoint(x: frame.width - inset, y: frame.height - lineWidth / 2.0))
        path.addLine(to: CGPoint(x: inset, y: frame.height - lineWidth / 2.0))
        path.close()
        path.stroke()
    }

    private func drawDividerBetweenTextFields() {
        let path = UIBezierPath()
        strokeColor.setStroke()
        path.lineWidth = lineWidth
        path.move(to: CGPoint(x: 120 - inset, y: frame.height - arrowSize))
        path.addLine(to: CGPoint(x: 120 - inset, y: selectCountryButtonHeight))
        path.close()
        path.stroke()
    }

    private func setupSubviews() {
        backgroundColor = .systemBackground // Colors.background.color
        addSubviews(subviews: selectCountryButton, countryCodeTextField, phoneTextField)
        setupConstraints()
    }

    private func setupConstraints() {
        selectCountryButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(selectCountryButtonHeight)
        }
        countryCodeTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(inset)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(selectCountryButtonHeight - arrowSize)
            $0.width.equalTo(105 - inset * 2)
        }
        phoneTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(120 - inset + 12)
            bottomConstraint = $0.bottom.equalToSuperview().constraint
            $0.height.equalTo(selectCountryButtonHeight - arrowSize)
        }
    }

    @objc private func countryCodeTextFieldDidChange() {
        if case let .loaded(props) = self.props {
            let countryCode = countryCodeTextField.text ?? ""
            let phoneNumber = phoneTextField.text ?? ""
            props.onPhoneNumberChanged(countryCode + phoneNumber)
        }
    }

    @objc private func onTapSelectCountryButton() {
        if case let .loaded(props) = self.props {
            props.onTapSelectCountryButton()
        }
    }
}

// MARK: - EnterPhoneNumberViewProtocol
extension PhoneInputView: EnterPhoneNumberViewProtocol {

    func render(_ props: EnterPhoneNumber) {
        self.props = props
        switch props {
        case .loaded(let props):
            selectCountryButton.setTitle(props.country.emoji + " " + props.country.name, for: .normal)
            countryCodeTextField.text = props.country.phoneCode
            phoneTextField.textMask = props.country.phoneMask
            phoneTextField.becomeFirstResponder()
            isUserInteractionEnabled = true
        case .loading:
            isUserInteractionEnabled = false
        }
    }
}
