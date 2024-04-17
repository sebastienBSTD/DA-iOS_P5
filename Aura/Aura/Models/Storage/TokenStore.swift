//
//  TokenStore.swift
//  Aura
//
//  Created by Sebastien Bastide on 17/04/2024.
//

import Foundation

protocol TokenStore {
    func insert(_ data: Data) throws
    func retrieve() throws -> Data
    func delete() throws
}
