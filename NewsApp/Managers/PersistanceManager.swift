//
//  PersistanceManager.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 30/1/2023.
//

import Foundation

enum APIError: String, Error {
    case noDataReturned = "Unable to access data from Server"
    case invalidURL = "Invalid URL from the server. Please check URL"
    case unableToSave = "There was an error saving this user. Please try again"
    case alreadySaved = "This has been saved already! You can only save ones"
    case removedAll = "This has been remove all saved! You can save it again"
}


enum PersistenceActionType {
    case add, remove
}

enum PersistanceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let savedNews = "savedNews"
        static let savedSources = "savedSources"
    }
    
    static func updateWith(news: ArticleDTO, actionType: PersistenceActionType, completion: @escaping (APIError?) -> Void) {
        
        retrieveFavorites { result in
            switch result {
                // get News
            case .success(var newsSaved):
                
                switch actionType {
                case .add:
                    guard !newsSaved.contains(news) else {
                        completion(.alreadySaved)
                        return
                    }
                    
                    newsSaved.append(news)
                    
                case .remove:
                    newsSaved.removeAll(where: {$0.title == news.title})
                }
                // save it now.
                completion(save(news: newsSaved))
            case .failure(let error):
                completion(error)
            }
        }
    }
    
 //MARK: - Local Persistance
    static func retrieveFavorites(completed: @escaping (Result<[ArticleDTO], APIError>) -> Void) {
        guard let savedData = defaults.object(forKey: Keys.savedNews) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let savedNews = try decoder.decode([ArticleDTO].self, from: savedData)
            completed(.success(savedNews))
        } catch {
            completed(.failure(.unableToSave))
        }
    }
    
    static func save(news: [ArticleDTO]) -> APIError? {
        do {
           let encoder = JSONEncoder()
            let encodedSavedNews = try encoder.encode(news)
            defaults.set(encodedSavedNews, forKey: Keys.savedNews)
            return nil
        } catch {
            return .unableToSave
        }
    }
    
    
    ////  News Sources
    ///
    static func updateWith(sources: SourcesDTO, actionType: PersistenceActionType, completion: @escaping (APIError?) -> Void) {
        
        retrieveSources { result in
            switch result {
                // get Sources
            case .success(var sourcesSaved):
                
                switch actionType {
                case .add:
                    guard !sourcesSaved.contains(sources) else {
                        completion(.alreadySaved)
                        return
                    }
                    
                    sourcesSaved.append(sources)
                    
                case .remove:
                    sourcesSaved.removeAll(where: {$0.name == sources.name})
                }
                // save it now.
                completion(saveSources(sources: sourcesSaved))
            case .failure(let error):
                completion(error)
            }
        }
    }
    
 //MARK: - Local Persistance
    static func retrieveSources(completed: @escaping (Result<[SourcesDTO], APIError>) -> Void) {
        guard let savedData = defaults.object(forKey: Keys.savedSources) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let savedSources = try decoder.decode([SourcesDTO].self, from: savedData)
            completed(.success(savedSources))
        } catch {
            completed(.failure(.unableToSave))
        }
    }
    
    static func saveSources(sources: [SourcesDTO]) -> APIError? {
        do {
            let encoder = JSONEncoder()
            let encodedSavedNews = try encoder.encode(sources)
            defaults.set(encodedSavedNews, forKey: Keys.savedSources)
            return nil
        } catch {
            return .unableToSave
        }
    }
    
    static func removeAllSources(completion: @escaping (APIError?)-> Void)  {
        retrieveSources { result in
            switch result {
            case .success(var sourcesSaved):
                sourcesSaved.removeAll()
                defaults.set(nil, forKey: Keys.savedSources)
                completion(.removedAll)
            case .failure(let error):
                completion(error)
            }
        }
        
    }
}

