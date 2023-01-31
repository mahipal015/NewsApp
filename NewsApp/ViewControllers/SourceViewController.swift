//
//  SourceViewController.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 17/1/2023.
//

import UIKit
import RxSwift

class SourceViewController: UITableViewController, BaseViewProtocol {
    
    private let selectedSourceSubject = PublishSubject<SourcesDTO>()
    
    var selectedCells : [Int] = []
    
    var selectedSource: Observable<SourcesDTO> { selectedSourceSubject.asObserver() }

    private var viewModel: SourcesDataSource = SourcesViewModel()
    private let disposeBag = DisposeBag()
    
    convenience init(withDataSource dataSource: SourcesDataSource) {
        self.init()
        self.viewModel = dataSource
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureTableView() {
        tableView?.backgroundColor = UIColor.white
        view.backgroundColor = UIColor.white
        tableView.register(SourceTableViewCell.self, forCellReuseIdentifier: SourceTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView(frame: CGRect.zero)
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
                self?.showAlertView(withTitle: error.localizedDescription, andMessage: error.localizedDescription)
            }).disposed(by: disposeBag)

        viewModel.isLoading.bind(to: isAnimating).disposed(by: disposeBag)

        viewModel.viewDidLoad()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SourceTableViewCell.reuseIdentifier
                                                 , for: indexPath) as! SourceTableViewCell
        let data = viewModel.infoForRowAt(indexPath.row)
        cell.configure(data)
        cell.accessoryType = self.selectedCells.contains(indexPath.row) ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        
        let index = self.selectedCells.firstIndex(of: indexPath.row)
        let data = viewModel.infoForRowAt(indexPath.row)
        
        if self.selectedCells.contains(indexPath.row) {
            self.selectedCells.remove(at: index!)
            PersistanceManager.updateWith(sources: data, actionType: .remove) { error in
                guard let  error = error else {
                    print("Sources remove success")
                    return
                }
                print(error.rawValue)
            }
            
        } else {
            self.selectedCells.append(indexPath.row)
                PersistanceManager.updateWith(sources: data , actionType: .add) { error in
                    guard let  error = error else {
                        print("Sources added success")
                        return
                    }
                    print(error.rawValue)
                }
        }
        tableView.reloadData()
    }

}
    
