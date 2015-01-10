//
//  ViewController.swift
//  khmer
//
//  Created by Tran Huu Tam on 11/8/14.
//  Copyright (c) 2014 BenjaminSoft. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import WebKit

class ViewController: UIViewController, UIWebViewDelegate, UIGestureRecognizerDelegate, KeywordListViewControllerProtocol, WKScriptMessageHandler {

    // MARK: UI's elements
    @IBOutlet weak var adBanner: GADBannerView!
    
    @IBOutlet weak var historyViewContainer: UIView!
    @IBOutlet weak var contentOfSearchWeb: UIWebView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var bgTextFieldView: UIView!
    
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var changeLanguageButton: UIButton!
    @IBOutlet weak var notFoundLabel: UILabel!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    @IBOutlet weak var panView: UIView!
    @IBOutlet weak var wkContainerView: UIView!
    @IBOutlet weak var languageLabel: UILabel!
    
    // Layout
    @IBOutlet weak var topViewNotFoundConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftSpacingFieldBGConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightOfBannnerConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightImageScrollViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthHistoryContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftViewHistoryContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightOfSearchViewConstraint: NSLayoutConstraint!
    
    // MARK: Class's constructors
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.initialize();
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil);
        self.initialize();
    }
    
    
    // MARK: Class's properties
    var keyword = ""
    let imageHeightiPhone = 200
    let imageHeightiPad = 400
    var keyWordList = NSMutableArray()
    var historyView: KeywordListViewController?
    var isPanLeft: Bool = false
    var leftViewHistoryContainerConstraintD = 200
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
    }()
    var viewWebKit: WKWebView?
    
    
    // MARK: View's lifecycle
    override func viewDidLoad() {
        super.viewDidLoad();
        self.visualize();
        self.localize();
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated);
    }
    
    
    // MARK: View's memory handler
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    
    // MARK: View's orientation handler
    override func shouldAutorotate() -> Bool {
        return false;
    }
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue + UIInterfaceOrientationMask.PortraitUpsideDown.rawValue);
    }
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration);
    }
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation);
    }
    
    
    // MARK: View's transition event handler
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.destinationViewController.isKindOfClass(CalendarsListViewController)) {
//            
//        }
    }
    
    
    // MARK: View's key pressed event handlers
    @IBAction func keyPressed(sender: AnyObject) {
        if (sender as NSObject) == self.searchButton {
            doASearch()
//            self.performSegueWithIdentifier("ReservationWeekViewSegue", sender: self)
        }
        if (sender as NSObject) == self.changeLanguageButton {
            if languageLabel.text == "E" {
                languageLabel.text = otherLang
            }
            else {
                languageLabel.text = "E"
            }
            appUserPreference.setValue(languageLabel.text, withKey: languageKey)
            appUserPreference.save()
            changeLangueSetting()
        }
    }
    
    
    // MARK: Class's public methods
    
    
    // MARK: Class's private methods
    func initialize() {
        
    }
    
    func visualize() {
        //For testing
//        searchTextField.text = sampleOtherLanguage
        
        leftViewHistoryContainerConstraintD = (deviceIdidom == UIUserInterfaceIdiom.Pad) ? 400 : 200
        
        panView.layer.cornerRadius = 10.0
        panView.layer.masksToBounds = true
        
//        languageView.layer.cornerRadius = 10.0
//        languageView.layer.masksToBounds = true
        
        imagesScrollView.hidden = true
        
        bgTextFieldView.layer.cornerRadius = 10.0
        bgTextFieldView.layer.masksToBounds = true
        
        searchButton.layer.cornerRadius = 10.0
        searchButton.layer.masksToBounds = true
        
        notFoundLabel.layer.cornerRadius = notFoundLabel.frame.size.height/2
        notFoundLabel.layer.masksToBounds = true
        
        if deviceIdidom == UIUserInterfaceIdiom.Pad {
            heightOfSearchViewConstraint.constant = 75
            heightOfBannnerConstraint.constant = 75
            heightImageScrollViewConstraint.constant = 300
            widthHistoryContainerConstraint.constant = 400
            leftViewHistoryContainerConstraint.constant = -400
        }
        leftSpacingFieldBGConstraint.constant = bgTextFieldView.frame.size.height/2
        
        //WebKit
        var theConfiguration = WKWebViewConfiguration()
        theConfiguration.userContentController.addScriptMessageHandler(self,
            name: "interOp")
        viewWebKit = WKWebView(frame: wkContainerView.frame, configuration: theConfiguration)
//        println("\(viewWebKit?.frame)")
        viewWebKit?.backgroundColor = UIColor.clearColor()
        viewWebKit?.opaque = false
        view.insertSubview(viewWebKit!, aboveSubview: wkContainerView)
//        println("\(wkContainerView.frame)")
//        viewWebKit?.setTranslatesAutoresizingMaskIntoConstraints(false)
//        
//        let views = ["bannerView": adBanner, "scrollView": imagesScrollView, "viewWebKit": viewWebKit!]
//        
//        var constH = NSLayoutConstraint.constraintsWithVisualFormat ("H:|[viewWebKit]|", options: nil, metrics: nil, views: views)
//        view.addConstraints(constH)
//        var constV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]-10-[viewWebKit]-0-[bannerView]|", options: nil, metrics: nil, views: views)
//        view.addConstraints(constV)
        
        // IMPORTANT: Admob
        adBanner.adUnitID = adUnit
        adBanner.rootViewController = self
        var request: GADRequest = GADRequest ()
        request.testDevices = [GAD_SIMULATOR_ID]
        adBanner .loadRequest(request)
        // hide banner
//        heightOfBannnerConstraint.constant = 0
        
        var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanGesture:")) as UIPanGestureRecognizer
        panGesture.delegate = self
        panView.addGestureRecognizer(panGesture)
        
        var panGesture2: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanGesture:")) as UIPanGestureRecognizer
        panGesture2.delegate = self
        view.addGestureRecognizer(panGesture2)
        
        historyView = self.storyboard!.instantiateViewControllerWithIdentifier("KeywordListViewController") as? KeywordListViewController
        historyView?.view.frame = historyViewContainer!.bounds
        historyViewContainer?.addSubview(historyView!.view)
        historyView?.delegate = self
        
        historyView?.view.layer.cornerRadius = 10.0
        historyView?.view.layer.masksToBounds = true
        
        var keyWordListTemp = appUserPreference.objectForKey(keywordListKey) as? NSMutableArray
        if keyWordListTemp != nil {
            keyWordList = keyWordListTemp!
        }
        else {
            appUserPreference.setValue(keyWordList, withKey: keywordListKey)
            appUserPreference.save()
        }
        
        var languageCheck = appUserPreference.objectForKey(languageKey) as? String
        if languageCheck != nil {
            languageLabel.text = languageCheck
        }
        else {
            languageLabel.text = otherLang
            appUserPreference.setValue(otherLang, withKey: languageKey)
            appUserPreference.save()
        }
        changeLangueSetting()
        
        //skip iCloud backup
        KeywordEntity.skipThisEntityInBackup(managedObjectContext!)
    }
    
    func changeLangueSetting() {
        if languageLabel.text == "E" {
            searchButton.setTitle(searchTextOtherLang, forState: UIControlState.Normal)
        }
        else {
            searchButton.setTitle("Search", forState: UIControlState.Normal)
        }
    }
    
    func longPressToEditRoomName(gestureRe: UILongPressGestureRecognizer) {
        if gestureRe.state != UIGestureRecognizerState.Ended {

        }
    }
    
    func localize() {
        
    }
    
    func doASearch() {
        topViewNotFoundConstraint.constant = -50
        keyword = searchTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        updateFrameOfWebKit()
        //check if get from Database or Request
        var keywordE = KeywordEntity.getKeyword(managedObjectContext!, keyword: keyword)
        if keywordE != nil {
            //local Database
            if keywordE!.isEnglish {
                languageLabel.text = otherLang
            }
            else {
                languageLabel.text = "E"
            }
            changeLangueSetting()
            viewWebKit!.loadHTMLString(keywordE!.content, baseURL: NSURL(string: baseURL))
            startTimer(0.2, selectorInStr: "runJSForWebKit", rep: false)
            renderImagesFromDatabase(keywordE!.imageData)
            hideKeyBoard()
        }
        else {
            //get from Internet
            var urlSampleAction = "\(baseURL)/\(keyword)"
            if languageLabel.text == "E" {
                urlSampleAction = "\(otherBaseURL)/\(keyword)"
            }
            urlSampleAction = urlSampleAction.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            var request = HTTPTask()
            request.GET(urlSampleAction, parameters: ["param": 1], success: {(response: HTTPResponse) -> Void in
                if response.responseObject != nil {
                    var data = response.responseObject as NSData
                    var str = NSString(data: data, encoding: NSUTF8StringEncoding)
//                    println("\(str)")
                    self.contentOfSearchWeb.loadHTMLString(str, baseURL: NSURL(string: baseURL))
                    self.startTimer(1.0, selectorInStr: "runJS", rep: false)
                    
                }
                }, failure: {(error: NSError, response: HTTPResponse?) in
                    println("error: \(error)")
            })
        }
    }
    
    func updateFrameOfWebKit() {
//        println("\(wkContainerView.frame)")
        var frame = wkContainerView.frame
        viewWebKit?.frame = frame
//        println("\(viewWebKit?.frame)")
    }
    
    func runJS() {
        dispatch_async(dispatch_get_main_queue(), {
            self.runJSInMain()
        })
    }
    
    func runJSInMain() {
        var jsScript = ""
        var result = ""
        
        //clean content and apply CSS
        jsScript = ""
        jsScript = jsScript + "var a = document.getElementsByTagName('script'); "
        jsScript = jsScript + "while (a.length > 0) {a[a.length - 1].remove()};"
        result = contentOfSearchWeb.stringByEvaluatingJavaScriptFromString(jsScript)!
        
        jsScript = ""
        jsScript = jsScript + "var a = document.getElementsByTagName('li'); "
        jsScript = jsScript + "while (a.length > 0) {a[a.length - 1].remove()};"
        result = contentOfSearchWeb.stringByEvaluatingJavaScriptFromString(jsScript)!
        
        jsScript = ""
        jsScript = jsScript + "var a = document.getElementsByTagName('a'); "
        jsScript = jsScript + "while (a.length > 0) {a[a.length - 1].remove()};"
        result = contentOfSearchWeb.stringByEvaluatingJavaScriptFromString(jsScript)!
        
        jsScript = ""
        jsScript = jsScript + "var a = document.getElementsByClassName('result-right'); "
        jsScript = jsScript + "for(var i = 0; i < a.length ; i ++) {var b = a[i];b.style.color = 'white';b.style.backgroundColor = 'black';b.style.opacity= 0.6};"
        result = contentOfSearchWeb.stringByEvaluatingJavaScriptFromString(jsScript)!
        
        //Sentences
        jsScript = ""
        jsScript = jsScript + "var a = document.getElementsByClassName('section-block'); "
        jsScript = jsScript + "var a1 = [];"
        jsScript = jsScript + "for(var i = 0; i < a.length ; i ++) {var b = a[i];if(b.textContent.indexOf('Context sentences') > 0){a1.push(i)}}"
        jsScript = jsScript + "var c = a[a1[a1.length - 1]];"
        jsScript = jsScript + "c.getElementsByClassName('result-block')[0].innerHTML;"
        result = contentOfSearchWeb.stringByEvaluatingJavaScriptFromString(jsScript)!
        var divSentences = "<html><body>\(result)</body><html>"
        if countElements(divSentences) > 50 {
            topViewNotFoundConstraint.constant = -50
            viewWebKit!.loadHTMLString(divSentences, baseURL: NSURL(string: baseURL))
            startTimer(0.2, selectorInStr: "runJSForWebKit", rep: false)
            KeywordEntity.createInManagedObjectContext(managedObjectContext!, keyword: keyword, content: divSentences, isEnglish: !(languageLabel.text == "E"))
            managedObjectContext?.save(nil)
            getImages()
            hideKeyBoard()
        }
        else {
//            view.endEditing(true)
            UIView .animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: { () -> Void in
                
                }, completion: { (Bool) -> Void in
                    self.startTimer(1.0, selectorInStr: "runJS", rep: false)
                    self.topViewNotFoundConstraint.constant = self.view.bounds.height/2
            })
        }
    }
    
    func runJSForWebKitInMain() {
        var jsScript = ""
        var result = ""
        
        jsScript = ""
        if deviceIdidom == UIUserInterfaceIdiom.Pad {
            jsScript = jsScript + "document.body.style.fontSize = '2em'"
        } else {
            jsScript = jsScript + "document.body.style.fontSize = '2.5em'"
        }
        viewWebKit!.evaluateJavaScript(jsScript, completionHandler: nil)
        
        jsScript = ""
        jsScript = jsScript + "var a = document.getElementsByClassName('result-left');"
        jsScript = jsScript + "for(var i = 0; i < a.length ; i ++) {a[i].onclick = function(){var message = {'lang':'E', 'message': this.textContent}; window.webkit.messageHandlers.interOp.postMessage(message)};}"
        viewWebKit!.evaluateJavaScript(jsScript, completionHandler: nil)
    }
    
    func runJSForWebKit() {
        dispatch_async(dispatch_get_main_queue(), {
            self.runJSForWebKitInMain()
        })
    }
    
    func hideKeyBoard() {
        imagesScrollView.hidden = false
        view.endEditing(true)
        leftViewHistoryContainerConstraint.constant = -CGFloat(leftViewHistoryContainerConstraintD)
    }
    
    func getImages() {
        for view in imagesScrollView.subviews {
            if view is UIImageView {
                view.removeFromSuperview()
            }
        }
        var strLang = (languageLabel.text! == "E") ? otherLang : "E"
        keyWordList.addObject("\(keyword)-\(strLang)")
        appUserPreference.setValue(keyWordList, withKey: keywordListKey)
        appUserPreference.save()
        var request = HTTPTask()
        var keywordEncoding = keyword.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        request.GET(googleServiceImages, parameters: ["q": "\(keywordEncoding)"], success: {(response: HTTPResponse) -> Void in
            if response.responseObject != nil {
                var data = response.responseObject as NSData
                var str = NSString(data: data, encoding: NSUTF8StringEncoding)
//                println("\(str)")
                var jsonDic = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: nil) as NSDictionary
                var dataJS: NSDictionary? = jsonDic.objectForKey("responseData") as? NSDictionary
                if dataJS != nil {
                    var dataImages = dataJS?.objectForKey("results") as? NSArray
                    if dataImages != nil {
                        self.renderImages(dataImages!)
                    }
                }
            }
            }, failure: {(error: NSError, response: HTTPResponse?) in
                println("error: \(error)")
        })
    }
    
    func renderImages(dataImages: NSArray) {
        var arrayImages = NSMutableArray()
        var imageHeight = (deviceIdidom == UIUserInterfaceIdiom.Pad) ? imageHeightiPad : imageHeightiPhone
        var contentS = imagesScrollView.contentSize
        contentS.width = CGFloat(dataImages.count * (imageHeight + 20))
        contentS.height = heightImageScrollViewConstraint.constant
        imagesScrollView.contentSize = contentS
        var imageCountRun = 0
        for item in dataImages {
            var itemD = item as NSDictionary
            var imgageURL = itemD.objectForKey("url") as String
//            println("\(imgageURL)")
            var imgURL = NSURL(string: imgageURL)
            let request: NSURLRequest = NSURLRequest(URL: imgURL!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    var image = UIImage(data: data)
                    dispatch_async(dispatch_get_main_queue(), {
                        if image != nil && imageCountRun <= dataImages.count {
                            var xF = imageCountRun * (imageHeight + 20)
                            imageCountRun += 1
                            var imageAttend = UIImageView(frame: CGRectMake(CGFloat(xF), 0.0, CGFloat(imageHeight), CGFloat(self.heightImageScrollViewConstraint.constant)))
                            imageAttend.contentMode = UIViewContentMode.ScaleAspectFit
                            imageAttend.image = image
                            imageAttend.layer.cornerRadius = 10.0
                            imageAttend.layer.masksToBounds = true
                            self.imagesScrollView.addSubview(imageAttend)
                            arrayImages.addObject(imageAttend)
                            var keywordE = KeywordEntity.getKeyword(self.managedObjectContext!, keyword: self.keyword)
                            if keywordE != nil {
                                keywordE?.imageData = NSKeyedArchiver.archivedDataWithRootObject(arrayImages)
                                self.managedObjectContext?.save(nil)
                            }
                        }
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        }
    }
    
    func renderImagesFromDatabase(data: NSData) {
        var arrayImages = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? NSMutableArray
        if arrayImages != nil {
            for view in imagesScrollView.subviews {
                if view is UIImageView {
                    view.removeFromSuperview()
                }
            }
            var imageHeight = (deviceIdidom == UIUserInterfaceIdiom.Pad) ? imageHeightiPad : imageHeightiPhone
            var contentS = imagesScrollView.contentSize
            contentS.width = CGFloat(arrayImages!.count * (imageHeight + 20))
            contentS.height = heightImageScrollViewConstraint.constant
            imagesScrollView.contentSize = contentS
            for imageI in arrayImages! {
                var image = imageI as UIImageView
                imagesScrollView.addSubview(image)
            }
        }
    }


    // MARK: Webview's delegates
    func webViewDidFinishLoad(webView: UIWebView) {
        
    }
    
    
    // MARK: gesture delegate
    func gestureRecognizerShouldBegin(gestureRecognizer: UIPanGestureRecognizer) -> Bool {
        var velocity: CGPoint = gestureRecognizer.velocityInView(view) as CGPoint
        if velocity.x < 0 {
            isPanLeft = true
        }
        else {
            isPanLeft = false
        }
        return fabs(velocity.x) > fabs(velocity.y)
    }
    
    func handlePanGesture(gesture: UIPanGestureRecognizer) {
        var translate: CGPoint = gesture.translationInView(self.view)
//        println("x:\(translate.x) y:\(translate.y)")
        switch (gesture.state) {
            case UIGestureRecognizerState.Changed:
                leftViewHistoryContainerConstraint.constant += translate.x
                if leftViewHistoryContainerConstraint.constant > 0 {
                    leftViewHistoryContainerConstraint.constant = 0
                }
                break
            case UIGestureRecognizerState.Ended:
                if leftViewHistoryContainerConstraint.constant > -CGFloat(leftViewHistoryContainerConstraintD/2) {
                    leftViewHistoryContainerConstraint.constant = 0
                }
                if leftViewHistoryContainerConstraint.constant < -CGFloat(leftViewHistoryContainerConstraintD/2) {
                    leftViewHistoryContainerConstraint.constant = -CGFloat(leftViewHistoryContainerConstraintD)
                }
                if !isPanLeft {
                    historyView?.getKeywordList(keyWordList)
                }
                break
            case UIGestureRecognizerState.Cancelled:
                break
            default:
                break
        }
        gesture.setTranslation(CGPointZero, inView: self.view)
    }
    
    
    // MARK: KeywordListViewControllerProtocol's methods
    func searchWithKeyWord(keywordToSearch: String) {
        searchTextField.text = keywordToSearch
        doASearch()
    }
    
    
    // MARK: WKScriptMessageHandler's method
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        let sentData = message.body as NSDictionary
        let textContent = sentData["message"] as String
        println("\(textContent)")
        var avs = AVSpeechSynthesizer()
        var utterate = utteraceEnglish
        if languageLabel.text == "E" {
            utterate = utteraceOther
        }
        var avsu = AVSpeechUtterance(string: textContent)
        avsu.voice = AVSpeechSynthesisVoice(language: utterate)
        avsu.rate = 0.12
        avs .speakUtterance(avsu)
    }
    
    
    // MARK: Timer's methods
    func startTimer(interV: NSTimeInterval, selectorInStr: String, rep: Bool) {
        var myQueue: NSOperationQueue = NSOperationQueue()
        myQueue.addOperationWithBlock { () -> Void in
            NSTimer.scheduledTimerWithTimeInterval(interV, target: self, selector: Selector(selectorInStr), userInfo: nil, repeats: rep)
            NSRunLoop.currentRunLoop().run()
        }
    }

}

