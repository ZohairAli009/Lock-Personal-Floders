//
//  ShowMediaViewController.swift
//  Lock-Folder-App
//
//  Created by Zohair on 24/10/2024.
//

import UIKit
import AVFoundation
import AVKit

class ShowMediaViewController: UIViewController {
    
    @IBOutlet var mediaCollectionView: UICollectionView!
    
    var player: AVPlayer?
    var playerViewController: AVPlayerViewController?
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var imagesList: [UIImage] = []
    var dataList: [Files] = []
    var selectedIndex: IndexPath!
    
    var selectedMediaIndex: Int?
    
    var pinchGesture: UIPinchGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let width = mediaCollectionView.frame.width
        let offSet = CGPoint(x: width * CGFloat(selectedIndex.item), y: 0)
        DispatchQueue.main.async {
            self.mediaCollectionView.setContentOffset(offSet, animated: false)
        }
    }
    
    
    private func setupViewController(){
        let Btn1 = CustomBtn(frame: CGRect(x: 0, y: 0, width: 50, height: 50), image: "square.and.arrow.up", color: .black)
        let Btn2 = CustomBtn(frame: CGRect(x: 0, y: 0, width: 50, height: 50), image: "trash", color: .red)
        
        Btn1.addTarget(self, action: #selector(shareBtnTapped), for: .touchUpInside)
        Btn2.addTarget(self, action: #selector(deleteBtnTapped), for: .touchUpInside)
        let shareBtn = UIBarButtonItem(customView: Btn1)
        let deleteBtn = UIBarButtonItem(customView: Btn2)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        navigationController?.isToolbarHidden = false
        toolbarItems = [shareBtn, spacer, deleteBtn]
        
        NotificationCenter.default.addObserver(self, selector: #selector(playVideo), name: NSNotification.Name("cellTapped"), object: nil)
    }
    
    
    func reloadData(){
        DispatchQueue.main.async {
            self.mediaCollectionView.reloadData()
        }
    }
    
    
    func deleteItem(){
        var file: Files
        var index: Int
        if selectedMediaIndex == nil{
            file = dataList[selectedIndex.item]
            index = selectedIndex.item
        }else{
            file = dataList[selectedMediaIndex!]
            index = selectedMediaIndex!
        }
        dataList.remove(at: index)
        imagesList.remove(at: index)
        context?.delete(file)
        
        try! context?.save()
        mediaCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        reloadData()
        
        if imagesList.isEmpty {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @objc func deleteBtnTapped(){
        self.showAlertAskForDelete({ _ in
            self.deleteItem()
        }, title: "Are you sure you want to delete.")
    }
    
    
    @objc func shareBtnTapped(){
        var mediaForShare = [Any]()
        var file: Files
        var index: Int
        if selectedMediaIndex == nil{
            file = dataList[selectedIndex.item]
            index = selectedIndex.item
        }else{
            file = dataList[selectedMediaIndex!]
            index = selectedMediaIndex!
        }
        
        if file.fileType == "Png"{
            mediaForShare = [imagesList[index]]
        }else{
            if let videoUrl = URL(string: file.videoUrl!){
                mediaForShare = [videoUrl]
            }
        }
        let ac = UIActivityViewController(
            activityItems: mediaForShare,
            applicationActivities: nil
        )
        present(ac, animated: true)
    }

    
    func resetPlayerViewController(){
        player?.pause()
        playerViewController?.view.removeFromSuperview()
        player = nil
        playerViewController = nil
    }
    
    
    func configureWithVideo(videoURL: URL) {
        resetPlayerViewController()
        
        // Set up the player
        player = AVPlayer(url: videoURL)
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
        playerViewController?.showsPlaybackControls = true
        
        present(playerViewController!, animated: false)
        player?.play()
    }
    
}



extension ShowMediaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as? ShowMediaCell
        
        cell?.imageView.image = imagesList[indexPath.item]
        
        if dataList[indexPath.item].fileType == "Vid" {
            cell?.playImageView.isHidden = false
        }else{
            cell?.playImageView.isHidden = true
        }
        
        return cell!
    }
    
    // didSelectItemAt()
    @objc func playVideo(){
        var index: Int!
        if selectedMediaIndex == nil{
            index = selectedIndex.item
        }else{
            index = selectedMediaIndex
        }
        if dataList[index].fileType == "Vid" {
            let urlString = dataList[index].videoUrl
            let url = URL(string: urlString!)
            configureWithVideo(videoURL: url!)
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        selectedMediaIndex = nil
        let Point = CGPoint(x: mediaCollectionView.bounds.midX, y: mediaCollectionView.bounds.midY)
        if let visibleIndexPath = mediaCollectionView.indexPathForItem(at: Point) {
            selectedMediaIndex = visibleIndexPath.item
        }
    }
    
}
