//
//  ImageCollectionViewController.swift
//  CAmeraFilterApp
//
//  Created by ahmed on 11/08/2023.
//

import UIKit
import Photos
import RxSwift
private let reuseIdentifier = "Cell"

class ImageCollectionViewController: UICollectionViewController {
    private var image = [PHAsset]()
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedImage : Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }
    @IBOutlet var imageCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.populateImage()
    }
}
 
extension ImageCollectionViewController {
    private func populateImage() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized
            {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assets.enumerateObjects { (object , count , stop) in
                    self?.image.append(object)
                }
                self?.image.reverse()
                DispatchQueue.main.async {
                    self?.imageCollectionView.reloadData()
                }
            }
        }
    }
}
    // MARK: UICollectionViewDataSource
extension ImageCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.image.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCollectionViewCell
        else {
            fatalError("invalid cell")
        }
        let assets = self.image[indexPath.row]
        let manager = PHImageManager.default()
        manager.requestImage(for: assets, targetSize: CGSize(width: 120, height: 120), contentMode: .aspectFit, options: nil) { image, _ in
            DispatchQueue.main.async {
                cell.imageCell.image =  image
            }
        }
        return cell
    }
    
    
}
    // MARK: UICollectionViewDelegate
extension ImageCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = self.image[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { [weak self] image, info in
            
            guard let info = info else {
                print("error in info")
                return
            }
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
            
            if !isDegradedImage {
                if let image = image
                {
                    self?.selectedPhotoSubject.onNext(image)
                    self?.dismiss(animated: true , completion: nil)
                }
            }
        }
    }
}

