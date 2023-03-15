public enum AuthRoutes {
    case phoneNumberVerification
    case selectCountry
    case cancelSelectCountry
}

public protocol AuthRouterProtocol {
    func route(to route: AuthRoutes)
}
