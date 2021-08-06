//
//  LabViewController.swift
//  Art Lab
//
//  Created by mizu bai on 2021/6/16.
//

import UIKit
import WebKit

class LabViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    // MARK: - Controls
    @IBOutlet weak var artistWebView: WKWebView!


    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // WebView Delegate
        artistWebView.uiDelegate = self
        artistWebView.navigationDelegate = self
        // Request
        requestWebPage(url: url!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         super.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         super.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: Request

    let url = URL(string: "http://artsandculture.google.com/category/artist")

    func requestWebPage(url: URL) {
        // request
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20.0)
        artistWebView.load(request)
    }
}
