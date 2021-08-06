//
//  ImageStyleTransferViewController.swift
//  Art Lab
//
//  Created by mizu bai on 2021/6/16.
//

import UIKit
import SVProgressHUD
import AFNetworking
import Photos
import SocketRocket

class ImageStyleTransferViewController: UIViewController, SRWebSocketDelegate {
    // MARK: - Controls
    @IBOutlet weak var stylizedImageView: UIImageView!

    // MARK: - Websocket
    var websocket: SRWebSocket? = nil
    let serverURLString = "ws://4157k7f729.zicp.vip/api/imgTrans/ws"

    // MARK: - Prepared Images
    var styleImage: UIImage? = UIImage()
    var contentImage: UIImage? = UIImage()
    var stylizedImage: UIImage? = UIImage()

    // MARK: - View Did Load
    override func viewDidLoad() {
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "head_background"), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // setup websocket
        websocket?.delegate = nil
        websocket = nil
        let url = URL(string: serverURLString)!
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 5)
        websocket = SRWebSocket(urlRequest: request)
        if let websocket = websocket {
            websocket.delegate = self
            websocket.open()
        }
        SVProgressHUD.showInfo(withStatus: "Progressing...")
    }

    override func viewWillDisappear(_ animated: Bool) {
        websocket?.close()
        websocket?.delegate = nil
        websocket = nil
    }

    // MARK: - Save Image
    @IBAction func saveButtonDidClick(_ sender: UIButton) {
        saveImage(image: stylizedImage!)
    }

    func saveImage(image: UIImage) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        } completionHandler: { success, error in
            let status = success ? "Saved" : "Failed"
            SVProgressHUD.showInfo(withStatus: status)
            SVProgressHUD.dismiss(withDelay: 1.0)
        }
    }

    // MARK: - SRWebsocket Delegate
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        let jsonObject: Dictionary<String, Any>
        do {
            try jsonObject = JSONSerialization.jsonObject(with: { (_ jsonString: String) -> Data in
                jsonString.data(using: .utf8)!
            }(message as! String)) as! Dictionary<String, Any>
        } catch {
            return
        }
        SVProgressHUD.dismiss()
        stylizedImageView.image = UIImage.init(base64Encoding: jsonObject["stylized"] as! String)
    }

    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        let dict = [
            "content": UIImage.base64EncodingString(with: contentImage!),
            "style": UIImage.base64EncodingString(with: styleImage!)
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        websocket?.send(jsonString)
    }

    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        SVProgressHUD.showInfo(withStatus: "Disconnected!")
        SVProgressHUD.dismiss(withDelay: 1.0, completion: { [self] in
            websocket?.delegate = nil
            websocket = nil
            navigationController?.popToRootViewController(animated: true)
        })
    }

    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        SVProgressHUD.showInfo(withStatus: "Connection Error!")
        SVProgressHUD.dismiss(withDelay: 1.0, completion: { [self] in
            websocket?.delegate = nil
            websocket = nil
            navigationController?.popToRootViewController(animated: true)
        })
    }
}
