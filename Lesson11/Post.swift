//
//  Post.swift
//  Lesson11
//
//  Created by ilyas.ikhsanov on 16.11.2021.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
