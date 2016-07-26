
//

import UIKit
protocol AmbLayoutDelegate {
  // 1. Method to ask the delegate for the height of the image
  func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath , withWidth:CGFloat) -> CGFloat
  // 2. Method to ask the delegate for the height
  func collectionView(collectionView: UICollectionView, returnMinusOneIncaseOfFooterAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
  
}

class AmbLayoutAttributes:UICollectionViewLayoutAttributes {
  
  // 1. Custom attribute
  var photoHeight: CGFloat = 0.0
  
  // 2. Override copyWithZone to conform to NSCopying protocol
  override func copyWithZone(zone: NSZone) -> AnyObject {
    let copy = super.copyWithZone(zone) as! AmbLayoutAttributes
    copy.photoHeight = photoHeight
    return copy
  }
  
  // 3. Override isEqual
  override func isEqual(object: AnyObject?) -> Bool {
    if let attributtes = object as? AmbLayoutAttributes {
      if( attributtes.photoHeight == photoHeight  ) {
        return super.isEqual(object)
      }
    }
    return false
  }
}


class AmbLayout: UICollectionViewLayout {
  //1. Amb Layout Delegate
    var sharedAppdelegate : AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
  var delegate:AmbLayoutDelegate!
  var isHeaderEnabled = false
  //2. Configurable properties
    var numberOfColumns = IsIpad ? 2 : 1
  var cellPadding: CGFloat = 0.0
  
  //3. Array to keep a cache of attributes.
  private var cache = [AmbLayoutAttributes]()
  
  //4. Content height and size
  private var contentHeight:CGFloat  = 0.0
    private var isFooterHidden = false
  private var contentWidth: CGFloat {
    let insets = collectionView!.contentInset
    return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
  }
  
  override class func layoutAttributesClass() -> AnyClass {
    return AmbLayoutAttributes.self
  }
  
   func prepareLayoutCustom() {
    // 1. Only calculate once
    
    
    
    
    if !isFooterHidden {
        contentHeight = 0
    cache .removeAll()
    }

    //if cache.count == 1  {
        cache .removeAll()
    //}
    
    if cache.isEmpty {
      
      // 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
      let columnWidth = contentWidth / CGFloat(numberOfColumns)
      var xOffset = [CGFloat]()
      for column in 0 ..< numberOfColumns {
        xOffset.append(CGFloat(column) * columnWidth )
      }
      var column = 0
      var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
      
      // 3. Iterates through the list of items in the first section
        
        var totalNumberOfItems = 0
        
        if isHeaderEnabled == false {
            for item in 0 ..< collectionView!.numberOfItemsInSection(0)+1 {
                
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                
                if indexPath.item == collectionView!.numberOfItemsInSection(0) {
                    let annotationHeight = delegate.collectionView(collectionView!, returnMinusOneIncaseOfFooterAtIndexPath: indexPath, withWidth: 0)
                    if annotationHeight == -1 {
                        
                        //isFooterHidden = true
                    }else{
                        //isFooterHidden = false
                        
                        let attributes = AmbLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withIndexPath: indexPath)
                        attributes.photoHeight = 40;
                        let frame = CGRectMake(0, contentHeight, (sharedAppdelegate.window?.bounds.width)!, 30)
                        attributes.frame = frame
                        attributes.zIndex = -10;
                        //print(attributes)
                        
                        if collectionView!.numberOfItemsInSection(0) > 0 {
                            cache.append(attributes)

                        }
                    }
                    
                }else{
                    let width = columnWidth - cellPadding*2
                    let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath , withWidth:width)
                    let annotationHeight = delegate.collectionView(collectionView!, returnMinusOneIncaseOfFooterAtIndexPath: indexPath, withWidth: width)
                    let height = cellPadding +  photoHeight + annotationHeight + cellPadding 
                    let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                    let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                    
                    // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
                    let attributes = AmbLayoutAttributes(forCellWithIndexPath: indexPath)
                    attributes.photoHeight = photoHeight
                    attributes.frame = insetFrame
                    // print(attributes)
                    
                    cache.append(attributes)
                    
                    // 6. Updates the collection view content height
                    contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                    yOffset[column] = yOffset[column] + height
                    
                    column = column >= (numberOfColumns - 1) ? 0 : ++column
                }
                
            }
        
        }
        
