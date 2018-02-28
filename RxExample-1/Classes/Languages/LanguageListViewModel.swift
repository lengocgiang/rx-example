//
//  LanguageListViewModel.swift
//  RxExample-1
//
//  Created by Giang Le Ngoc on 2/27/18.
//  Copyright © 2018 Giang Le Ngoc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LanguageListViewModel {
    
    // MARK: - Inputs
    
    let selectLanguage: AnyObserver<String>
    let cancel: AnyObserver<Void>
    
    // MARK: - Outputs
    
    let languages: Observable<[String]>
    let didSelectLanguage: Observable<String>
    let didCancel: Observable<Void>
    
    init(githubService: GithubService = GithubService()) {
        self.languages = githubService.getLanguageList()
        
        let _selectLanguage = PublishSubject<String>()
        self.selectLanguage = _selectLanguage.asObserver()
        self.didSelectLanguage = _selectLanguage.asObservable()
        
        let _cancel = PublishSubject<Void>()
        self.cancel = _cancel.asObserver()
        self.didCancel = _cancel.asObservable()
        
        
    }
}
