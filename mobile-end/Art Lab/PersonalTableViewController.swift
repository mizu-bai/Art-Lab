//
//  PersonalTableViewController.swift
//  Art Lab
//
//  Created by mizu bai on 2021/7/29.
//

import UIKit

class PersonalTableViewController: UITableViewController {
    
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userNickNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let loginViewController = segue.destination as! LoginViewController
        loginViewController.loginSuccessBlock = { [self] loginResponse in
            userIconImageView.image = UIImage.init(base64Encoding: loginResponse.iconBase64)
            userNickNameLabel.text = loginResponse.nickName
            print("User Identifier: \(loginResponse.identifier ?? "null")")
        }
    }
}
