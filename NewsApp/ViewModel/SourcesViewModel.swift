//
//  SourcesViewModel.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 23/1/2023.
//

import Foundation
import RxSwift

protocol SourcesDataSource: BaseViewModelDataSource {
    var title: String { get }
    var numberOfRowsInSection: Int { get }
    func infoForRowAt(_ index: Int) -> SourcesDTO
}

final class SourcesViewModel: SourcesDataSource {
    var title: String { "Sources" }
    
    private var sourcesCheckList = [SourcesDTO]()
        
    var numberOfRowsInSection: Int { sourcesList.count }
    
    let updateInfo: Observable<Bool>
    let errorResult: Observable<Error>
    let isLoading: Observable<Bool>
    
    private let disposeBag = DisposeBag()
    private var sourcesList = [SourcesDTO]()
    private let sourceNetworkHandler: NewsSourceNetworkHandling
    
    private let updateInfoSubject = PublishSubject<Bool>()
    private let errorResultSubject = PublishSubject<Error>()
    private let loadingSubject = BehaviorSubject<Bool>(value: true)
    
    init(withNetworkHandling networkHandler: NewsSourceNetworkHandling = NewsNetworkHandler()) {
        self.sourceNetworkHandler = networkHandler
        
        self.updateInfo = updateInfoSubject.asObservable()
        self.errorResult = errorResultSubject.asObservable()
        self.isLoading = loadingSubject.asObservable()
    }
    
    func viewDidLoad() {
        removeAllSavedSources()
        sourceNetworkHandler
            .getSources()
            .compactMap({ list -> [SourcesDTO] in
                list.map { SourcesDTO($0) }
            })
            .subscribe(onNext: { [weak self] result in
                self?.sourcesList = result
                self?.updateInfoSubject.onNext(true)
                self?.loadingSubject.onNext(false)
            }, onError: { [weak self] error in
                
                self?.errorResultSubject.on(.next(error))
                self?.loadingSubject.onNext(false)
                
            })
            .disposed(by: disposeBag)
    }
    
    func removeAllSavedSources() {
        PersistanceManager.removeAllSources { results in
            print(results!.rawValue)
        }
    }
    
    func infoForRowAt(_ index: Int) -> SourcesDTO { sourcesList[index] }
    
}

