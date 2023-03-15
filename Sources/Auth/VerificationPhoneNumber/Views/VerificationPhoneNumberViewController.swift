import UIKit

final class VerificationPhoneNumberViewController: UIViewController {

    override func loadView() {
        view = VerificationPhoneNumberView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.becomeFirstResponder()
        subscribeToKeyboardNotifications()
    }

    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        let nsValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        if let keyboardSize = nsValue?.cgRectValue {
            if view.frame.origin.y == 0 {
                (self.view as? VerificationPhoneNumberView)?.bottomConstraint.update(inset: keyboardSize.height - 16)
                view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        (self.view as? VerificationPhoneNumberView)?.bottomConstraint.update(inset: 24)
        view.layoutIfNeeded()
    }
}
