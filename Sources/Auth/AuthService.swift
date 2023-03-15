public protocol AuthService {
    func sendSmsConfirmationCode(to phone: String)
    func isPhoneNumberValid(_ phone: String) -> Bool
}
