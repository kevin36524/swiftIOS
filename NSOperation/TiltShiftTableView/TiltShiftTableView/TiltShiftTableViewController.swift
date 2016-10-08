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
    var imageProviders = Set<TiltShiftImageProvider>()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tiltShiftCell", for: indexPath)
        
        if let cell = cell as? ImageTableViewCell {
            cell.tiltShiftImage = imageList[indexPath.row]
        }
        
        return cell
    }

}

extension TiltShiftTableViewController {
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ImageTableViewCell else {return}
        
        let imageProvider = TiltShiftImageProvider(tiltImage: imageList[indexPath.row]) { (image) in
            OperationQueue.main.addOperation {
                cell.updateImageViewWithImage(image: image)
            }
        }
        imageProviders.insert(imageProvider)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ImageTableViewCell else {return}
        
        let provider = imageProviders.filter {
            $0.tiltShiftImage == cell.tiltShiftImage
        }.first
        
        if let provider = provider
        {
            provider.cancel()
            imageProviders.remove(provider)
        }
        
    }
}
