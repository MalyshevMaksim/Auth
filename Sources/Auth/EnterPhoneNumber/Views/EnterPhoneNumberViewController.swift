import UIKit
import CommonUI

final class EnterPhoneNumberViewController: KeyboardObserveViewController {

    private let presenter: EnterPhoneNumberPresenterProtocol
    private let enterPhoneNumberView: EnterPhoneNumberViewProtocol

    init(presenter: EnterPhoneNumberPresenterProtocol,
         enterPhoneNumberView: EnterPhoneNumberViewProtocol) {
        self.presenter = presenter
        self.enterPhoneNumberView = enterPhoneNumberView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = enterPhoneNumberView as? UIView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        presenter.loadPhoneNumberForm()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }

    override func keyboardWillShow(keyboardSize: CGRect) {
        enterPhoneNumberView.bottomConstraint?.update(inset: keyboardSize.height - 16)
        view.layoutIfNeeded()
    }

    override func keyboardWillHide() {
        enterPhoneNumberView.bottomConstraint?.update(inset: 24)
        view.layoutIfNeeded()
    }

    private func setupNavigationController() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
