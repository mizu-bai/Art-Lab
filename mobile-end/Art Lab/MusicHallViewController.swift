//
//  MusicHallViewController.swift
//  Art Lab
//
//  Created by 李俊宏 on 2021/6/13.
//

import UIKit

class MusicHallViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIDocumentPickerDelegate {
    // MARK: - Controls
    @IBOutlet weak var stylesTableView: UITableView!
    @IBOutlet weak var selectStyleButton: UIButton!
    @IBOutlet weak var selectContentButton: UIButton!

    var selectedButtonTag: Int = 0

    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // table view dataSource & delegate
        stylesTableView.dataSource = self
        stylesTableView.delegate = self
        stylesTableView.separatorStyle = .none
        stylesTableView.register(UINib(nibName: "MusicStyleCell", bundle: nil), forCellReuseIdentifier: MusicHallViewController.reuseID)

        let buttons = [selectStyleButton, selectContentButton]
        for i in 0 ..< buttons.count {
            buttons[i]?.titleLabel?.numberOfLines = 0
            buttons[i]?.layer.masksToBounds = true
            buttons[i]?.layer.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.5).cgColor
            buttons[i]?.layer.cornerRadius = 20
            buttons[i]?.layer.borderWidth = 10
            buttons[i]?.layer.borderColor = UIColor.white.cgColor
            buttons[i]?.tag = i
        }
    }

    // MARK: - Lazy Load
    lazy var musicHallStyles = { () -> Array<MusicStyle> in
        let path = Bundle.main.path(forResource: "styles", ofType: "plist")
        let dictArr = NSDictionary(contentsOfFile: path!)
        let arrMusic = dictArr!["Music"]! as! Array<Any>
        var model: [MusicStyle] = []
        for item in arrMusic {
            let data = try! JSONSerialization.data(withJSONObject: item as! [String: Any], options: [])
            let musicStyle = try? JSONDecoder().decode(MusicStyle.self, from: data)
            model.append(musicStyle!)
        }
        return model
    }()

    // MARK: - Table View Data Source
    static let reuseID = "music_style_cell"

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        musicHallStyles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let style = musicHallStyles[indexPath.row]
        let cell: MusicStyleCell? = tableView.dequeueReusableCell(withIdentifier: MusicHallViewController.reuseID) as? MusicStyleCell
        // musician label
        cell?.musicianLabel?.text = style.artist
        cell?.musicLabel?.text = style.music
        // musician image view
        cell?.musicianImageView?.image = UIImage.init(named: style.artist)
        return cell!
    }

    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        stylesTableView.deselectRow(at: indexPath, animated: true)
        let model = musicHallStyles[indexPath.row]
        selectStyleButton.setTitle(model.music, for: .normal)

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

    // MARK: - Select Style Music & Content Music
    @IBAction func selectStyleMusicButtonDidClick(_ sender: Any) {
        selectedButtonTag = 0
        selectMusic()
    }

    @IBAction func selectContentMusicButtonDidClick(_ sender: Any) {
        selectedButtonTag = 1
        selectMusic()
    }

    func selectMusic() {
        let documentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.audiovisual-content"], in: .import)
        documentPickerViewController.modalPresentationStyle = .formSheet
        documentPickerViewController.delegate = self
        present(documentPickerViewController, animated: true, completion: nil)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let fileName = urls.first?.lastPathComponent
        DispatchQueue.main.async { [self] in
            if selectedButtonTag == 0 {
                selectStyleButton.setTitle(fileName, for: .normal)
            } else {
                selectContentButton.setTitle(fileName, for: .normal)
            }
        }
    }
}
