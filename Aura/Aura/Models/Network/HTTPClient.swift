//
//  HTTPClient.swift
//  Aura
//
//  Created by Sebastien Bastide on 17/04/2024.
//

import Foundation

protocol HTTPClient {
    func request(from request: URLRequest) async throws -> (Data, HTTPURLResponse)
}
