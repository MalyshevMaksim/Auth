enum EnterPhoneNumber {
    case loading
    case loaded(Form)

    struct Form {
        let country: Country
        let isButtonEnable: Bool
        let onTapSelectCountryButton: () -> Void
        let onTapContinueButton: (String) -> Void
        let onPhoneNumberChanged: (String) -> Void
    }
}
