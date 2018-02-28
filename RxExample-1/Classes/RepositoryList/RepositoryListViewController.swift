//
//  RepositoryListViewController.swift
//  RxExample-1
//
//  Created by Giang Le Ngoc on 2/27/18.
//  Copyright © 2018 Giang Le Ngoc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SafariServices

class RepositoryListViewController: UIViewController {
    private enum SegueType: String {
        case languageList = "Show language list"
    }
    
    @IBOutlet weak var tableView: UITableView!
    private let chooseLanguageButton = UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil)
    private let refreshControl  = UIRefreshControl()
    
    private let viewModel = RepositoryListViewModel(initLanguage: "Swift")
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        
        refreshControl.sendActions(for: .valueChanged)
    }
    
    func setupUI() {
        navigationItem.rightBarButtonItem = chooseLanguageButton
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func setupBindings() {
        viewModel.repositories
            .observeOn(MainScheduler.instance)
            .do(onNext: {[weak self] _ in self?.refreshControl.endRefreshing()})
            .bind(to: tableView.rx.items(cellIdentifier: "RepositoryCell", cellType: RepositoryCell.self)) {[weak self] (_, repo, cell) in
                self?.setupRepositoryCell(cell, repository: repo)
            }
            .disposed(by: disposeBag)
        
        viewModel.title
        .bind(to: navigationItem.rx.title)
        .disposed(by: disposeBag)
        
        viewModel.showRepository
            .subscribe(onNext: { [weak self] in self?.openRepository(by: $0) })
            .disposed(by: disposeBag)
        
        viewModel.showLanguageList
            .subscribe(onNext: { [weak self] in self?.openLanguageList()})
            .disposed(by: disposeBag)
        
        viewModel.alertMessage
            .subscribe(onNext: {[weak self] in self?.presentAlert(by: $0)})
        .disposed(by: disposeBag)
        
        // View controller UI actions to the View model
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)
        
        chooseLanguageButton.rx.tap
            .bind(to: viewModel.chooseLanguage)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(RepositoryViewModel.self)
            .bind(to: viewModel.selectRepository)
            .disposed(by: disposeBag)
        
    }
    
    private func setupRepositoryCell(_ cell: RepositoryCell, repository: RepositoryViewModel) {
        cell.selectionStyle = .none
        cell.setName(repository.name)
        cell.setDescription(repository.description)
        cell.setStarsCount(repository.starsCountText)
    }
    
    private func openRepository(by url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.navigationItem.title = url.absoluteString
        navigationController?.pushViewController(safariViewController, animated: true)
    }
    
    private func openLanguageList() {
        performSegue(withIdentifier: SegueType.languageList.rawValue, sender: self)
    }
    
    private func presentAlert(by message: String) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationVC : UIViewController? = segue.destination
        
        if let nvc = destinationVC as? UINavigationController {
            destinationVC = nvc.viewControllers.first
        }
        
        if let viewController = destinationVC as? LanguageListViewController, segue.identifier == SegueType.languageList.rawValue {
            prepareLanguageListViewController(viewController)
        }
    }
    
    /// Setup `LanguageListViewController` before navigation.
    ///
    /// - Parameter viewController: `LanguageListViewController` to prepare
    private func prepareLanguageListViewController(_ viewController: LanguageListViewController) {
        let languageListViewModel = LanguageListViewModel()
        
        let dismiss = Observable.merge([
            languageListViewModel.didCancel,
            languageListViewModel.didSelectLanguage.map { _ in }
            ])
        
        dismiss
            .subscribe(onNext: { [weak self] in self?.dismiss(animated: true, completion: nil) })
            .disposed(by: disposeBag)
        
        languageListViewModel.didSelectLanguage
            .bind(to: viewModel.setCurrenLanguage)
            .disposed(by: disposeBag)
        
        viewController.viewModel = languageListViewModel
        
    }
    
}

