//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 17/1/2023.
//

import RxCocoa
import RxSwift
import UIKit

final class HomeViewController: UIViewController, BaseViewProtocol, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView!
    
    private var viewModel: NewsListViewModelDataSource = NewsListViewModel()
    private let disposeBag = DisposeBag()
    
    var news: [ArticleModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        setupViewModel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewDidLoad()
    }
    private func configureTableView() {
        tableView = UITableView(frame: view.bounds)
        
        view.addSubview(tableView)
        
        tableView?.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.reuseIdentifier)
    }
    
    private func setupViewModel() {
        viewModel.updateInfo
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.errorResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showAlertView(withTitle: "error", andMessage: error.localizedDescription)
            }).disposed(by: disposeBag)
        
        viewModel.isLoading.bind(to: isAnimating).disposed(by: disposeBag)
        
        viewModel.viewDidLoad()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.reuseIdentifier, for: indexPath) as! ArticleTableViewCell
        let data = viewModel.infoForRowAt(indexPath.row)
        cell.configure(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handellNavigation(indexPath)
    }
    
    // MARK: - Navigation
    
    private func handellNavigation(_ indexPath: IndexPath) {
        let selectedArticle = viewModel.infoForRowAt(indexPath.row)
        guard let articleUrl = URL(string: selectedArticle.url ) else { return }
        let viewController = ArticleDetailViewControlller(url:articleUrl)
        viewController.selectedArticle = selectedArticle
        viewController.isBookMarked = false
        navigationController?.pushViewController(viewController, animated: true)
    }
}
