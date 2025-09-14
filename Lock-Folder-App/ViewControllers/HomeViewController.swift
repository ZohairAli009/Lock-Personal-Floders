//
//  ViewController.swift
//  Lock-Folder-App
//
//  Created by Zohair on 18/10/2024.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet var foldersCollectionView: UICollectionView!
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var searchMode: Bool = false
    var foldersList = [Folder]()
    var filterdFolders = [Folder]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavButtons()
        setupViewController()
        showLockScreen()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFoldersData()
    }

    
    func setupViewController(){
        foldersCollectionView.backgroundColor = .clear
        searchController.searchBar.searchTextField.backgroundColor = .darkGray.withAlphaComponent(0.8)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        let textField = searchController.searchBar.searchTextField
        textField.leftView?.tintColor = .systemIndigo
        textField.backgroundColor = .init(red: 195/255, green: 251/255, blue: 255/255, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [.foregroundColor: UIColor.systemIndigo])
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false 
        
        // Add Observers
        NotificationCenter.default.addObserver(self, selector: #selector(addFolder), name: NSNotification.Name("FolderName"), object: nil)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("FolderName"), object: nil)
    }
    
    func setupNavButtons(){
        let Btn1 = CustomBtn(frame: CGRect(x: 0, y: 0, width: 50, height: 50), image: "gear", color: .systemIndigo)
        let Btn2 = CustomBtn(frame: CGRect(x: 0, y: 0, width: 50, height: 50), image: "line.3.horizontal.decrease", color: .systemIndigo)
        let Btn3 = CustomBtn(frame: CGRect(x: 0, y: 0, width: 50, height: 50), image: "folder.badge.plus", color: .systemIndigo)
        
        Btn1.addTarget(self, action: #selector(navSettingBtnTapped), for: .touchUpInside)
        Btn2.addTarget(self, action: #selector(navEditBtnTapped), for: .touchUpInside)
        Btn3.addTarget(self, action: #selector(addFolderBtnTapped), for: .touchUpInside)
        
        let settingBtn = UIBarButtonItem(customView: Btn1)
        let editBtn = UIBarButtonItem(customView: Btn2)
        let addFolderBtn = UIBarButtonItem(customView: Btn3)
        
        navigationItem.leftBarButtonItem = settingBtn
        navigationItem.rightBarButtonItem = editBtn
        navigationController?.isToolbarHidden = false
        
        if let toolbar = navigationController?.toolbar {
            toolbar.backgroundColor = .init(red: 195/255, green: 251/255, blue: 255/255, alpha: 1)
            toolbar.layer.cornerRadius = 30
            toolbar.layer.masksToBounds = true
        }
        
        // Tool bar button
        let Space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [Space, addFolderBtn]

    }
    
    
    func showLockScreen(){
        let key1 = UserDefaults.standard.bool(forKey: "passcode")
        let key2 = UserDefaults.standard.bool(forKey: "faceid")
        
        if key1 || key2 {
            let lockVC = storyboard?.instantiateViewController(withIdentifier: "LockScreenVC") as? LockScreenViewController
            lockVC?.modalPresentationStyle = .fullScreen
            present(lockVC!, animated: false, completion: nil)
        }
    }
    
    @objc func addFolder(_ notification: NSNotification){
        let name = notification.object as? String
        let currentDate = CodeHelper().getCurrentDate()
        let newFolder = Folder(context: context!)
        newFolder.folderName = name
        newFolder.items = "0"
        newFolder.dateCreated = currentDate
        
        try! context?.save()
        fetchFoldersData()
    }
    
    func fetchFoldersData(){
        let folders = try! context?.fetch(Folder.fetchRequest())
        foldersList = folders!
        DispatchQueue.main.async {
            self.foldersCollectionView.reloadData()
        }
    }
    

    @objc func navSettingBtnTapped(){
        let vc = SettingsViewController()
        
        present(vc, animated: true)
    }

    
    @objc func navEditBtnTapped(){
        
    }
    
    
    @objc func addFolderBtnTapped(){
        let vc = AddFolderViewController()
        present(vc, animated: true)
    }

    
    func reloadCollectionView(){
        DispatchQueue.main.async {
            self.foldersCollectionView.reloadData()
        }
    }
    
    
    func editFolderName(indexpath: IndexPath){
        let folder = foldersList[indexpath.item]
        let ac = UIAlertController(title: "Rename Folder", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { _ in
            let newName = ac.textFields?[0].text
            if newName?.isEmpty != true{
                folder.folderName = newName
                try! self.context?.save()
                self.reloadCollectionView()
            }
        })
        cancelAction.setValue(UIColor.white, forKey: "titleTextColor")
        saveAction.setValue(UIColor.white, forKey: "titleTextColor")
        ac.addAction(cancelAction)
        ac.addAction(saveAction)
        present(ac, animated: true)
    }
    
    
    func deleteFolder(indexpath: IndexPath){
        let folder = foldersList.remove(at: indexpath.item)
        context?.delete(folder)
        try! context?.save()
        foldersCollectionView.deleteItems(at: [indexpath])
        reloadCollectionView()
    }
}



// MARK: - Extensions

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchMode ? filterdFolders.count : foldersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if searchMode {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath)
            let nameLabel = cell.viewWithTag(1) as? UILabel
            let itemCountLabel = cell.viewWithTag(2) as? UILabel
            
            nameLabel?.text = filterdFolders[indexPath.item].folderName
            itemCountLabel?.text = (filterdFolders[indexPath.item].items)! + " items"
            
            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath)
            let nameLabel = cell.viewWithTag(1) as? UILabel
            let itemCountLabel = cell.viewWithTag(2) as? UILabel
            
            nameLabel?.text = foldersList[indexPath.item].folderName
            itemCountLabel?.text = (foldersList[indexPath.item].items)! + " items"
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Rename", image: UIImage(systemName: "square.and.pencil")) { _ in
                self.editFolderName(indexpath: indexPath)
            }
            let lockAction = UIAction(title: "Lock", image: UIImage(systemName: "lock.open")) { _ in
                
            }
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash")) { _ in
                self.showAlertAskForDelete({ _ in
                    self.deleteFolder(indexpath: indexPath)
                }, title: "Are you sure you want to delete this folder.")
            }
            return UIMenu(title: "", children: [editAction, lockAction, deleteAction])
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController
        
        vc?.clickedFolder = nil 
        if searchMode {
            vc?.clickedFolder = filterdFolders[indexPath.item]
            vc?.folderName = filterdFolders[indexPath.item].folderName!
        }else{
            vc?.clickedFolder = foldersList[indexPath.item]
            vc?.folderName = foldersList[indexPath.item].folderName!
        }
        
        navigationController?.pushViewController(vc!, animated: true)
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        if text.isEmpty {
            filterdFolders = []
        }else{
            filterdFolders = foldersList.filter { $0.folderName?.lowercased().hasPrefix(text.lowercased()) ?? false
            }
        }
        DispatchQueue.main.async {
            self.foldersCollectionView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchMode = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchMode = false
    }
}


extension HomeViewController {
    func clearCoreData() {
        // Get the persistent container from AppDelegate or your Core Data stack
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Get all the entities in Core Data
        let entities = appDelegate.persistentContainer.managedObjectModel.entities
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name ?? "")
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let objects = try context.fetch(fetchRequest)
                for object in objects {
                    guard let objectData = object as? NSManagedObject else { continue }
                    context.delete(objectData)
                }
                try context.save()
                print("Deleted all data for entity: \(entity.name ?? "unknown entity")")
            } catch let error {
                print("Failed to clear data for entity: \(entity.name ?? "unknown entity"), error: \(error)")
            }
        }
        
    }
}
