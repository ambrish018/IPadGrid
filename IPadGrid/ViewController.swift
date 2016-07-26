//
//  ViewController.swift
//  IPadGrid
//
//  Created by Ambrish on 26/07/16.
//  Copyright © 2016 Ambrish. All rights reserved.
//

import UIKit
var IsIpad = true
class ViewController: UIViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let layout = mainCollectionView?.collectionViewLayout as? AmbLayout {
            layout.delegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellId", forIndexPath: indexPath)
            
        
            return cell
            
            
        
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    
   
    
    
   
        
        
            
        
    
}
extension ViewController:AmbLayoutDelegate {
    // 1. Returns the photo height
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath , withWidth:CGFloat) -> CGFloat {
        
        return ((withWidth-20) * 3 / 4) + 60 + (IsIpad ? 0:0)
    }
    // 2. Returns the annotation size based on the text
    func collectionView(collectionView: UICollectionView, returnMinusOneIncaseOfFooterAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        
        
            return 0
        
    }
}
