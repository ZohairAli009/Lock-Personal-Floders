//
//  DetailViewController.swift
//  Lock-Folder-App
//
//  Created by Zohair on 20/10/2024.
//

import UIKit
import PhotosUI
import Photos

class DetailViewController: UIViewController {
    
    @IBOutlet var detailCollectionView: UICollectionView!
    @IBOutlet var emptySateView: UIView!
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var clickedFolder: Folder?
    var folderName = ""
    var filesList = [Files]()
    var mediaSelection: Bool = false
    var selectedIndexs: [IndexPath] = []
    var selectedMedia: [Files] = []
    
    var toolTrashBtn: UIButton!
    var toolShareBtn: UIButton!
    var navSelectBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureAddBtn()
        setupViewcontroller()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = folderName
        fetchData()
        if !filesList.isEmpty {
            setupNavButtons()
        }
        showEmptySateView()
    }
    
    
    private func setupViewcontroller(){
        detailCollectionView.backgroundColor = .clear
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    private func setupNavButtons(){
        navSelectBtn = CustomBtn(frame: CGRect(x: 0, y: 0, width: 60, height: 30), title: "Select", color: .black)
        navSelectBtn.addTarget(self, action: #selector(selectMediaBtnTapped), for: .touchUpInside)
        
        let selectBtn = UIBarButtonItem(customView: navSelectBtn)
        navigationItem.rightBarButtonItem = selectBtn
        navigationController?.isToolbarHidden = false
        
    }
    
    
    func fetchData(){
        if let folder = clickedFolder {
            if let fileData = folder.toFiles?.array as? [Files] {
                filesList = fileData
            }
        }
        DispatchQueue.main.async {
            self.detailCollectionView.reloadData()
        }
        clickedFolder?.items = "\(filesList.count)"
        try! context?.save()
    }
    
    
    func showEmptySateView(){
        if filesList.isEmpty {
            emptySateView.isHidden = false
        }else{
            emptySateView.isHidden = true
        }
    }
    
    func generateThumbnail(url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        let time = CMTime(seconds: 1, preferredTimescale: 60)  // Get the frame at 1 second
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("Failed to generate thumbnail: \(error)")
            return nil
        }
    }
    
    
    func convertDataToImages() -> [UIImage]{
        var imageList: [UIImage] = []
        
        for file in filesList{
            if let image = UIImage(data: file.imageData!){
                imageList.append(image)
            }
        }
        
        return imageList
    }
    
    
    func deleteItemFromDocument(VideoUrl: String){
        let fileManager = FileManager.default
        guard let url = URL(string: VideoUrl) else { return }
        
        do {
            if fileManager.fileExists(atPath: url.path) {
                try fileManager.removeItem(at: url)
            }
            print("Video removed from Documents directory.")
            
        }catch let error{
            print("Video not removed from Documents: \(error.localizedDescription)")
        }
    }
    
    
    func deleteItems(){
        if !selectedMedia.isEmpty{
            for item in selectedMedia{
                filesList.removeAll {$0 == item}
                context?.delete(item)
                if item.fileType == "Vid"{
                    deleteItemFromDocument(VideoUrl: item.videoUrl!)
                }
            }
            try! context?.save()
            
            detailCollectionView.performBatchUpdates({
                detailCollectionView.deleteItems(at: selectedIndexs)
            }, completion: nil)
            
            selectedMedia.removeAll()
            selectedIndexs.removeAll()
            selectMediaBtnTapped(navSelectBtn)
            showEmptySateView()
            fetchData()
        }
    }
    
    
    @objc func deleteItemsTapped(){
        let mediaCount = selectedMedia.count
        var discr = ""
        
        if mediaCount == 0 { return }
        else if mediaCount == 1 {discr = "this \(mediaCount) item."}
        else{discr = "these \(mediaCount) items."}
        
        self.showAlertAskForDelete({ _ in
            self.deleteItems()
        }, title: "Are you sure you want to delete " + discr)
    }
    
    
    func selectBtnTap(){
        toolShareBtn = CustomBtn(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                             image: "square.and.arrow.up",
                             color: .black.withAlphaComponent(0.4))
        toolTrashBtn = CustomBtn(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                             image: "trash",
                             color: .red.withAlphaComponent(0.4))
        
        toolTrashBtn.addTarget(self, action: #selector(deleteItemsTapped), for: .touchUpInside)
        
        navigationController?.navigationBar.topItem?.hidesBackButton = true
        let shareBtn = UIBarButtonItem(customView: toolShareBtn)
        let deleteBtn = UIBarButtonItem(customView: toolTrashBtn)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [shareBtn, spacer, deleteBtn]
    }
    
    
    func configureAddBtn(){
        let Btn = CustomBtn(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                             image: "plus.circle", color: .black)
        Btn.addTarget(self, action: #selector(addBtnTapped), for: .touchUpInside)
        let addBtn = UIBarButtonItem(customView: Btn)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [spacer, addBtn]
    }
    
    
    @objc func selectMediaBtnTapped(_ sender: UIButton){
        
        if sender.title(for: .normal) == "Select" {
            if !filesList.isEmpty {
                sender.setTitle("Cancel", for: .normal)
                mediaSelection = true
                selectBtnTap()
            }
        }
        else if sender.title(for: .normal) == "Cancel" {
            sender.setTitle("Select", for: .normal)
            mediaSelection = false
            navigationController?.navigationBar.topItem?.hidesBackButton = false
            configureAddBtn()
        }
        
    }
    
    
    func saveVideoInDocuDirectory(VideoUrl: URL) -> URL?{

        let fileManager = FileManager.default
        let DestinationUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(VideoUrl.lastPathComponent)
        
        do {
            if fileManager.fileExists(atPath: DestinationUrl.path){
                try fileManager.removeItem(at: DestinationUrl)
            }
            try fileManager.copyItem(at: VideoUrl, to: DestinationUrl)
            
            print("Video url saved in Documents Directory.")
            return DestinationUrl
            
        }catch let error{
            print("Documents Directory error: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    
    func saveFileInCoreData(withData: Data, type: String, Url: String){
        let newFile = Files(context: context!)
        newFile.imageData = withData
        newFile.fileType = type
        newFile.videoUrl = Url
        newFile.toFolder = clickedFolder!
        
        clickedFolder!.addToToFiles(newFile)
        try! context?.save()
        fetchData()
    }
    
    
    @objc func addBtnTapped(){
        presentPhotoPicker()
    }
    
    
    func handleCheckMarkSelection(indexPath: IndexPath, imageView: UIImageView?){
        
        if selectedIndexs.contains(indexPath){
            imageView?.isHidden = true
            selectedIndexs.removeAll {$0 == indexPath}
            selectedMedia.removeAll {$0 == filesList[indexPath.item]}
            
        }else{
            imageView?.isHidden = false
            imageView?.backgroundColor = .black.withAlphaComponent(0.3)
            selectedIndexs.append(indexPath)
            selectedMedia.append(filesList[indexPath.item])
        }
        
        if selectedIndexs.isEmpty{
            toolShareBtn.tintColor = .black.withAlphaComponent(0.4)
            toolTrashBtn.tintColor = .red.withAlphaComponent(0.4)
        }else{
            toolShareBtn.tintColor = .black
            toolTrashBtn.tintColor = .red
        }
    }
}


extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as? DetailCell
        
        let list = convertDataToImages()
        cell?.mediaImageView.image = list[indexPath.item]
        cell?.checkMarkImageView.isHidden = true
        
        if filesList[indexPath.item].fileType == "Vid"{
            cell?.videoImageView.isHidden = false
        }else{
            cell?.videoImageView.isHidden = true
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if mediaSelection {
            let cell = collectionView.cellForItem(at: indexPath) as? DetailCell
            let markImageView = cell?.checkMarkImageView
            handleCheckMarkSelection(indexPath: indexPath, imageView: markImageView)
        }else{
            let vc = (storyboard?.instantiateViewController(withIdentifier: "ShowMediaVC") as? ShowMediaViewController)
            
            let list = convertDataToImages()
            vc?.imagesList = list
            vc?.selectedIndex = indexPath
            vc?.dataList = filesList
            
            navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
}



extension DetailViewController: PHPickerViewControllerDelegate {
    func presentPhotoPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = PHPickerFilter.any(of: [.images, .videos])

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)

        for result in results {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return
                        }
                        self.saveFileInCoreData(withData: imageData, type: "Png", Url: "")
                    }
                }
            }
            else if
                result.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { (url, error) in
                    
                    guard let url = url else {
                        print("No file URL found")
                        return
                    }
                    guard let image = self.generateThumbnail(url: url) else {return}
                    let TNailData = image.jpegData(compressionQuality: 0.8)
                    
                    let videoUrl = self.saveVideoInDocuDirectory(VideoUrl: url)
                    self.saveFileInCoreData(withData: TNailData!, type: "Vid", Url: videoUrl!.absoluteString)
                }
            }
            emptySateView.isHidden = true
            setupNavButtons()
        }
    }
}
