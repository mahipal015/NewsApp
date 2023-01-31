//
//  UIViewcontroller+Extension.swift
//  NewsApp
//
//  Created by Mahipal Kummari on 25/1/2023.
//

import SafariServices
import UIKit

extension UIViewController {
    func showAlertView(withTitle title: String?, andMessage message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) -> Void in
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    func presentSafariViewController(for url: URL) {
        let safariController = SFSafariViewController(url: url)
        if #available(iOS 10, *) {
            if #available(iOS 15.0, *) {
                safariController.preferredControlTintColor = .tintColor
            } else {
                // Fallback on earlier versions
            }
        } else {
            safariController.view.tintColor = .tintColor
        }
        safariController.preferredBarTintColor = .white
        safariController.modalPresentationStyle = .overFullScreen

        present(safariController, animated: true, completion: nil)
    }
}
