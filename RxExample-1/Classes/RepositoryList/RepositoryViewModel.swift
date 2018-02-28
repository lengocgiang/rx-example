//
//  RepositoryViewModel.swift
//  RxExample-1
//
//  Created by Giang Le Ngoc on 2/27/18.
//  Copyright © 2018 Giang Le Ngoc. All rights reserved.
//

import Foundation


class RepositoryViewModel {
    let name: String
    let description: String
    let starsCountText: String
    let url: URL
    
    init(repository: Repository) {
        self.name = repository.fullName
        self.description = repository.desciption
        self.starsCountText = "⭐️ \(repository.startsCount)"
        self.url = URL(string: repository.url)!
    }
}
