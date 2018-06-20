//
//  CategoryCollectionViewController.swift
//  Tasker
//
//  Created by Devesh Nema on 6/15/18.
//  Copyright © 2018 Devesh Nema. All rights reserved.
//

import UIKit
import ChameleonFramework
import FirebaseFirestore

class CategoryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var categories = [Category]()
    let db = Firestore.firestore()
    
    var refreshController: UIRefreshControl!
    var customView: UIView!
    var timer: Timer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        refreshController = UIRefreshControl()
        refreshController.backgroundColor = UIColor.clear
        refreshController.tintColor = UIColor.clear
        loadCustomRefreshContents()

        collectionView?.addSubview(refreshController)
        
        
        loadCategories()
        checkLiveUpdates()
    }
    
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        var  textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { (action) in
            let newCategory = Category(name: textfield.text!, tasks: [Task](), color: UIColor.randomFlat.hexValue())
            self.categories.append(newCategory)
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textfield = field
            textfield.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK:- TableView datasource methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count

    }
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.titleLabel.text = categories[indexPath.item].name
        let color = categories[indexPath.item].color
        cell.backgroundColor = UIColor(hexString: color)
        cell.titleLabel.textColor = ContrastColorOf(UIColor(hexString: color)!, returnFlat: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 300)
    }
    
    //MARK:- TableView delegate methods
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoTasks", sender: self)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TaskerViewController

        if let indexPath = collectionView?.indexPathsForSelectedItems![0] {
            destinationVC.selectedCategory = categories[indexPath.item]
        }
    }
    
    //MARK:- data manipulation methods
    func save(category: Category) {
        db.collection("categories").document("\(category.name)").setData(category.dictionary) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func loadCategories() {
        db.collection("categories").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.categories = querySnapshot!.documents.compactMap({Category(dictionary: $0.data())})
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    func checkLiveUpdates() {
        db.collection("categories").whereField("timestamp", isGreaterThan: Date()).addSnapshotListener { (querysnapshot, error) in
            querysnapshot?.documentChanges.forEach({ (diff) in
                if diff.type == .added {
                    self.categories.append(Category(dictionary: diff.document.data())!)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            })
        }
    }
    
    
}


extension CategoryCollectionViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return CGFloat(100 + arc4random_uniform(100))
    }
}


//MARK:- CategoryCell
class CategoryCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Sample Text"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}





//MARK:- extension for custom refresh
extension CategoryCollectionViewController {
    func loadCustomRefreshContents() {
        let refreshContents = Bundle.main.loadNibNamed("RefreshContents", owner: self, options: nil)
        customView = refreshContents![0] as! UIView
        customView.frame = refreshController.bounds
        refreshController.addSubview(customView)
    }
    
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(endRefresh), userInfo: nil, repeats: true)
    }
    
    @objc func endRefresh() {
        refreshController.endRefreshing()
        timer?.invalidate()
        timer = nil
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setupTimer()
    }
}












