//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

final class AuthenticationViewModel: ObservableObject {

    @Published var username: String = "test@aura.app"
    @Published var password: String = "test123"

    private let authenticator: Authenticator
    private let tokenStore: TokenStore
    let onLoginSucceed: (() -> ())

    init(authenticator: Authenticator = Authenticator(),
         tokenStore: TokenStore = KeychainStore(),
         _ callback: @escaping () -> ()) {
        self.authenticator = authenticator
        self.tokenStore = tokenStore
        self.onLoginSucceed = callback
    }

    func login() async {
        do {
            let request = try AuthEndpoint.request(with: username, and: password)
            let token = try await authenticator.requestToken(from: request)
            if let data = token.data(using: .utf8) {
                try tokenStore.delete()
                try tokenStore.insert(data)
            }
            onLoginSucceed()
        } catch {
            print(error)
        }
    }
}
