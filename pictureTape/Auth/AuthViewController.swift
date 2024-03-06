//
//  AuthViewController.swift
//  pictureTape
//
//  Created by Владимир Клевцов on 5.8.23..
//

import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    
    private let segIdentificator = "ShowWebView"
    private let tokenStorage = OAuth2TokenStorage()
    private var oAuth2Service = OAuth2Service.shared
    weak var delegate: SplashViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segIdentificator {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else { assertionFailure("fail")
                return
            }
            let authHelper = AuthHelper()
                    let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewViewController
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewControllter(_vc: WebViewViewController, didAuthernticateWithCode code: String) {
        UIBlock.show()
        oAuth2Service.fetchOAuthToken(code, completion: { result in
            switch result {
            case .success(let result):
                print("new token \(result)")
                UIBlock.dissmiss()
                if let token = self.tokenStorage.token {
                    print("Token: \(token)")
                    self.delegate?.fetchAfterAuth()
                } else {
                    print("Token not found.")
                }
            case .failure(let error):
                UIBlock.dissmiss()
                print("error \(error)")
                return
            }
        })
    }
    func webViewViewControllerDidCancel(_vc: WebViewViewController) {
        dismiss(animated: true, completion: nil)
    }
}
