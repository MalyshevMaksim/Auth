import UIKit

public final class AuthAssembly {

    private let authService: AuthService
    private let authRouter: AuthRouterProtocol
    private let countriesRepository: CountriesRepository

    public init(authService: AuthService,
                authRouter: AuthRouterProtocol,
                countriesRepository: CountriesRepository) {
        self.authService = authService
        self.authRouter = authRouter
        self.countriesRepository = countriesRepository
    }
    
    public func enterPhoneNumberScreen() -> UIViewController {
        let view = EnterPhoneNumberView()
        let presenter = EnterPhoneNumberPresenter(
            router: authRouter,
            view: view,
            authService: authService,
            countriesRepository: countriesRepository
        )
        return EnterPhoneNumberViewController(presenter: presenter, enterPhoneNumberView: view)
    }

    public func selectCountryScreen() -> UIViewController {
        let view = SelectCountryView()
        let presenter = SelectCountryPresenter(
            view: view,
            router: authRouter,
            countriesRepository: countriesRepository
        )
        return SelectCountryViewController(presenter: presenter, view: view)
    }
    
    public func verificationPhoneScreen() -> UIViewController {
        return VerificationPhoneNumberViewController()
    }
}
