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

class ImageStyleTransferViewControllerBackup: UIViewController {
    // MARK: - Operation Queue
    lazy var operationQueue = {() -> OperationQueue in
        let operationQueue = OperationQueue()
        return operationQueue
    }()

    // MARK: - Controls
    @IBOutlet weak var stylizedImageView: UIImageView!

    // MARK: - Prepared Images
    var styleImage: UIImage? = UIImage()
    var contentImage: UIImage? = UIImage()
    var stylizedImage: UIImage? = UIImage()
    var uploadSuccess: Bool = false

    // MARK: - View Did Load
    override func viewDidLoad() {
        stylization()
    }

    // MARK: - Stylization
    func stylization() {
        SVProgressHUD.showInfo(withStatus: "Progressing...")
        let uploadOperation1 = BlockOperation { [self] in
            uploadImage(image: styleImage!, imageName: "styleImage.png") { [self] error in
//                if let error = error {
//                    print("Error: \(error)")
//                } else {
//                    uploadSuccess = true
//                }
                if error != nil {
                    uploadSuccess = true
                }
            }
        }
        let uploadOperation2 = BlockOperation { [self] in
            uploadImage(image: contentImage!, imageName: "contentImage.png") { [self] error in
//                if let error = error {
//                    print("Error: \(error)")
//                } else {
//                    uploadSuccess = true
//                }
                if error != nil {
                    uploadSuccess = true
                }
            }
        }
        let callBackOperation = BlockOperation { [self] in
            if uploadSuccess {
                print("Upload Success")
                let delay = DispatchTime.now() + .seconds(2)
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    stylizedImageView.image = imageStyleTransfer(style: styleImage!, content: contentImage!)
                }
            } else {
                print("Upload Failed")
            }
        }
        callBackOperation.addDependency(uploadOperation2)
        uploadOperation2.addDependency(uploadOperation1)
        operationQueue.addOperations([uploadOperation1, uploadOperation2, callBackOperation], waitUntilFinished: false)
//        OperationQueue.main.addOperation()

    }

    func uploadImage(image: UIImage, imageName: String, completionBlock: @escaping (_ error: Error?) -> ()) {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        let manager: AFURLSessionManager = AFURLSessionManager(sessionConfiguration: config)
        let fieldName = "userfile"
        let urlString = "http://localhost:8081/upload/upload.php"
        let request = AFHTTPRequestSerializer().multipartFormRequest(withMethod: "POST", urlString: urlString, parameters: nil, constructingBodyWith: { formData in
            formData.appendPart(withFileData: image.pngData()!, name: fieldName, fileName: imageName, mimeType: "application/octet-stream")
        }, error: nil) as URLRequest
        let uploadTask = manager.uploadTask(withStreamedRequest: request, progress: { progress in
            DispatchQueue.main.async {
                print(progress)
            }
        }, completionHandler: { response, responseObject, error in
            if let error = error {
                completionBlock(error)
                return
            }
            let httpURLResponse = response as! HTTPURLResponse
            if httpURLResponse.statusCode == 200 || httpURLResponse.statusCode == 304 {
                print(responseObject as Any)
                completionBlock(error)
            } else {
                print("Internal Error!")
                return
            }
        })
        uploadTask.resume()
    }

    func imageStyleTransfer(style: UIImage, content: UIImage) -> UIImage? {
        UIImage(named: "stylized_content")
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
            SVProgressHUD.dismiss(withDelay: 0.8)
        }
    }
}
