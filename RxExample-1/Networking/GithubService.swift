//
//  GithubService.swift
//  RxExample-1
//
//  Created by Giang Le Ngoc on 2/27/18.
//  Copyright © 2018 Giang Le Ngoc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ServiceError: Error {
    case cannotParse
}


class GithubService {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    /// - Returns: a list of language from Github
    func getLanguageList() -> Observable<[String]> {
        return Observable.just([
            "Swift",
            "Objective-C",
            "Java",
            "C",
            "C++",
            "Python",
            "C#",
            "Go",
            "Nodejs"
            ])
    }
    
    /// - Parameters: language: Language to filter by
    /// - Parameters: A list of most popular repositories filtered by language
    func getMostPopularRepositories(byLanguage language: String) -> Observable<[Repository]> {
        let encodedLanguage = language.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: "https://api.github.com/search/repositories?q=language:\(encodedLanguage)&sort=stars")!
        
        return session.rx.json(url: url).flatMap({json throws -> Observable<[Repository]> in
            guard
            let json = json as? [String: Any],
            let itemsJSON = json["items"] as? [[String: Any]]
            else { return Observable.error(ServiceError.cannotParse)}
            
            let repositories = itemsJSON.flatMap(Repository.init)
            return Observable.just(repositories)
        })
    }
    
    
    
}