        else{
            contentHeight = 0

           totalNumberOfItems = collectionView!.numberOfItemsInSection(0)+1 // footer + header
            let indexPath = NSIndexPath(forItem: 0, inSection: 0)
            if collectionView!.numberOfItemsInSection(0) > 0 {
                let annotationHeight = delegate.collectionView(collectionView!, returnMinusOneIncaseOfFooterAtIndexPath: indexPath, withWidth: 0)
                
                if annotationHeight != -1  {
                    if indexPath.item == 0 {
                        let attributes = AmbLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: indexPath)
                        attributes.photoHeight = ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110;
                        let frame = CGRectMake(0, contentHeight, (sharedAppdelegate.window?.bounds.width)!, ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110)
                        attributes.frame = frame
                        attributes.zIndex = -10;
                        //print(attributes)
                        cache.append(attributes)
                        contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                        yOffset[column] = yOffset[column] + ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110
                        
                        column = column >= (numberOfColumns - 1) ? 0 : ++column
                        column = 0
                        if numberOfColumns == 2 {
                            yOffset[1] = ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110
                        }
                        
                        
                    }
                }else{
                    
                    let attributes = AmbLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: indexPath)
                    attributes.photoHeight = ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110;
                    let frame = CGRectMake(0, contentHeight, (sharedAppdelegate.window?.bounds.width)!, ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110)
                    attributes.frame = frame
                    attributes.zIndex = -10;
                    //print(attributes)
                    cache.append(attributes)
                    contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                    yOffset[column] = yOffset[column] + ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110
                    
                    column = column >= (numberOfColumns - 1) ? 0 : ++column
                    column = 0
                    if numberOfColumns == 2 {

                    yOffset[1] = ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110
                    }
                    contentHeight = contentHeight - ((sharedAppdelegate.window?.bounds.width)! * 3 / 4) + 110
                }
                }
            
            
            for item in 0 ..< collectionView!.numberOfItemsInSection(0)+1 {
                
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                
                // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
                
                if totalNumberOfItems == 1 {
                    return
                }
                
                    if indexPath.item == collectionView!.numberOfItemsInSection(0) {
                        let annotationHeight = delegate.collectionView(collectionView!, returnMinusOneIncaseOfFooterAtIndexPath: indexPath, withWidth: 0)
                        if annotationHeight == -1 {
                            
                            //isFooterHidden = true
                        }else{
                            //isFooterHidden = false
                            
                            let attributes = AmbLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withIndexPath: indexPath)
                            attributes.photoHeight = 40;
                            let frame = CGRectMake(0, contentHeight, (sharedAppdelegate.window?.bounds.width)!, 30)
                            attributes.frame = frame
                            attributes.zIndex = -10;
                            //print(attributes)
                            if collectionView!.numberOfItemsInSection(0) > 0 {
                                cache.append(attributes)
                                
                            }                        }
                        
                    }else{
                        
                        let width = columnWidth - cellPadding*2
                        let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath , withWidth:width)
                        let annotationHeight = delegate.collectionView(collectionView!, returnMinusOneIncaseOfFooterAtIndexPath: indexPath, withWidth: width)
                        let height = cellPadding +  photoHeight + annotationHeight + cellPadding
                        let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                        let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                        
                        // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
                        let attributes = AmbLayoutAttributes(forCellWithIndexPath: indexPath)
                        attributes.photoHeight = photoHeight
                        attributes.frame = insetFrame
                        // print(attributes)
                        
                        cache.append(attributes)
                        
                        // 6. Updates the collection view content height
                        contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                        yOffset[column] = yOffset[column] + height
                        
                        column = column >= (numberOfColumns - 1) ? 0 : ++column
                    }
                
                /*
                 
                
 */
                
                
            }
        }
        

    }
  }
  
  override func collectionViewContentSize() -> CGSize {
    
    if isFooterHidden {
       return CGSize(width: contentWidth, height: contentHeight)
    }
    return CGSize(width: contentWidth, height: contentHeight+30)
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    
    // Loop through the cache and look for items in the rect
   // self.prepareLayout()
    
    let indexPathFooter = NSIndexPath(forItem: 0, inSection: 0)
    
    // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
    
        let annotationHeight1 = delegate.collectionView(collectionView!, returnMinusOneIncaseOfFooterAtIndexPath: indexPathFooter, withWidth: 0)
        if annotationHeight1 == -1 {
            
            isFooterHidden = true
        }else{
            isFooterHidden = false
        }
    
    self.prepareLayoutCustom()
    
    for attributes  in cache {
      if CGRectIntersectsRect(attributes.frame, rect ) {
        if attributes.representedElementKind == UICollectionElementKindSectionFooter {
           // print("print a footer")
        }
        layoutAttributes.append(attributes)
      }
    }
    
    
    
    return layoutAttributes
  }
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }

  }
  
   

