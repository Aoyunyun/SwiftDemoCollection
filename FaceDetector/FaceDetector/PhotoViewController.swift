//
//  PhotoViewController.swift
//  FaceDetector
//
//  Created by ayy on 2017/5/16.
//  Copyright © 2017年 aoyy. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoImageView: UIImageView!
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
    }
    
    //开始识别
    @IBAction func startFaceDetector(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "选取图片", preferredStyle: .actionSheet)

        let action1 = UIAlertAction(title: "拍照", style: .default) { (UIAlertAction) in
            self.takePhoto()
        }
        let action2 = UIAlertAction(title: "从相册选择", style: .default) { (UIAlertAction) in
            self.readPhotoAlbum()
        }
        let action3 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        
        present(alert, animated: true, completion: nil)
    }

    
    func takePhoto() {
        //如果没有相机
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            return
        }
        imagePicker.isEditing = false
        imagePicker.sourceType = .camera
        
        //展示拍照界面
        present(imagePicker, animated: true, completion: nil)
    }
    
    func readPhotoAlbum() {
        //如果没有相机
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            return
        }
        imagePicker.isEditing = false
        imagePicker.sourceType = .photoLibrary
        
        //展示拍照界面
        present(imagePicker, animated: true, completion: nil)
    }
    
    //人脸识别
    func delectorFace() {
        
        //将图片转换为CIImage
        let personciImage = CIImage(cgImage: photoImageView.image!.cgImage!)
        //设置精度
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh] //这是一个Dictionary
        //实例化一个faceDetector
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        //设置一个方向 an integer NSNumber from 1..8
        let option = [CIDetectorImageOrientation : NSNumber(value:5)]
        let faces = faceDetector?.features(in: personciImage, options: option)
        
        //将Core Image坐标转换为UIVIew坐标
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        
        
        for face in faces as! [CIFaceFeature] {
            print("found face are \(face.bounds)")
            
            
            /**
             关于feature中的position需要注意的是:
             position是以所要识别图像的原始尺寸为标准；
             因此，
             如果装载图片的UIImageView的尺寸与图片原始尺寸不一样的话，会出现识别的位置有偏差。
             */
            
            var faceViewBounds = face.bounds.applying(transform)
            // 计算实际的位置和大小 需要对图片的scaleAspectFit 进行处理
            let viewSize = photoImageView.bounds.size
            let scale = min(viewSize.width / ciImageSize.width,
                            viewSize.height / ciImageSize.height)
            let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
            let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
            
            faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
            faceViewBounds.origin.x += offsetX
            faceViewBounds.origin.y += offsetY
            
            let faceBox = UIView(frame: faceViewBounds)
            
            faceBox.layer.borderWidth = 3
            faceBox.layer.borderColor = UIColor.red.cgColor
            faceBox.backgroundColor = UIColor.clear
            photoImageView.addSubview(faceBox)
            
            if face.hasLeftEyePosition {
                print("Left eye bounds are \(face.leftEyePosition)")
            }
            
            if face.hasRightEyePosition {
                print("Right eye bounds are \(face.rightEyePosition)")
            }
        }

    }
        

    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        /*
         public let UIImagePickerControllerMediaType: String // an NSString (UTI, i.e. kUTTypeImage)
         public let UIImagePickerControllerOriginalImage: String // a UIImage
         public let UIImagePickerControllerEditedImage: String // a UIImage
         public let UIImagePickerControllerCropRect: String // an NSValue (CGRect)
         public let UIImagePickerControllerMediaURL: String // an NSURL
        */
        //拍照完成，取出拍照的图片显示
        //从相册选择图片完成
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoImageView.contentMode = .scaleAspectFit
            photoImageView.image = pickedImage
        }
      
        dismiss(animated: true, completion: nil)
        
        //人脸识别（Core Image）
        self.delectorFace()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
