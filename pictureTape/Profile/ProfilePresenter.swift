//
//  ProfilePresenter.swift
//  pictureTape
//
//  Created by Владимир Клевцов on 17.10.23..
//

import Foundation
import WebKit

public protocol ProfilePresenterProtocol: AnyObject {
    func showAlertWithYesNoAction()
}
final class ProfilePresenter: ProfilePresenterProtocol {
    private let tokenStorage = OAuth2TokenStorage()
    private let splashViewController = SplashViewController()
    weak var viewController: ProfileViewController?
    
    var window = UIApplication.shared.windows.first
    
    init(viewController: ProfileViewController) {
        self.viewController = viewController
    }
    
    func showAlertWithYesNoAction() {
        let alertController = UIAlertController(title: byebyeString, message: areuString, preferredStyle: .alert)
        
        
        let yesAction = UIAlertAction(title: yesString, style: .default) { (_) in
            self.clean()
            self.tokenStorage.removeTokenFromKeychain()
            alertController.dismiss(animated: true, completion: nil)
            self.window?.rootViewController = self.splashViewController
            self.window?.makeKeyAndVisible()
            print("User tapped 'Yes'")
        }
        let noAction = UIAlertAction(title: noString, style: .cancel) { (_) in
            alertController.dismiss(animated: true, completion: nil)
            print("User tapped 'No'")
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        self.viewController?.present(alertController, animated: true, completion: nil)
    }
    func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
