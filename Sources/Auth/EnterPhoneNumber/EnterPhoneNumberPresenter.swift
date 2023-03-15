protocol EnterPhoneNumberPresenterProtocol {
    func loadPhoneNumberForm()
}

final class EnterPhoneNumberPresenter: EnterPhoneNumberPresenterProtocol {

    private let view: EnterPhoneNumberViewProtocol
    private let router: AuthRouterProtocol

    private let authService: AuthService
    private let countriesRepository: CountriesRepository

    init(router: AuthRouterProtocol,
         view: EnterPhoneNumberViewProtocol,
         authService: AuthService,
         countriesRepository: CountriesRepository) {
        self.router = router
        self.view = view
        self.authService = authService
        self.countriesRepository = countriesRepository
    }

    func loadPhoneNumberForm() {
        let props = props(isButtonEnable: false)
        view.render(props)
    }

    private func props(isButtonEnable: Bool) -> EnterPhoneNumber {
        .loaded(EnterPhoneNumber.Form(
                country: countriesRepository.userCountry(),
                isButtonEnable: isButtonEnable,
                onTapSelectCountryButton: routeToSelectCountry,
                onTapContinueButton: sendSmsConfirmationCode(phoneNumber:),
                onPhoneNumberChanged: onPhoneNumberDidChange(phoneNumber:)
            )
        )
    }

    private func routeToSelectCountry() {
        router.route(to: .selectCountry)
    }

    private func sendSmsConfirmationCode(phoneNumber: String) {
        guard authService.isPhoneNumberValid(phoneNumber) else { return }
        view.render(.loading)
        authService.sendSmsConfirmationCode(to: phoneNumber)
    }

    private func onPhoneNumberDidChange(phoneNumber: String) {
        let isButtonEnable = authService.isPhoneNumberValid(phoneNumber)
        let props = props(isButtonEnable: isButtonEnable)
        view.render(props)
    }
}
