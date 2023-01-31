//
//  FavoritesViewModel.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 30/1/2023.
//

import Foundation

import RxSwift

protocol FavoritesDataSource: BaseViewModelDataSource {
    var title: String { get }
    var numberOfRowsInSection: Int { get }
    func infoForRowAt(_ index: Int) -> ArticleDTO
}

final class FavoritesViewModel: FavoritesDataSource {
    
    var title: String { "Favorites" }
    
    var numberOfRowsInSection: Int { sourcesList.count }
    
    let updateInfo: Observable<Bool>
    let errorResult: Observable<Error>
    let isLoading: Observable<Bool>
    
    private let disposeBag = DisposeBag()
    private var sourcesList = [ArticleDTO]()
    
    
    private let updateInfoSubject = PublishSubject<Bool>()
    private let errorResultSubject = PublishSubject<Error>()
    private let loadingSubject = BehaviorSubject<Bool>(value: true)
    
    init() {
        self.updateInfo = updateInfoSubject.asObservable()
        self.errorResult = errorResultSubject.asObservable()
        self.isLoading = loadingSubject.asObservable()
    }
    
    func viewDidLoad() {
        
        PersistanceManager.retrieveFavorites{ [weak self] result  in
           guard let self = self else { return }
            switch result {
            case .success(let news):
                    self.sourcesList = news.isEmpty ? [] : news
                    self.updateInfoSubject.onNext(true)
                    self.loadingSubject.onNext(false)

            case .failure(let error):
                self.errorResultSubject.on(.next(error))
                self.loadingSubject.onNext(false)
            }
        }
    }
    
    func infoForRowAt(_ index: Int) -> ArticleDTO {
        sourcesList[index]
    }
    
    func removeNewsForRowAt(_ index: Int) {
        sourcesList.remove(at: index)
    }
    
}
