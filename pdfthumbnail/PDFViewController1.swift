//
//  ViewController.swift
//  pdfthumbnail
//
//  Created by javra on 7/25/19.
//  Copyright © 2019 javra. All rights reserved.
//

import UIKit
import PDFKit


class PDFViewController1: UIViewController {
    
    @IBOutlet weak var pdfview: PDFView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var documentPath: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let path = Bundle.main.path(forResource: "1", ofType: "pdf")
        documentPath = URL(fileURLWithPath: path!)
        let pdfDocument = PDFDocument(url: documentPath)
        pdfview.document = pdfDocument
        
        
        collectionView.backgroundColor = UIColor.lightGray
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
    }
    
    func captureThumbnails(pdfDocument:PDFDocument, pageIndex:  Int, size: CGSize) -> UIImage {
        let page = pdfDocument.page(at: pageIndex)
        let image = page?.thumbnail(of: size, for: .artBox)
        return image!
    }
}

extension PDFViewController1:  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (pdfview.document?.pageCount)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnailcell", for: indexPath)
        // let imageview  = UIImageView
        let image = self.captureThumbnails(pdfDocument: pdfview.document!, pageIndex: indexPath.row, size: cell.bounds.size)
        cell.contentView.layer.contents = image.cgImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pdfview.go(to: (pdfview.document?.page(at: indexPath.row))!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height);
    }
}

