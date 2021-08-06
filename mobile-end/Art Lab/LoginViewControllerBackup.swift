//
//  LoginViewController.swift
//  Art Lab
//
//  Created by 李俊宏 on 2021/6/13.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: - View Did Load
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        // loginAndRegisterSwitchSegDidChange()

    }
    
    // MARK: - Controls
    @IBOutlet weak var loginAndRegisterSwitchSeg: UISegmentedControl!
    @IBOutlet weak var loginAndRegisterView: UIView!
    
    // MARK: - Lazy Load
    lazy var loginView: UIView = {() -> UIView in
        Bundle.main.loadNibNamed("LoginView", owner: nil, options: nil)?.first as! UIView
    }()
    
    lazy var registerView: UIView = {() -> UIView in
        Bundle.main.loadNibNamed("RegisterView", owner: nil, options: nil)?.first as! UIView
    }()
    
    // MARK: - Actions
    @IBAction func loginAndRegisterSwitchSegDidChange(_ sender: Any) {
        _ = loginAndRegisterView.subviews.map({
            $0.removeFromSuperview()
        })
        loginAndRegisterView.addSubview(
            loginAndRegisterSwitchSeg.selectedSegmentIndex == 0 ? loginView : registerView
        )
    }
    
}
