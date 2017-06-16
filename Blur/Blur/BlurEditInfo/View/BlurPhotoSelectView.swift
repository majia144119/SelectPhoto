//
//  BlurPhotoSelectView.swift
//  Blur
//
//  Created by 马嘉 on 2017/6/15.
//  Copyright © 2017年 马嘉. All rights reserved.
//

import UIKit
private let mainPhotoHeight = 100
private let mainPhotoWidth = 100
private let scale = UIScreen.main.bounds.size.height/667
class BlurPhotoSelectView: UIView {
    var topRedView = UIView()
    var topPhotoLabel = UILabel()
    var buttonClick:((Int) -> ())?
    var imageClick:((Int) -> ())?
    var imgaeArray = NSMutableArray()
    var imageTag = Int()
    override init(frame: CGRect) {
        super.init(frame: frame)
       imgaeArray = ["","","","","",""]
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name(rawValue: "imagePick"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteData), name: NSNotification.Name(rawValue: "imageDelete"), object: nil)
        self.creatImageView()
        
    }
    func creatImageView() {
        self.backgroundColor = UIColor.withHex(hexInt: 0xdcdcdc, alpha: 1.0)
        topRedView = UIView.init(frame: CGRect.init(x:10, y: 10, width: 220*scale, height: 40))
        topRedView.backgroundColor = UIColor.withHex(hexInt: 0xFF7F50, alpha: 1.0)
        topRedView.layer.cornerRadius = 10
        topRedView.layer.masksToBounds = true
        self.addSubview(topRedView)
        topPhotoLabel = UILabel.init(frame: CGRect.init(x: 20, y: 10, width: 180*scale, height: 30))
        topPhotoLabel.text = "Top Photo"
        topPhotoLabel.textColor = UIColor.white
        topPhotoLabel.backgroundColor = UIColor.withHex(hexInt: 0xFF7F50, alpha: 1.0);        topPhotoLabel.textAlignment = .center
        topPhotoLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(topPhotoLabel)
        
      
        self.photoItemWithFrame(itemX: 10, itemY: topRedView.frame.maxY-10, itemWidth: 220*scale, itemHeight: 220*scale,tag: 0)
        self.photoItemWithFrame(itemX: 10, itemY: 280*scale, itemWidth: 105*scale, itemHeight: 105*scale,tag: 3)
        self.photoItemWithFrame(itemX: 245*scale, itemY: 10, itemWidth: 105*scale, itemHeight: 105*scale,tag: 1)
        self.photoItemWithFrame(itemX: 245*scale, itemY: 145*scale, itemWidth: 105*scale, itemHeight: 105*scale,tag: 2)
        self.photoItemWithFrame(itemX: 245*scale, itemY: 280*scale, itemWidth: 105*scale, itemHeight: 105*scale,tag: 5)
        self.photoItemWithFrame(itemX: 130*scale, itemY: 280*scale, itemWidth: 105*scale, itemHeight: 105*scale,tag: 4)
    }
    func removeImageView() {
        self.removeFromSuperview()
    }
    func photoItemWithFrame(itemX:CGFloat,itemY:CGFloat,itemWidth:CGFloat,itemHeight:CGFloat,tag:Int){
        var mainPhotoImageView = UIImageView()
        var selectButton = UIButton()
        var circleView = UIView()
        mainPhotoImageView = UIImageView.init()
        mainPhotoImageView.mjTag = tag
        
        mainPhotoImageView.frame = CGRect.init(x:itemX, y: itemY, width: itemWidth, height: itemHeight)
        mainPhotoImageView.layer.cornerRadius = 10
        mainPhotoImageView.layer.masksToBounds = true
        if imgaeArray.object(at: tag) as! String != "" {
            
            mainPhotoImageView.image = UIImage.init(contentsOfFile: imgaeArray.object(at: tag) as! String)
            mainPhotoImageView.isUserInteractionEnabled = true
            

            let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
            mainPhotoImageView.addGestureRecognizer(tapGR)
        }
        mainPhotoImageView.backgroundColor = UIColor.withHex(hexInt: 0xf5f5f5, alpha: 1.0)
            self.addSubview(mainPhotoImageView)
        circleView = UIView.init()
        selectButton = UIButton.init()
        selectButton.tag = tag
        selectButton.frame = CGRect.init(x: mainPhotoImageView.frame.maxX-24, y: mainPhotoImageView.frame.maxY-24, width: 24, height: 24)
        selectButton.layer.cornerRadius = 12;
        selectButton.layer.masksToBounds = true
         if imgaeArray.object(at: tag) as! String != "" {
           selectButton.setImage(UIImage.init(named: "delet"), for: .normal)
         }else{
           selectButton.setImage(UIImage.init(named: "add"), for: .normal)
        }
     
        selectButton.addTarget(self, action: #selector(clickSelectButton(sender:)), for: .touchUpInside)
        
        circleView.center = CGPoint.init(x: selectButton.center.x, y: selectButton.center.y)
        circleView.bounds.size = CGSize.init(width: 40, height: 40)
        circleView.backgroundColor = UIColor.withHex(hexInt: 0xdcdcdc, alpha: 1.0)
        circleView.layer.masksToBounds = true
        circleView.layer.cornerRadius = 20
        self.addSubview(circleView)
        self.addSubview(selectButton)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect, for formatter: UIViewPrintFormatter) {
        
    }
    func tapHandler(sender:UIImageView) {
        if imageClick != nil {
            imageClick!(imageTag)
        }
        
    }
    func clickSelectButton(sender:UIButton) {
    if buttonClick != nil {
        buttonClick!(sender.tag)
    }
    
    }
    func refreshData(notification:NSNotification) {
        let dict = notification.userInfo as! NSMutableDictionary
        imgaeArray = dict.value(forKey: "image") as! NSMutableArray
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        self.creatImageView()
        
    }
    func deleteData(notification:NSNotification) {
        let dict = notification.userInfo as! NSMutableDictionary
        imgaeArray = dict.value(forKey: "image") as! NSMutableArray
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        self.creatImageView()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        
        let point = touch.location(in:self)
        let px = point.x
        let py = point.y
        if px>245&&py>280 {
            imageTag = 5
        }else if px>130&&py>280 {
            imageTag = 4
        }else if px>10&&py>280 {
            imageTag = 3
        }else if px>245&&py>145 {
            imageTag = 2
        }else if px>245&&py>10 {
            imageTag = 1
        }else if px>10&&py>10 {
            imageTag = 0
        }
        
    }
}

