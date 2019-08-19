//
//  ResourcesCollectionViewController.swift
//  Bement
//
//  Created by Runkai Zhang on 9/24/18.
//  Copyright © 2019 Numeric Design. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ResourcesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var titleLabel: UINavigationItem!
    var segueData: Int = 0
    var catalogs = [UIImage]()
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate let itemsPerRow: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        switch segueData {
        case 1:
            titleLabel.title = "Kindergarten"
            catalogs = catalog.Kindergarden as! [UIImage]
        case 2:
            titleLabel.title = "Grade 1"
            catalogs = catalog.Grade1
        case 3:
            titleLabel.title = "Grade 2"
            catalogs = catalog.Grade2
        case 4:
            titleLabel.title = "Grade 3"
            catalogs = catalog.Grade3
        case 5:
            titleLabel.title = "Grade 4"
            catalogs = catalog.Grade4
        case 6:
            titleLabel.title = "Grade 5"
            catalogs = catalog.Grade5
        case 7:
            titleLabel.title = "Grade 6"
            catalogs = catalog.Grade6
        case 8:
            titleLabel.title = "Grade 7"
            catalogs = catalog.Grade7
        case 9:
            titleLabel.title = "Grade 8 & 9"
            catalogs = catalog.Grade89
        default:
            print("This should not happen!")
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catalogs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! CatalogCollectionViewCell
        //2
        cell.backgroundColor = UIColor.white
        //3
        cell.image.image = catalogs[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
