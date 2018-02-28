//
//  Repository.swift
//  RxExample-1
//
//  Created by Giang Le Ngoc on 2/27/18.
//  Copyright © 2018 Giang Le Ngoc. All rights reserved.
//

import Foundation


struct Repository {
    let fullName: String
    let desciption: String
    let startsCount: Int
    let url: String
}

extension Repository {
    init?(from json: [String: Any]) {
        guard
            let fullName = json["full_name"] as? String,
            let description = json["description"] as? String,
            let startsCount = json["stargazers_count"] as? Int,
            let url = json["html_url"] as? String
            else { return nil }
        self.init(fullName: fullName, desciption: description, startsCount: startsCount, url: url)
    }
}

extension Repository: Equatable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.fullName == rhs.fullName && lhs.desciption == rhs.desciption && lhs.startsCount == rhs.startsCount && lhs.url == rhs.url
    }
}
