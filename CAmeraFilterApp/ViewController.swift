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
    
    @IBOutlet weak var applyFilterBtn: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    override func viewWillAppear(_ animated: Bool) {
        if image.image != nil {
            applyFilterBtn.isHidden = false
        }
        else
        {
            applyFilterBtn.isHidden = true
        }
    }
 /*   @IBAction func addImage(_ sender: Any) {
        imagePicker()
    }*/
    @IBAction func applyFilter(_ sender: Any) {
        guard let sourceImage = self.image.image else {
            return
        }
        ImageFilte().applyFilter(to: sourceImage)
            .subscribe { filterdIMage in
                DispatchQueue.main.async {
                    self.image.image = filterdIMage
                }
            }.disposed(by: disposeBag)
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
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
        }.disposed(by: disposeBag)
    }
    
    private func updateUI(with image: UIImage){
        self.image.image = image
        self.applyFilterBtn.isHidden = false
    }
    
}
