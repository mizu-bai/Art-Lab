//
//  PersonalViewController.swift
//  Art Lab
//
//  Created by mizu bai on 2021/8/2.
//

import UIKit

class PersonalViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userNickNameButton: UIButton!

    @IBOutlet weak var collectionViewBackgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        userIconImageView.layer.cornerRadius = userIconImageView.bounds.height * 0.5
        userIconImageView.clipsToBounds = true
        
        collectionViewBackgroundView.layer.cornerRadius = 25;
        collectionViewBackgroundView.layer.masksToBounds = true
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let loginViewController = segue.destination as! LoginViewController
        loginViewController.loginSuccessBlock = { [self] loginResponse in
            DispatchQueue.main.async {
                userIconImageView.image = UIImage.init(base64Encoding: loginResponse.iconBase64)
                userNickNameButton.setTitle(loginResponse.nickName, for: .normal)
                print("User Identifier: \(loginResponse.identifier ?? "null")")
            }
        }
    }
}
