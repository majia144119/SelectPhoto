//
//  BlurEnditInfoViewController.swift
//  Blur
//
//  Created by 马嘉 on 2017/6/15.
//  Copyright © 2017年 马嘉. All rights reserved.
//

import UIKit
private let SCREEN_WIDTH = UIScreen.main.bounds.width
private let SCREEN_HEIGHT = UIScreen.main.bounds.height
private let scale = UIScreen.main.bounds.size.height/667

class BlurEditInfoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var clickIndex:Int = 0
     var bottomView = UIView()
    var filePath:String = String()
    var imageArray:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageArray = NSMutableArray.init()
        imageArray = ["","","","","",""]
        view.backgroundColor = UIColor.white
        self.title = "Edit Info"
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        let doneButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 18))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.brown, for: .normal)
        let barDoneButton = UIBarButtonItem(customView: doneButton)
        self.navigationItem.rightBarButtonItem = barDoneButton
        self.edgesForExtendedLayout = .init(rawValue: 0);

        self.creatTopPhotoSelect()
    }

    func creatTopPhotoSelect() {
        let topView = BlurPhotoSelectView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 410*scale))
        topView.buttonClick = {(index:Int)->() in
            print(index)
        self.clickIndex = index
        self.selectPhoto()
        }
        topView.imageClick = {(index:Int)->() in
        self.showBottomView(imageTag: index)
        }
        view.addSubview(topView)
        var smartLabel = UILabel()
        smartLabel = UILabel.init(frame: CGRect.init(x:25, y: topView.frame.maxY+15, width: 200, height: 20*scale))
        smartLabel.text = "Smart Photos"
        smartLabel.font = UIFont.systemFont(ofSize: 20)
        smartLabel.textColor = UIColor.withHex(hexInt: 0xFF4500	, alpha: 1.0)
        smartLabel.textAlignment = .left
        view.addSubview(smartLabel)
        var smartSwitch = UISwitch()
        smartSwitch = UISwitch.init()
        smartSwitch.frame = CGRect.init(x: SCREEN_WIDTH-80, y: topView.frame.maxY+8, width: 60, height: 30*scale)
        smartSwitch.isSelected = true
        view.addSubview(smartSwitch)
        var descriptionView = UIView()
        descriptionView = UIView.init(frame:CGRect.init(x: 0, y: smartLabel.frame.maxY+13, width: SCREEN_WIDTH, height: 100*scale))
        descriptionView.backgroundColor = UIColor.withHex(hexInt: 0xdcdcdc, alpha: 1.0)
        view.addSubview(descriptionView)
        var descriptionLabel = UILabel()
        descriptionLabel = UILabel.init(frame: CGRect.init(x: 25, y: 8, width: SCREEN_WIDTH-50, height: 40))
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor.init(colorLiteralRed: 20, green: 20, blue: 20, alpha: 1)
        descriptionLabel.textAlignment = .left
      
        if UIScreen.main.bounds.size.height<667{
        
         descriptionLabel.text = "Smart Photos continuously tests all your profile photos and picks the best one to show first"
        }else{
          descriptionLabel.text = "Smart Photos continuously tests all your profile\n photos and picks the best one to show first"
        }
        descriptionLabel.numberOfLines = 0
        descriptionView.addSubview(descriptionLabel)
        
        var aboutLabel = UILabel()
        aboutLabel = UILabel.init(frame: CGRect.init(x: 25, y: descriptionLabel.frame.maxY+8, width: 200, height: 30))
        aboutLabel.text = "About Silu"
        aboutLabel.font = UIFont.boldSystemFont(ofSize: 18)
        aboutLabel.textAlignment = .left
        descriptionView.addSubview(aboutLabel)
        
        var lastLabel = UILabel()
        lastLabel = UILabel.init(frame: CGRect.init(x:25, y: descriptionView.frame.maxY+8*scale, width: SCREEN_WIDTH, height: 20))
        lastLabel.font = UIFont.systemFont(ofSize: 14)
        lastLabel.textAlignment = .left
        lastLabel.text = "I look forward to joining your team"
        lastLabel.textColor = UIColor.black
        view.addSubview(lastLabel)
    }
    
    func selectPhoto() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let picker = UIImagePickerController()

            picker.delegate = self

            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("erro")
        }
      
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
                let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        var fileManager = FileManager()
        fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        filePath = "\(rootPath)/"
        filePath = filePath+"pickImage" + String(clickIndex)+".jpg"
        
        let imageData = UIImageJPEGRepresentation(pickedImage, 1.0)
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)

        imageArray.removeObject(at: clickIndex)
        imageArray.insert(filePath, at: clickIndex)
        let dict = NSMutableDictionary()
        dict.setValue(imageArray, forKey: "image")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "imagePick"), object: nil, userInfo: dict as? [AnyHashable : Any])
                picker.dismiss(animated: true, completion:nil)
    }


        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showBottomView(imageTag:Int) {
      
        bottomView = UIView.init(frame: CGRect.init(x:0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 100))
        bottomView.backgroundColor = UIColor.green
        view.addSubview(bottomView)
        var buttonDelete = UIButton()
        buttonDelete = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 30))
        buttonDelete.setTitle("DELETE", for: .normal)
        buttonDelete.setTitleColor(UIColor.blue, for: .normal)
        buttonDelete.tag = imageTag
        buttonDelete.addTarget(self, action: #selector(deleteData(sender:)), for: .touchUpInside)
        buttonDelete.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        bottomView.addSubview(buttonDelete)
        var buttonCancel = UIButton()
        buttonCancel = UIButton.init(frame: CGRect.init(x: 0, y: 50, width: SCREEN_WIDTH, height: 30))
        buttonCancel.setTitle("CANCEL", for: .normal)
        buttonCancel.addTarget(self, action: #selector(cancelBottomView), for: .touchUpInside)
        buttonCancel.setTitleColor(UIColor.blue, for: .normal)
        buttonCancel.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        bottomView.addSubview(buttonCancel)
        UIView.animate(withDuration: 1.0) { 
           self.bottomView.frame = CGRect.init(x: 0, y: SCREEN_HEIGHT-150, width: SCREEN_WIDTH, height: 100)
        }
    }
    func cancelBottomView() {
        UIView.animate(withDuration: 1.0) {
           self.bottomView.removeFromSuperview()
        }
    }
    func deleteData(sender:UIButton) {
        UIView.animate(withDuration: 1.0) {
            self.bottomView.removeFromSuperview()
        }
        imageArray.removeObject(at: sender.tag)
        imageArray.add("")
        let dict = NSMutableDictionary()
        dict.setValue(imageArray, forKey: "image")
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "imageDelete"), object: nil, userInfo:  dict as? [AnyHashable : Any])
    
    }
   
}
