import UIKit
import SnapKit
import Lottie

final class VerificationPhoneNumberView: UIView {

    var bottomConstraint: Constraint!

    override func becomeFirstResponder() -> Bool {
        return smsCodeLabel.becomeFirstResponder()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let animationView: LottieAnimationView = {
        let lottieAnimationView = LottieAnimationView(asset: "Assets.message.name")
        lottieAnimationView.backgroundBehavior = .pauseAndRestore
        lottieAnimationView.contentMode = .scaleAspectFill
        lottieAnimationView.play()
        lottieAnimationView.loopMode = .loop
        return lottieAnimationView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.text = "Strings.EnterPhoneNumber.Texts.title"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "Введите код"
        label.numberOfLines = 2
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.text = "Strings.EnterPhoneNumber.Texts.subtitle"
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "Мы отправили СМС с кодом подтверждения на номер +7 985-684-94-86"
        return label
    }()

    private let smsCodeLabel: CHIOTPFieldOne = {
        let label = CHIOTPFieldOne()
        label.numberOfDigits = 4
        label.cornerRadius = 8
        label.boxBackgroundColor = .systemBackground// Colors.background.color
        label.borderColor = .systemGray5
        label.spacing = 24
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()

    private lazy var resendCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отправить повторно", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        return button
    }()

    private let containerView = UIView()

    private func setupSubviews() {
        backgroundColor = .systemBackground// Colors.background.color
        addSubviews(subviews: containerView, resendCodeButton)
        containerView.addSubviews(subviews: animationView, titleLabel, subtitleLabel, smsCodeLabel)
    }

    private func setupConstraints() {
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        containerView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(resendCodeButton.snp.top)
        }
        animationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).inset(-32).priority(.required)
            $0.width.equalTo(animationView.snp.height).multipliedBy(2).priority(.high)
            $0.height.lessThanOrEqualTo(80)
            $0.top.greaterThanOrEqualTo(safeAreaLayoutGuide).inset(32)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        subtitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(titleLabel.snp.bottom).inset(-16)
            $0.center.equalToSuperview().priority(.medium)
        }
        smsCodeLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).inset(-32)
            $0.leading.trailing.equalToSuperview().inset(48)
            $0.height.equalTo(48)
        }
        resendCodeButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            bottomConstraint = $0.bottom.equalTo(safeAreaLayoutGuide).inset(24).constraint
        }
    }
}
