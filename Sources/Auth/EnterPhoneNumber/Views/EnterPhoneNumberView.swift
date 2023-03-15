import UIKit
import SnapKit
import CommonUI
import Lottie

protocol EnterPhoneNumberViewProtocol: AnyObject {
    var bottomConstraint: Constraint? { get }
    func render(_ props: EnterPhoneNumber)
}

final class EnterPhoneNumberView: UIView {

    private(set) var bottomConstraint: Constraint?
    private var props: EnterPhoneNumber?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return phoneInputView.becomeFirstResponder()
    }

    private let containerView = UIView()
    private let phoneInputView = PhoneInputView()

    private let telephoneAnimationView: LottieAnimationView = {
        let lottieAnimationView = LottieAnimationView(asset: "Assets.telephone.name")
        lottieAnimationView.loopMode = .repeat(2)
        lottieAnimationView.backgroundBehavior = .pauseAndRestore
        lottieAnimationView.contentMode = .scaleAspectFill
        lottieAnimationView.play()
        return lottieAnimationView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.text = "Strings.EnterPhoneNumber.Texts.title"
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.text = "Strings.EnterPhoneNumber.Texts.subtitle"
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private lazy var continueButton: ContinueButton = {
        let button = ContinueButton(type: .system)
        button.setTitle("Strings.EnterPhoneNumber.Buttons.continueButton", for: .normal)
        button.addTarget(self, action: #selector(onTapContinueButton), for: .touchUpInside)
        return button
    }()

    private func setupSubviews() {
        backgroundColor = .systemBackground // Colors.background.color
        addSubviews(subviews: containerView, continueButton)
        containerView.addSubviews(subviews: telephoneAnimationView, titleLabel, subtitleLabel, phoneInputView)
    }

    private func setupConstraints() {
        phoneInputView.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        containerView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(continueButton.snp.top)
        }
        telephoneAnimationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).inset(-16).priority(.required)
            $0.width.equalTo(telephoneAnimationView.snp.height).multipliedBy(1.8).priority(.high)
            $0.height.lessThanOrEqualTo(85)
            $0.top.greaterThanOrEqualTo(safeAreaLayoutGuide).inset(16)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        subtitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(titleLabel.snp.bottom).inset(-16)
            $0.center.equalToSuperview().priority(.medium)
        }
        phoneInputView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(subtitleLabel.snp.bottom).inset(-24)
        }
        continueButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            bottomConstraint = $0.bottom.equalTo(safeAreaLayoutGuide).inset(24).constraint
            $0.height.equalTo(50)
        }
    }

    @objc private func onTapContinueButton() {
        if case let .loaded(props) = self.props {
            props.onTapContinueButton("")
        }
    }
}

// MARK: - EnterPhoneNumberViewProtocol
extension EnterPhoneNumberView: EnterPhoneNumberViewProtocol {

    func render(_ props: EnterPhoneNumber) {
        self.props = props
        self.phoneInputView.render(props)

        switch self.props {
        case .loading:
            self.continueButton.startLoadingAnimation()
        case let .loaded(props):
            self.continueButton.stopLoadingAnimation()
            self.continueButton.isEnabled = props.isButtonEnable
        default:
            break
        }
    }
}
