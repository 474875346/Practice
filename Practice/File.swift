/*Swift 常用声明*/
import UIKit
import Foundation
import AVFoundation
import Photos
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
//let BaseURL = "http://gcm.systop.com.cn"
let BaseURL = "http://172.16.1.22:9000"
let deviceUUID = UIDevice.current.identifierForVendor?.uuidString
//取数据的key
let ZToken = "access_token"
let ZCollegeName = "CollegeName"
let ZLogInOut = "LogInOut"
let ZregistID = "registID"
let ZhaveBieMing = "haveBieMing"
let CompressionVideoPaht = "\(NSHomeDirectory())/Library/Viedo"
let Zlatitude = "latitude"
let Zlongitude = "longitude"
let Zrefresh_token = "refresh_token"
//颜色
func RGBA(_ r:Int,g:Int,b:Int,a:Float) -> UIColor {
    let R = Float(r)
    let G = Float(g)
    let B = Float(b)
    return UIColor.init(colorLiteralRed: R/255.0, green: G/255.0, blue: B/255.0, alpha: a)
}
//转换CGFloat
func ConversionCGFloat ( _ integer : Int) -> CGFloat {
    return (CGFloat(integer))
}
//X大小
func X(_ view:UIView) -> CGFloat {
    return view.frame.origin.x
}
//Y大小
func Y(_ view:UIView) -> CGFloat {
    return view.frame.origin.y
}
//宽大小
func W(_ view:UIView) -> CGFloat {
    return view.frame.size.width
}
//高大小
func H(_ view:UIView) -> CGFloat {
    return view.frame.size.height
}
//X+宽大小
func XW(_ view:UIView) -> CGFloat {
    return view.frame.origin.x+view.frame.size.width
}
//Y+高大小
func YH(_ view:UIView) -> CGFloat {
    return view.frame.origin.y+view.frame.size.height
}
//存数据
func UserDefaultSave(_ Key:String,Value:String?) {
    UserDefaults().set(Value, forKey: Key)
}
//取数据
func UserDefauTake(_ Key:String) -> String? {
    return UserDefaults().object(forKey: Key) as! String?
}
//删除数据
func UserDefaultRemove(_ Key:String) {
    UserDefaults().removeObject(forKey: Key)
}
//边框
func LRViewBorderRadius(_ view:UIView,Radius:CGFloat,Width:CGFloat,Color:UIColor) {
    view.layer.cornerRadius=Radius
    view.layer.masksToBounds=true
    view.layer.borderWidth=Width
    view.layer.borderColor=Color.cgColor
}
//获取当前时间
func CurrentDate() -> String {
    let date = NSDate()
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "yyy-MM-dd"
    let strNowTime = timeFormatter.string(from: date as Date) as String
    return strNowTime
}
//计算文字高度
func getAttributeSize(text : NSString ,fontSize:CGFloat,With:CGFloat) -> CGSize {
    let size = text.boundingRect(with: CGSize(width: With, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: fontSize)], context: nil).size
    return size
}
/**
 判断相机权限
 - returns: 有权限返回true，没权限返回false
 */
func cameraPermissions() -> Bool{
    
    let authStatus:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
    if(authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted) {
        return false
    }else {
        return true
    }
}
func audioSession() -> Bool? {
    let audioSession = AVAudioSession.sharedInstance()
    var isaudio : Bool?
    audioSession.requestRecordPermission({ (granted) in
        if (!granted) {
            isaudio = false
        } else {
            isaudio = true
        }
    })
    print(isaudio as Any)
    return isaudio!
}
/**
 判断相册权限
 - returns: 有权限返回ture， 没权限返回false
 */
func PhotoLibraryPermissions() -> Bool {
    let library:PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
    if(library == PHAuthorizationStatus.denied || library == PHAuthorizationStatus.restricted){
        return false
    }else {
        return true
    }
}
//UI工厂
class CreateUI {
    //标签
    class func Label( _ textColor : UIColor , backgroundColor : UIColor , title : String , frame : CGRect , font : Int) -> UILabel {
        let label = UILabel()
        label.textColor = textColor;
        label.backgroundColor = backgroundColor;
        label.text = title;
        label.frame = frame
        label.font =  UIFont.systemFont(ofSize: CGFloat(font))
        return label
    }
    //按钮
    class func Button(_ title:String, action:Selector, sender:UIViewController, frame : CGRect, backgroundColor : UIColor ,textColor : UIColor)->UIButton {
        let button = UIButton(frame: frame)
        button.backgroundColor = backgroundColor
        button.setTitle(title, for:.normal)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(sender, action:action, for:UIControlEvents.touchUpInside)
        return button
    }
    //文本框
    class func TextField( _ placeholder:String, action:Selector, delegate:UITextFieldDelegate , frame : CGRect , backgroundColor : UIColor , textColor : UIColor, sender:UIViewController) -> UITextField {
        let textField = UITextField(frame: frame)
        textField.backgroundColor = backgroundColor
        textField.textColor = textColor
        textField.placeholder = placeholder
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.adjustsFontSizeToFitWidth = true
        textField.delegate = delegate
        textField.addTarget(sender, action: action, for: .editingChanged)
        return textField
    }
    //分段
    class func Segment(_ items: [String], action:Selector, sender:UIViewController,frame : CGRect) ->UISegmentedControl {
        let segment = UISegmentedControl(items:items)
        segment.frame = frame
        segment.isMomentary = false
        segment.addTarget(sender, action:action, for:UIControlEvents.valueChanged)
        return segment
    }
    //表格
    class func TableView(_ delegate : UITableViewDelegate , dataSource : UITableViewDataSource , frame : CGRect , style : UITableViewStyle) -> UITableView {
        let  tableview = UITableView(frame: frame, style: style)
        tableview.delegate = delegate
        tableview.dataSource = dataSource
        return tableview
    }
}
