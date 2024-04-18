//
//  AuthMapper.swift
//  Aura
//
//  Created by Sebastien Bastide on 17/04/2024.
//

import Foundation

enum AuthMapper {

    private struct Root: Decodable {
        let token: String
    }

    enum Error: Swift.Error {
        case invalidResponse
    }

    static func map(_ data: Data, and response: HTTPURLResponse) throws -> String {
        guard response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidResponse
        }

        return root.token
    }
}
