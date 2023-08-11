//
//  ImageFilte.swift
//  CAmeraFilterApp
//
//  Created by ahmed on 11/08/2023.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class ImageFilte{

    private var context : CIContext
    init() {
        self.context = CIContext()
    }
    
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage>
    {
        return Observable<UIImage>.create { observer in
            self.applyFilter(to: inputImage) { filterdImage in
                observer.onNext(filterdImage)
            }
            return  Disposables.create()
        }
    }
    private func applyFilter(to image: UIImage ,  completion: @escaping ((UIImage) -> ()))
    {

        let filter = CIFilter(name: "CICMYKHalftone")!
        filter.setValue(5.0, forKey: kCIInputWidthKey)
        
        if let sourceImage = CIImage(image: image) {
            
            filter.setValue(sourceImage, forKey: kCIInputImageKey)
            
            if let cgimg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
                
                let processedImage = UIImage(cgImage: cgimg, scale: image.scale, orientation: image.imageOrientation)
                completion(processedImage)
            }
        }
    }
}
