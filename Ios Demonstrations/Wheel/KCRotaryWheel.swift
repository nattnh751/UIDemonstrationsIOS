//
//  KCRotaryWheel.swift
//  AppDataRoom
//
//  Created by Nathan Walsh on 1/4/19.
//

import UIKit
import Foundation
struct WheelItem {//struct or class
    var title: String
    var itemId: Int
}
protocol KCRotaryWheelProt {
  func drawWheel()->();
  func calculateDistanceFromCenter(point: CGPoint) -> CGFloat;
  func buildEvenSectors()->();
  func buildOddSectors()->();
}

class KCSector {
  var minValue :CGFloat?;
  var maxValue :CGFloat?;
  var midValue :CGFloat?;
  var titleView :UILabelX?;
  var imageView :UIImageView?;
  var categoryId :CGFloat?;
  var sector :Int?;
  var id :Int?
}

class KCRotaryWheel: UIControl,KCRotaryWheelProt {
  var delegate :KCRotaryProtocol? = nil;
  var container :UIView? = nil;
  var numberOfSections :Int? = 4;
  var isDragging :Bool = false;
  @objc var categoryWasClicked: (_ itemId: Int) -> Void = {_ in };
  static let widthOfImageViewPad: CGFloat = 280.0;
  static let widthOfBackgroundViewItemPad: CGFloat = 455.0;
  static let constantForRotatedImagePad: CGFloat = 193.0;
  static let widthOfImageViewPhone: CGFloat = 175;
  static let widthOfBackgroundViewItemPhone: CGFloat = 284.37;
  static let constantForRotatedImagePhone: CGFloat = 193.0;
  var startTrasnform :CGAffineTransform?;
  var deltaAngle :CGFloat?;
  var categoryList :NSArray?;
  var sectors: NSMutableArray?;
  var hiddenCategories: NSMutableArray?;
  var shownCategories: NSMutableArray?;
  var pointsRunning: NSMutableArray?;
  var currentSector: Int? = 0;
  var hiddenSector: Int? = 1;

  
  init(frame:CGRect, sectionsNumber:Int, categories:NSArray) {
    self.numberOfSections = sectionsNumber;
    self.categoryList = categories;
    super.init(frame: frame)
    self.drawWheel();
  }
  
  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  @objc func resetWheel() {
    for v in self.subviews {
      v.removeFromSuperview();
    }
    currentSector = 0;
    hiddenSector = 0;
    self.drawWheel();
  }
  
  func calculateDistanceFromCenter(point: CGPoint) -> CGFloat {
    let center = CGPoint(x:self.bounds.size.width/2,y:self.bounds.size.height/2);
    let dx = point.x - center.x;
    let dy = point.y - center.y;
    return sqrt(dx*dx + dy*dy);
  }
  
