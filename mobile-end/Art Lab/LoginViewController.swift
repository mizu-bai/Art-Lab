//
//  LoginViewController.swift
//  Art Lab
//
//  Created by mizu bai on 2021/7/29.
//

import UIKit
import AFNetworking
import SVProgressHUD
import SAMKeychain

typealias loginSuccessBlock = (_ loginResponse: LoginResponse) -> ()

class LoginViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    // MARK: - Callback Block
    var loginSuccessBlock: loginSuccessBlock? = nil

    // MARK: - Controls
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberSwitch: UISwitch!
    @IBOutlet weak var textFieldBackgroundView: UIView!
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "back_item"), style: .plain, target: navigationController, action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = self
                
        // Set Tap Action
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditingWithTap))
        view.addGestureRecognizer(tap)
        // Set Text Fields
        textFieldBackgroundView.layer.cornerRadius = 30
        textFieldBackgroundView.layer.masksToBounds = true
        accountTextField.addTarget(self, action: #selector(enableLoginButton), for: .editingChanged)
        accountTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(enableLoginButton), for: .editingChanged)
        passwordTextField.delegate = self
        // Remember and Auto Login
        let userDefault = UserDefaults.standard
//        if let rememberMe = userDefault.value(forKey: "rememberMe") as? Bool {
//            rememberSwitch.isOn = rememberMe
//        }
//        if let autoLogin = userDefault.value(forKey: "autoLogin") as? Bool {
//            autoLoginSwitch.isOn = autoLogin
//        }
        rememberSwitch.isOn = false
//        autoLoginSwitch.isOn = false

        if rememberSwitch.isOn {
            if let account = userDefault.string(forKey: "account") {
                accountTextField.text = account
                if let password = SAMKeychain.password(forService: kServiceName, account: account) {
                    passwordTextField.text = password
                }
            }
        }
        enableLoginButton()
//        if autoLoginSwitch.isOn {
//            loginButtonDidClick(nil)
//        }
    }

    @objc func endEditingWithTap() {
        view.endEditing(true)
    }

    @objc func enableLoginButton() {
        if accountTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }

    // MARK: - Actions
    @IBAction func loginButtonDidClick(_ sender: Any?) {
        view.endEditing(true)
        // Get Account and Password
        let account = accountTextField.text!
        let password = passwordTextField.text!

        // HMAC
        let hmacPassword = NSString(string: password).hmacMD5String(withKey: kLoginMD5Key) as String
        // print("Account: \(account)\nHMAC Password: \(hmacPassword)")
        let params = [
            "account": account,
            "password": hmacPassword,
        ]

        // POST
        /**
         * POST Request
         * {
         *     account: User Account (string),
         *     password: HMAC Password (string)
         * }
         */
        let urlString = "http://localhost:3000/login"
        let request = try! AFJSONRequestSerializer().request(withMethod: "POST", urlString: urlString, parameters: params) as URLRequest
        // print(String(data: request.httpBody!, encoding: .utf8)!)
        let dataTask = URLSession.shared.dataTask(with: request) { [self] (data: Data?, response: URLResponse?, error: Error?) -> () in
            if let error = error {
                // print("Error: \(error)")
                DispatchQueue.main.async {
                    SVProgressHUD.showInfo(withStatus: "Network Error! Try later!")
                    SVProgressHUD.dismiss(withDelay: 1.0)
                }
                return
            }
            let httpUrlResponse = response as! HTTPURLResponse
            if httpUrlResponse.statusCode == 200 || httpUrlResponse.statusCode == 304 {
                /**
                 * Response JSON
                 * 1. success
                 *     {
                 *         status: 1 (int),
                 *         identifier: User Identifier (string),
                 *         nick_name: User Nick Name (string),
                 *         icon_base64: User Icon Base64 (string)
                 *     }
                 * 2. failed
                 *     {
                 *         status: 0 (int),
                 *         identifier: null,
                 *         nickName: null,
                 *         iconBase64: null
                 *     }
                 */
                let loginResponseDict = try! JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any?>
                // Login Failed
                if loginResponseDict["status"] as! Int == 0 {
                    // print("登录失败！账户或密码错误！")
                    DispatchQueue.main.async {
                        SVProgressHUD.showInfo(withStatus: "Login Failed!\nPlease check your account or password.")
                        SVProgressHUD.dismiss(withDelay: 1.0)
                    }
                    return
                }
                // Login Success
                // print(loginResponseDict)
                let loginResponse = LoginResponse.init(dictionary: loginResponseDict as [AnyHashable: Any])!;

                // Set UserDefaults
                let userDefaults = UserDefaults.standard
                // account and password
                userDefaults.set(account, forKey: "account")
                SAMKeychain.setPassword(password, forService: kServiceName, account: account)
                // login config
                DispatchQueue.main.async {
                    userDefaults.set(rememberSwitch.isOn, forKey: "rememberMe")
//                    userDefaults.set(autoLoginSwitch.isOn, forKey: "autoLogin")
                }
                // user info
                userDefaults.set(loginResponse.identifier, forKey: "identifier")
                userDefaults.set(loginResponse.nickName, forKey: "nickName")
                userDefaults.set(loginResponse.iconBase64, forKey: "iconBase64")

                // Login Success Callback
                DispatchQueue.main.async {
                    navigationController?.popToRootViewController(animated: true)
                    if let loginSuccessBlock = loginSuccessBlock {
                        // update UI when back to PersonalTableView
                        loginSuccessBlock(loginResponse)
                    }
                }
            } else {
                // print("Server Internal Error: \(httpUrlResponse.statusCode)")
                DispatchQueue.main.async {
                    SVProgressHUD.showInfo(withStatus: "Server Internal Error: \(httpUrlResponse.statusCode)")
                    SVProgressHUD.dismiss(withDelay: 1.0)
                }
            }
        }
        dataTask.resume()
    }

    // MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
