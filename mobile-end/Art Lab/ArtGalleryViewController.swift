//
//  ArtGalleryViewController.swift
//  Art Lab
//
//  Created by 李俊宏 on 2021/6/13.
//

import UIKit

class ArtGalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Controls
    @IBOutlet weak var stylesCollectionView: UICollectionView!
    @IBOutlet weak var selectedStyleView: UIView!
    @IBOutlet weak var selectedContentView: UIView!
    @IBOutlet weak var selectedStyleImageView: UIImageView!
    @IBOutlet weak var selectedContentImageView: UIImageView!
    
    
    // MARK: - Lazy Load
    lazy var artStyles = {() -> Array<ArtStyle> in
        let path = Bundle.main.path(forResource: "styles", ofType: "plist")
        let dictArr = NSDictionary(contentsOfFile: path!)
        let arrArt = dictArr!["Art"]! as! Array<Any>
        var model: [ArtStyle] = []
        for item in arrArt {
            let data = try! JSONSerialization.data(withJSONObject: item as! [String: Any], options: [])
            let artStyle = try! JSONDecoder().decode(ArtStyle.self, from: data)
            model.append(artStyle)
        }
        return model
    }()
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "head_background"), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // CollectionView
        stylesCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        stylesCollectionView.dataSource = self
        stylesCollectionView.delegate = self
        stylesCollectionView.register(UINib(nibName: "ArtStyleCell", bundle: nil), forCellWithReuseIdentifier: ArtGalleryViewController.reuseID)

        // Style & Content Preview View
        let selectedImageViews = [selectedStyleImageView, selectedContentImageView]
        for i in 0 ..< selectedImageViews.count {
            let selectedImageView = selectedImageViews[i]
            selectedImageView!.clipsToBounds = true
            selectedImageView!.layer.cornerRadius = 20
            selectedImageView!.layer.borderWidth = 5.0
            selectedImageView!.layer.borderColor = UIColor.white.cgColor
            selectedImageView!.contentMode = .scaleAspectFill

            selectedImageView!.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(selectImage))
            selectedImageView!.addGestureRecognizer(tap)
            tap.view?.tag = i
        }
    }
    
    var selectedImageViewTag = 0
    @objc func selectImage(event: UITapGestureRecognizer) {
        selectedImageViewTag = event.view!.tag
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .savedPhotosAlbum
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Collection View Data Source
    static let reuseID = "art_style_cell"
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        artStyles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let artStyle = artStyles[indexPath.row]
        let cell = stylesCollectionView.dequeueReusableCell(withReuseIdentifier: ArtGalleryViewController.reuseID, for: indexPath) as! ArtStyleCell
        cell.artistLabel.text = artStyle.artist
        cell.artImageView.image = UIImage.init(named: artStyle.image)
        return cell
    }
    
    // MARK: - Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let artStyle = artStyles[indexPath.row]
        selectedStyleImageView.image = UIImage(named: artStyle.image)
    }
    
    // MARK: - Image Picker Controller Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        selectedImageViewTag == 0 ? (selectedStyleImageView.image = image) : (selectedContentImageView.image = image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Collection View Delegate Flow Layout
    let cellMarginTop: CGFloat = 20.0
    let cellMarginBottom: CGFloat = 20.0
    let cellMarginLeft: CGFloat = 30.0
    let cellMarginRight: CGFloat = 30.0
    let cellMarginInner: CGFloat = 20.0
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    // set edge insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    // set minimum inter item spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        0
    }
    // set minimum line Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    // set cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let cellWidth = screenWidth * 0.5
        let cellHeight = cellWidth * 1.2
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // MARK: - Image Style Transfer
    @IBAction func ImageStyleTransferButton(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Data Transfer
        let destinationViewController = segue.destination as! ImageStyleTransferViewController
        destinationViewController.styleImage = selectedStyleImageView.image
        destinationViewController.contentImage = selectedContentImageView.image
    }
}
