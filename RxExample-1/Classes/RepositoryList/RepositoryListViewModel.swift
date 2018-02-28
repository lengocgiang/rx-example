//
//  RepositoryListViewModel.swift
//  RxExample-1
//
//  Created by Giang Le Ngoc on 2/27/18.
//  Copyright © 2018 Giang Le Ngoc. All rights reserved.
//

import Foundation
import RxSwift

class RepositoryListViewModel {
    // MARK: - Inputs
    
    let setCurrenLanguage: AnyObserver<String>
    
    let chooseLanguage: AnyObserver<Void>
    
    let selectRepository: AnyObserver<RepositoryViewModel>
    
    let reload: AnyObserver<Void>
    
    // MARK: - Outputs
    
    /// Emits an array of fetched repositories
    let repositories: Observable<[RepositoryViewModel]>
    
    let title: Observable<String>
    
    let alertMessage: Observable<String>
    
    let showRepository: Observable<URL>
    
    let showLanguageList: Observable<Void>
    
    init(initLanguage: String, githubService: GithubService = GithubService()) {
        let _reload = PublishSubject<Void>()
        self.reload = _reload.asObserver()
        
        let _currentLanguage = BehaviorSubject<String>(value: initLanguage)
        self.setCurrenLanguage = _currentLanguage.asObserver()
        
        self.title = _currentLanguage.asObservable()
        .map({"\($0)"})
        
        let _alertMessage = PublishSubject<String>()
        self.alertMessage = _alertMessage.asObservable()
        
        self.repositories = Observable.combineLatest(_reload, _currentLanguage) {_, language in language }
            .flatMapLatest { language in
                githubService.getMostPopularRepositories(byLanguage: language)
                    .catchError{ error in
                        _alertMessage.onNext(error.localizedDescription)
                        return Observable.empty()
                }
            }
            .map{ repositories in repositories.map(RepositoryViewModel.init)}
        
        let _selectRepository = PublishSubject<RepositoryViewModel>()
        self.selectRepository = _selectRepository.asObserver()
        self.showRepository = _selectRepository.asObservable()
            .map{$0.url}
        
        let _chooseLanguage = PublishSubject<Void>()
        self.chooseLanguage = _chooseLanguage.asObserver()
        self.showLanguageList = _chooseLanguage.asObservable()
    }
    
    
}
