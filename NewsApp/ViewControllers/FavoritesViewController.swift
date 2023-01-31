//
//  FavoritesViewController.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 17/1/2023.
//

import UIKit
import  RxSwift

class FavoritesViewController: UIViewController,BaseViewProtocol, UITableViewDataSource ,UITableViewDelegate {
    
    var tableView: UITableView!

    private var viewModel: FavoritesViewModel = FavoritesViewModel()
    private let disposeBag = DisposeBag()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        setupViewModel()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
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
        //cell =  UIAccessibilityNavigationStyle
        return cell
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewDidLoad()
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
        viewController.isBookMarked  = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let data = viewModel.infoForRowAt(indexPath.row)
        PersistanceManager.updateWith(news: data, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error  else {
                
                self.viewModel.removeNewsForRowAt(indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
            
            print(error.localizedDescription)
        }
    }

    
}
