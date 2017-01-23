//
//  PhotoTableViewController.swift
//  PhotoMomentsTable
//
//  Created by Simone on 1/22/17.
//  Copyright © 2017 Simone. All rights reserved.
//

import UIKit
import Photos

class PhotoTableViewController: UITableViewController {
    
    var assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\n---Moments List---\n")
        let options = PHFetchOptions()
        let sort = NSSortDescriptor(key: "startDate", ascending: false)
        options.sortDescriptors = [sort]
        let cutoffDate = NSDate(timeIntervalSinceNow: 60 * 60 * 24 * 10 * -1)
        let predicate = NSPredicate(format: "startDate > %@", cutoffDate)
        options.predicate = predicate
        let momentsLists = PHCollectionList.fetchMomentLists(with: .momentListCluster, options: nil)
        for i in 0..<momentsLists.count {
            print("Title: ", momentsLists[i].localizedTitle ?? "no title")
            let moments = momentsLists[i]
            let collectionList = PHCollectionList.fetchCollections(in: moments, options:options)
            
            func printAssetsInList(collection: PHAssetCollection) {
                let assets = PHAsset.fetchAssets(in: collection, options: nil)
                print("\n---\(assets.count)---\n")
                for j in 0..<assets.count {
                    print(assets[j])
                    if j > 10 {
                        break
                    }
                }
            }
            
            for j in 0..<collectionList.count {
                if let collection = collectionList[j] as? PHAssetCollection {
                    printAssetsInList(collection: collection)
                }
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return assets.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let manager = PHImageManager.default()
        
        if cell.tag != 0 {
            manager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        let asset = assets[indexPath.row]
        
        if let creationDate = asset.creationDate {
            cell.textLabel?.text = DateFormatter.localizedString(from: creationDate, dateStyle: .medium, timeStyle: .short) 
        } else {
            cell.textLabel?.text = nil
        }
        
        cell.tag = Int(manager.requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFill, options: nil) { (result, _) in
            
            if let destinationCell = tableView.cellForRow(at: indexPath as IndexPath) {
                destinationCell.imageView?.image = result
            }
        })
        
        manager.requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFill, options: nil) { (result, _) in
            
            cell.imageView?.image = result
        }
        
        return cell
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedCell = sender as? UITableViewCell {
            if segue.identifier == "photoSegue" {
                let details = segue.destination as! ViewController
                let cellPath = self.tableView.indexPath(for: selectedCell)
                let selectedImg = assets[(cellPath?.row)!]
                details.asset = selectedImg
            }
        }
     }
    
}
