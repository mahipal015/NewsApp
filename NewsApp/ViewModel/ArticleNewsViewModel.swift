//
//  ArticleNewsViewModel.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 19/1/2023.
//

import Foundation
import RxCocoa
import RxSwift

protocol NewsListViewModelDataSource: BaseViewModelDataSource {
    var title: Observable<String> { get }
    var numberOfRowsInSection: Int { get }

    func infoForRowAt(_ index: Int) -> ArticleDTO
}

final class NewsListViewModel: NewsListViewModelDataSource {
    var title: Observable<String> { titleSubject.asObservable() }
    var numberOfRowsInSection: Int { newsList.count }

    let updateInfo: Observable<Bool>
    let errorResult: Observable<Error>
    let isLoading: Observable<Bool>

    private let disposeBag = DisposeBag()
    private var newsList = [ArticleDTO]()
    private let newsNetworkHandler: NewsListNetworkHandling

    private let newsListSubject = PublishSubject<[ArticleModel]>()
    private let titleSubject = BehaviorSubject<String>(value: "News")

    private let updateInfoSubject = PublishSubject<Bool>()
    private let errorResultSubject = PublishSubject<Error>()
    private let loadingSubject = BehaviorSubject<Bool>(value: true)
    
    private let defaultParam: [String: String] = [ ApiKey.sources: Environment.Variables.sources, ApiKey.language: Environment.Variables.language ]

    init(withNetworkHandling networkHandling: NewsListNetworkHandling = NewsNetworkHandler()) {
        self.newsNetworkHandler = networkHandling

        self.updateInfo = updateInfoSubject.asObservable()
        self.errorResult = errorResultSubject.asObservable()
        self.isLoading = loadingSubject.asObservable()
    }

    func viewDidLoad() {
        getTopHeadlines()
    }

    func infoForRowAt(_ index: Int) -> ArticleDTO { self.newsList[index] }

    func getTopHeadlines() {
        
        PersistanceManager.retrieveSources{ [weak self] result  in
           guard let self = self else { return }
            switch result {
            case .success(let sources):
                if !sources.isEmpty {
                    let param: [String: String] = [ApiKey.sources: "\(sources.map{"\($0.id)"}.joined(separator: ","))",ApiKey.language: Environment.Variables.language]
                    self.getTopHeadlines(param)
                }else {
                    self.getTopHeadlines(self.defaultParam)
                }
            case .failure(let error):
                self.getTopHeadlines(self.defaultParam)
                print(error.rawValue)
            }
        }
    }
    
      func  getTopHeadlines(_ param: [String: String]? = nil) {
        newsNetworkHandler
            .getTopHeadlines(param)
            .compactMap({ list -> [ArticleDTO] in
                list.map { ArticleDTO($0) }
            })
            .subscribe(onNext: { [weak self] result in
                self?.newsList = result
                self?.updateInfoSubject.onNext(true)
                self?.loadingSubject.onNext(false)
                }, onError: { [weak self] error in

                    self?.errorResultSubject.on(.next(error))
                    self?.loadingSubject.onNext(false)

            })
            .disposed(by: disposeBag)
        
    }
}
