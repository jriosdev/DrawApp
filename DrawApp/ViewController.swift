//
//  ViewController.swift
//  DrawApp
//
//  Created by iMac on 11/22/18.
//  Copyright © 2018 jriosdev. All rights reserved.
//

import UIKit

class BasicDrawingViewController: UIViewController {
    
    var lastPoint = CGPoint.zero
    var firstPoint = CGPoint.zero
    var paintColor : UIColor = UIColor.yellow
    var lineWidth : CGFloat = 30
    var png :Data?
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var oterimage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rest(_ sender: UIButton) {
        imageView.image = nil
        oterimage.mask = imageView
    }
    @IBAction func save(_ sender: Any) {
       
       var image = takeScreenshot()
       png = image?.pngData()
        mainImage.image = UIImage(data: png!)
        print(mainImage.image?.size)
    }
    func takeScreenshot() -> UIImage? {
        
        // Begin context
     //   UIGraphicsBeginImageContextWithOptions(oterimage.bounds.size, false, UIScreen.mainScreen().scale)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), false, 1)
        // Draw view in that context
        //drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        oterimage.drawHierarchy(in: oterimage.bounds, afterScreenUpdates: false)
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    @IBAction func share(_ sender: UIButton) {
        let activityItem: [AnyObject] = [png as! AnyObject]
        
        let avc = UIActivityViewController(activityItems: activityItem as [AnyObject], applicationActivities: nil)
        
        self.present(avc, animated: true, completion: nil)
    }
    
}
//Draw logic
extension BasicDrawingViewController{
    
    func drawBetweenPoints(point1:CGPoint,point2:CGPoint){
        UIGraphicsBeginImageContext(self.imageView.bounds.size)
        let context = UIGraphicsGetCurrentContext()
        
        self.imageView.image?.draw(in: self.imageView.bounds)
        context?.move(to: point1)
        context?.addLine(to: point2)
        context?.setLineCap(.round)
        context?.setStrokeColor(self.paintColor.cgColor)
        context?.setLineWidth(lineWidth)
        context?.strokePath()
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugPrint("Began")
        if let touch = touches.first{
            let point = touch.location(in: self.imageView)
            self.firstPoint = point
            self.drawBetweenPoints(point1: point, point2: point)
            self.lastPoint = point
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugPrint("Move")
        if let touch = touches.first{
            let newPoint = touch.location(in: self.imageView)
            self.drawBetweenPoints(point1: self.lastPoint, point2: newPoint)
            self.lastPoint = newPoint
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        debugPrint("Ended")
        if let touch = touches.first{
            let point = touch.location(in: self.imageView)
            //self.drawBetweenPoints(point1: point, point2: self.firstPoint)
            maskimage()
            debugPrint(point)
        }
    }
    
    func maskimage(){
//        oterimage.contentMode = .scaleAspectFit
//        imageView.contentMode = .scaleAspectFit
//       oterimage.image = mainImage.image
//
//        oterimage.mask = imageView
        //oterimage.frame = mainImage.bounds
        oterimage.image = mainImage.image
        var IMage = imageView
        imageView.frame = oterimage.bounds
        oterimage.mask = IMage
    }
    
    
}
