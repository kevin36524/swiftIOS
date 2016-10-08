//
//  TiltShiftTableViewController.swift
//  TiltShiftTableView
//
//  Created by Kevin Balvantkumar Patel on 10/5/16.
//  Copyright © 2016 Yahoo. All rights reserved.
//

import UIKit

class TiltShiftTableViewController: UITableViewController {

    let imageList = TiltShiftImage.loadDefaultData()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tiltShiftCell", for: indexPath)
        
        if let cell = cell as? ImageTableViewCell {
            let tsImage = imageList[indexPath.row]
            let imageProvider = TiltShiftImageProvider(tiltImage: tsImage)
            
            cell.tiltShiftImage = imageList[indexPath.row]
            cell.updateImageViewWithImage(image: imageProvider.image)
        }
        
        return cell
    }

}

