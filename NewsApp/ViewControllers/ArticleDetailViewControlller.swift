//
//  ArticleDetailViewControlller.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 30/1/2023.
//

import UIKit
import SafariServices


class ArticleDetailViewControlller: SFSafariViewController {
    
    var selectedArticle : ArticleDTO!
    var isBookMarked : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    func configureViewController() {
        navigationItem.largeTitleDisplayMode = .never
        
        //saveToFavoritesButton
        if !isBookMarked {
            let saveButton  = UIBarButtonItem(barButtonSystemItem: .save, target: self, action:#selector(saveButtonTapped))
            navigationItem.rightBarButtonItem = saveButton
        }
    }
  
    
    @objc func saveButtonTapped() {

        let favorite = ArticleDTO(title: self.selectedArticle.title,  description: self.selectedArticle.description,author: self.selectedArticle.author, url: self.selectedArticle.url, urlToImage: self.selectedArticle.urlToImage)
        
                PersistanceManager.updateWith(news: favorite , actionType: .add) { error in
                    guard let  error = error else {
                        print("sucess")
                        return
                    }
                    print(error.rawValue)
                }
    }
    
}