  func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
    //Calculate the size of the rotated view's containing box for our drawing space
    let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
    let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
    rotatedViewBox.transform = t
    let rotatedSize: CGSize = rotatedViewBox.frame.size
    //Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize)
    let bitmap: CGContext = UIGraphicsGetCurrentContext()!
    //Move the origin to the middle of the image so we will rotate and scale around the center.
    bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
    //Rotate the image context
    bitmap.rotate(by: (degrees * CGFloat.pi / 180))
    //Now, draw the rotated/scaled image into the context
    bitmap.scaleBy(x: 1.0, y: -1.0)
    bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }
  
  func drawWheel() ->() {
    container = UIView(frame: self.frame);
    let numberOfSects = numberOfSections ?? 4;
    sectors = NSMutableArray(capacity: numberOfSects);
    pointsRunning = NSMutableArray();
    shownCategories = NSMutableArray();
    hiddenCategories = NSMutableArray();
    if numberOfSects%2==0 {
      self.buildEvenSectors();
    } else {
      self.buildOddSectors();
    }
    let angleSize: CGFloat = CGFloat(2*Double.pi)/CGFloat(numberOfSects);
    let fanWidth: CGFloat = (CGFloat(2*Double.pi)/CGFloat(numberOfSects))*((container?.bounds.size.width)!/2.0);
    var widthOfImageView: CGFloat = KCRotaryWheel.widthOfImageViewPad;
    var widthOfBackgroundViewItem: CGFloat = KCRotaryWheel.widthOfBackgroundViewItemPad;
    var constantForRotatedImage: CGFloat = KCRotaryWheel.constantForRotatedImagePad;
    var constantForLabelWH: CGFloat = 320;
    var constantForLabelY: CGFloat = -90;
    var constantForLabelX: CGFloat = 70;
    var fontSize: CGFloat = 18.0;
    var constantForMaxWidthPerLine: CGFloat = fanWidth/2 - 40;
    if (UIDevice.current.userInterfaceIdiom == .phone){
      widthOfImageView = KCRotaryWheel.widthOfImageViewPhone;
      widthOfBackgroundViewItem = KCRotaryWheel.widthOfBackgroundViewItemPhone;
      constantForRotatedImage = KCRotaryWheel.constantForRotatedImagePhone;
      constantForLabelWH = constantForLabelWH/1.6;
      constantForLabelY = constantForLabelY/1.6;
      constantForLabelX = constantForLabelX/1.6;
      constantForMaxWidthPerLine = constantForMaxWidthPerLine*2.8
      fontSize = 9.0;
    }
    for n in 0..<numberOfSects {
      var rotatedPhoto = UIImage(named:"sixItemCircleArrow");
      rotatedPhoto = self.imageRotatedByDegrees(oldImage: rotatedPhoto!, deg: constantForRotatedImage);
      let backgroundOfItem = UIView(frame: CGRect(x:0,y:0,width:widthOfBackgroundViewItem,height:fanWidth));
      backgroundOfItem.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5);
      backgroundOfItem.layer.position = CGPoint(x:(container?.bounds.size.width)!/2.0, y: (container?.bounds.size.height)!/2.0);
      backgroundOfItem.transform = CGAffineTransform(rotationAngle: angleSize*CGFloat(n));
      backgroundOfItem.tag = n;
      let imageView = UIImageView(image:rotatedPhoto);
      imageView.frame = CGRect(x:0,y:0,width:widthOfImageView,height:fanWidth);
      imageView.layer.position = CGPoint(x: (container?.bounds.size.width)!/2.0, y: (container?.bounds.size.height)!/2.0);
      imageView.contentMode = UIView.ContentMode.scaleAspectFit;
      let curveLabel = UILabelX(frame: CGRect(x:constantForLabelX,y:constantForLabelY,width:constantForLabelWH,height: constantForLabelWH));
      if(self.categoryList != nil && self.categoryList!.count >= numberOfSects) {
        let cat = self.categoryList?.object(at: n) as! WheelItem;
        shownCategories!.add(cat);
        curveLabel.text = cat.title.replacingOccurrences(of: "&", with: "\n&");
        (sectors?.object(at: n) as! KCSector).id = Int(cat.itemId);
      }
      curveLabel.angle = -140;
      curveLabel.maxWidthPerLine = constantForMaxWidthPerLine;
      curveLabel.clockwise = true;
      curveLabel.font = UIFont.systemFont(ofSize: fontSize);
      curveLabel.draw(CGRect(x:0,y:0,width:widthOfImageView,height: fanWidth));
//      let paragraphStyle = NSMutableParagraphStyle();
//      paragraphStyle.lineSpacing = 5;
//      let attrString = NSMutableAttributedString(string: curveLabel.text ?? "");
//      attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length));
//      curveLabel.attributedStringValue = attrString;
      (sectors?.object(at: n) as! KCSector).titleView = curveLabel;
      (sectors?.object(at: n) as! KCSector).imageView = imageView;
      imageView.addSubview(curveLabel);
      backgroundOfItem.addSubview(imageView);
      container?.addSubview(backgroundOfItem);
      
    }
    for category in self.categoryList! {
      let temp :WheelItem = category as! WheelItem;
      if(!(shownCategories?.contains(temp))!) {
        hiddenCategories!.add(temp);
        print("shown hidden \(String(describing: temp.title))");
      }
    }
    container!.isUserInteractionEnabled = false;
    self.addSubview(container!);
  }
  

  func buildEvenSectors() {
    let numberOfSects = numberOfSections ?? 4;
    let fanWidth: CGFloat = CGFloat(2*Double.pi)/CGFloat(numberOfSects);
    var mid :CGFloat = 0;
    for n in 0..<numberOfSects {
      let sect: KCSector = KCSector();
      sect.midValue = mid;
      sect.minValue = mid - (fanWidth/CGFloat(2));
      sect.maxValue = mid + (fanWidth/CGFloat(2));
      sect.sector = n;
      if(Double(sect.maxValue! - fanWidth) < -Double.pi) {
        mid = CGFloat(Double.pi);
        sect.midValue = mid;
        sect.minValue = CGFloat(fabsf(Float(sect.maxValue!)));
      }
      mid -= fanWidth;
      sectors?.add(sect);
    }
  }
  
  func buildOddSectors() {
    let numberOfSects = numberOfSections ?? 4;
    let fanWidth: CGFloat = CGFloat(2*Double.pi)/CGFloat(numberOfSects);
    var mid :CGFloat = 0;
    for n in 0..<numberOfSects {
      let sect: KCSector = KCSector();
      sect.midValue = mid;
      sect.minValue = mid - (fanWidth/CGFloat(2));
      sect.maxValue = mid + (fanWidth/CGFloat(2));
      sect.sector = n;
      mid -= fanWidth;
      if(Double(sect.minValue!) < -Double.pi) {
        mid = -mid;
        mid -= fanWidth;
      }
      sectors?.add(sect);
    }
  }
  open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    let touchPoint = touch.location(in: self);
    let dist = calculateDistanceFromCenter(point: touchPoint);
    pointsRunning = NSMutableArray();
    if dist<50 || dist>300 {
      //touch to close to center, this makes it much smoother
      return false;
    }
    let dx = touchPoint.x - (container?.center.x)!;
    let dy = touchPoint.y - (container?.center.y)!;
    deltaAngle = atan2(dx,dy);
    startTrasnform = container?.transform;
    self.isDragging = false;
    return true;
  }
  open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    let touchPoint = touch.location(in: self);
    pointsRunning?.add(touchPoint);
    let dx = touchPoint.x - (container?.center.x)!;
    let dy = touchPoint.y - (container?.center.y)!;
    let ang = atan2(dx,dy);
    let angleDiff = deltaAngle! - ang;
    if(sqrt(angleDiff * angleDiff) > 0.15) {
      self.isDragging = true;
      if((pointsRunning?.count)! > 15 && (hiddenCategories?.count)! > 0) {
        numberOfWheelTicksHappened(clockwise: clockOrientation());
        pointsRunning?.removeObject(at: 0);
      }
    }
    container?.transform = (startTrasnform?.rotated(by: angleDiff))!;
    return true;
  }
  
  func clockOrientation() -> Bool {
    var val :Int = 0;
    let first = pointsRunning?.firstObject as! CGPoint;
    let second = pointsRunning?.object(at:pointsRunning!.count/2) as! CGPoint;
    let third = pointsRunning?.object(at:pointsRunning!.count-1) as! CGPoint;
    if((first != nil)&&(second != nil)&&(third != nil)) {
      let exp1 :Int = (Int(second.y - first.y));
      let exp2 :Int = (Int(third.x - second.x));
      let exp3 :Int = (Int(second.x - first.x));
      let exp4 :Int = (Int(third.y - second.y));

      val = (exp1 * exp2) - (exp3 * exp4);
    }
    if(val >= 0) {
      return false;
    }
    return true;
  }
  
  func numberOfWheelTicksHappened(clockwise :Bool) {
    let radians :CGFloat = CGFloat(atan2f(Float(container!.transform.b),Float(container!.transform.a)));
    var diodChange :Bool = false;
    var spotChange :Int = 0;
    for sect in sectors! {
      let temp :KCSector = sect as! KCSector;
      if temp.minValue! > 0 && temp.maxValue! < 0 {
        if temp.minValue! < radians || temp.maxValue! > radians {
          if(hiddenSector != ((temp.sector! + spotChange) % numberOfSections!)) {
            diodChange = true;
            hiddenSector = (temp.sector! + spotChange) % numberOfSections!;
          }
          break;
        }
      } else {
        if radians > temp.minValue! && radians < temp.maxValue! {
          if(hiddenSector != ((temp.sector! + spotChange) % numberOfSections!)) {
            diodChange = true;
            hiddenSector = (temp.sector! + spotChange) % numberOfSections!;
          }
          break;
        }
      }
    }
    if(diodChange) {
      if(!clockwise) {
        print("counterclockwise");
        let catToAddToShown = hiddenCategories?.object(at:0) as! WheelItem;
        hiddenCategories?.remove(catToAddToShown);
        shownCategories?.add(catToAddToShown);
        for category in shownCategories! {
          let temp :WheelItem = category as! WheelItem;
          if(Int(temp.itemId)  == (sectors?.object(at: hiddenSector!) as! KCSector).id) {
            shownCategories?.remove(temp);
            hiddenCategories?.add(temp);
          }
        }
        (sectors?.object(at: hiddenSector!) as! KCSector).titleView!.text = catToAddToShown.title.replacingOccurrences(of: "&", with: "\n&");
        (sectors?.object(at: hiddenSector!) as! KCSector).id = Int(catToAddToShown.itemId);
      } else {
        print("clockwise");
        let catToAddToShown = hiddenCategories?.lastObject as! WheelItem;
        hiddenCategories?.remove(catToAddToShown);
        shownCategories?.add(catToAddToShown);
        for category in shownCategories! {
          let temp :WheelItem = category as! WheelItem;
          if(Int(temp.itemId) == (sectors?.object(at: hiddenSector!) as! KCSector).id) {
            shownCategories?.remove(temp);
            hiddenCategories?.insert(temp, at:0);
          }
        }
        (sectors?.object(at: hiddenSector!) as! KCSector).titleView!.text = catToAddToShown.title.replacingOccurrences(of: "&", with: "\n&");
        (sectors?.object(at: hiddenSector!) as! KCSector).id = Int(catToAddToShown.itemId);
      }
    }
  }
  
  open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    if(!self.isDragging) {
      let touchPoint = touch!.location(in: self);
      let deltaX = touchPoint.x - (container?.bounds.size.width)!/2.0;
      let deltaY = (container?.bounds.size.height)!/2.0 - touchPoint.y;
      let rad = atan2(deltaX,deltaY);
      print("angle angle angle \(String(describing: rad))");
      if (UIDevice.current.userInterfaceIdiom == .phone){
        touchHappenedForPhone(rad);
      } else {
        touchHappenedForPad(rad);
      }
    } else {
      self.isDragging = false;
      var diodChange :Bool = false;
      let radians :CGFloat = CGFloat(atan2f(Float(container!.transform.b),Float(container!.transform.a)));
      var newVal: CGFloat = 0.0;
      for sect in sectors! {
        let temp :KCSector = sect as! KCSector;
        if temp.minValue! > 0 && temp.maxValue! < 0 {
          if temp.minValue! < radians || temp.maxValue! > radians {
            if radians > 0 {
              newVal = radians - CGFloat(Double.pi);
            } else {
              newVal = radians + CGFloat(Double.pi);
            }
            if(currentSector != temp.sector!) {
              diodChange = true;
            }
            currentSector = temp.sector!;
            break;
          }
        } else {
          if radians > temp.minValue! && radians < temp.maxValue! {
            newVal = radians - temp.midValue!;
            if(currentSector != temp.sector!) {
              diodChange = true;
            }
            currentSector = temp.sector!;
            break;
          }
        }
      }
      UIView.beginAnimations(nil, context:nil);
      UIView.setAnimationDuration(0.2);
      let trans : CGAffineTransform = (container?.transform)!;
      container?.transform = trans.rotated(by: -newVal);
      UIView.commitAnimations();
    }
  }
  func touchHappenedForPhone(_ rad: CGFloat) {
    let konecranesRed = UIColor(hexString: "#f71c1c");

    if(rad < -0.9799699625125031 && rad > -1.666065545776901) {
      var tester = currentSector! + 1;
      if (tester >= sectors!.count) {
        tester = tester % sectors!.count;
      }
      for sect in sectors! {
        let temp :KCSector = sect as! KCSector;
        if temp.sector == tester {
          temp.imageView?.image = temp.imageView?.image?.withTintColor(konecranesRed ?? .red);
          categoryWasClicked(temp.id!);
        }
      }
    }
    if(rad > -0.6638800102616383 && rad < 0.4835488715871063) {
      var tester = currentSector! + 2;
      if (tester >= sectors!.count) {
        tester = tester % sectors!.count;
      }
      for sect in sectors! {
        let temp :KCSector = sect as! KCSector;
        if temp.sector == tester {
          temp.imageView?.image = temp.imageView?.image?.withTintColor(konecranesRed ?? .red);
          categoryWasClicked(temp.id!);
//          //            print("current sector name  + 1 \(String(describing: temp.titleView!.text))");
        }
      }
    }
    if(rad > 0.6882390402897498 && rad < 1.4612492869283396) {
      var tester = currentSector! + 3;
      if (tester >= sectors!.count) {
        tester = tester % sectors!.count;
      }
      for sect in sectors! {
        let temp :KCSector = sect as! KCSector;
        if temp.sector == tester {
          temp.imageView?.image = temp.imageView?.image?.withTintColor(konecranesRed ?? .red);
          categoryWasClicked(temp.id!);
        }
      }
    }
    if(rad > 1.4612492869283396 && rad < 1.6993649747437054) {
      var tester = currentSector! + 4;
      if (tester >= sectors!.count) {
        tester = tester % sectors!.count;
      }
      for sect in sectors! {
        let temp :KCSector = sect as! KCSector;
        if temp.sector == tester {
          temp.imageView?.image = temp.imageView?.image?.withTintColor(konecranesRed ?? .red)
          categoryWasClicked(temp.id!);
        }
      }
    }
  }
  
  func touchHappenedForPad(_ rad: CGFloat) {
    let konecranesRed = UIColor(hexString: "#f71c1c");
    if(rad < -0.058755822715722696 && rad > -0.8519663271732721) {
      var tester = currentSector! + 2;
      if (tester >= sectors!.count) {
        tester = tester % sectors!.count;
      }
      for sect in sectors! {
        let temp :KCSector = sect as! KCSector;
        if temp.sector == tester {
          temp.imageView?.image = temp.imageView?.image?.withTintColor(konecranesRed ?? .red)
          categoryWasClicked(temp.id!);
        }
      }
    }
    if(rad > 0.049191053944986914 && rad < 1.1378557862241525) {
      var tester = currentSector! + 3;
      if (tester >= sectors!.count) {
        tester = tester % sectors!.count;
      }
      for sect in sectors! {
        let temp :KCSector = sect as! KCSector;
        if temp.sector == tester {
          temp.imageView?.image = temp.imageView?.image?.withTintColor(konecranesRed ?? .red);
          categoryWasClicked(temp.id!);
        }
      }
    }
    if(rad < 2.7647938866072486 && rad > 1.5401936388661779) {
      var tester = currentSector! + 4;
      if (tester >= sectors!.count) {
        tester = tester % sectors!.count;
      }
      for sect in sectors! {
        let temp :KCSector = sect as! KCSector;
        if temp.sector == tester {
          temp.imageView?.image = temp.imageView?.image?.withTintColor(konecranesRed ?? .red)
          categoryWasClicked(temp.id!);
        }
      }
    }
    if(rad > -1.3712999296995805 && rad < -0.8797812726119757) {
      var tester = currentSector! + 1;
      if (tester >= sectors!.count) {
        tester = tester % sectors!.count;
      }
      for sect in sectors! {
        let temp :KCSector = sect as! KCSector;
        if temp.sector == tester {
          temp.imageView?.image = temp.imageView?.image?.withTintColor(konecranesRed ?? .red)
          categoryWasClicked(temp.id!)
        }
      }
    }
    if(rad > 2.7647938866072486 || (rad > -3.1309320766486484 && rad < -2.4657898588319624)) {
      var tester = currentSector! + 5;
      if (tester >= sectors!.count) {
        tester = tester % sectors!.count;
      }
      for sect in sectors! {
        let temp :KCSector = sect as! KCSector;
        if temp.sector == tester {
          temp.imageView?.image = temp.imageView?.image?.withTintColor(konecranesRed ?? .red);
          categoryWasClicked(temp.id!);
        }
      }
    }
  }
}
