public protocol AuthService {
    func sendSmsConfirmationCode(to phoneNumber: String)
    func isPhoneNumberValid(_ phoneNumber: String) -> Bool
}
