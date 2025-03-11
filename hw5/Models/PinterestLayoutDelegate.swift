//
//  PinterestLayoutDelegate.swift
//  hw5
//
//  Created by Ani Lakirbaia on 06.02.25.
//


import Foundation
import UIKit

protocol PinterestLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
    weak var delegate: PinterestLayoutDelegate?
    
    private var cols = 2
    private var padding: CGFloat = 5
    private var height: CGFloat = 0
    
    private var contWidth: CGFloat {
        guard let cv = collectionView else { return 0 }
        let insets = cv.contentInset
        return cv.bounds.width - insets.left - insets.right
    }
    private var attrCache: [UICollectionViewLayoutAttributes] = []

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contWidth, height: height)
    }

    override func prepare() {
        guard let cv = collectionView else { return }
        attrCache.removeAll()
        
        let colWidth = contWidth / CGFloat(cols)
        var offsets: [CGFloat] = []
        var colHeights: [CGFloat] = .init(repeating: 0, count: cols)
        
        for i in 0..<cols {
            offsets.append(CGFloat(i) * colWidth)
        }

        for i in 0..<cv.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: i, section: 0)
            let colIdx = colHeights.firstIndex(of: colHeights.min()!) ?? 0
            let width = colWidth - (padding * 2)
            let itemHeight = delegate?.collectionView(cv, heightForItemAt: indexPath, with: width) ?? 0
            
            let frame = CGRect(x: offsets[colIdx], y: colHeights[colIdx], width: colWidth, height: itemHeight)
            let insetFrame = frame.insetBy(dx: padding, dy: padding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            attrCache.append(attributes)
            
            height = max(height, frame.maxY)
            colHeights[colIdx] += itemHeight + (padding * 2)
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrCache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attrCache.first { $0.indexPath == indexPath }
    }
}
