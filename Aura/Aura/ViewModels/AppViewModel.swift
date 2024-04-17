//
//  AppViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

final class AppViewModel: ObservableObject {

    @Published var isLogged: Bool

    init() {
        isLogged = false
    }

    var authenticationViewModel: AuthenticationViewModel {
        return AuthenticationViewModel { [weak self] in
            DispatchQueue.main.async {
                self?.isLogged = true
            }
        }
    }

    var accountDetailViewModel: AccountDetailViewModel {
        return AccountDetailViewModel()
    }
}
