//
//  ViewController.swift
//  CAmeraFilterApp
//
//  Created by ahmed on 10/08/2023.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }

 /*   @IBAction func addImage(_ sender: Any) {
        imagePicker()
    }*/
    @IBAction func applyFilter(_ sender: Any) {
    }
    
}

extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func imagePicker(){
        let picker : UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(picker, animated: true , completion: nil)
        }
        else
        {
            print("error")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage]
        image.image = img as? UIImage
        self.dismiss(animated: true,completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController,
              let photosCVC = navC.viewControllers.first as? ImageCollectionViewController
        else {
            fatalError("ERROR")
        }
        photosCVC.selectedImage.subscribe { [weak self] photo in
            self?.image.image = photo
        }.disposed(by: disposeBag)
    }
}
















