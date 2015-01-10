//
//  KeywordListViewController.swift
//  khmer
//
//  Created by Tran Huu Tam on 11/10/14.
//  Copyright (c) 2014 BenjaminSoft. All rights reserved.
//

import UIKit

@objc protocol KeywordListViewControllerProtocol: NSObjectProtocol {
    func searchWithKeyWord(keywordToSearch: String)
}

class KeywordListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: UI's elements
    @IBOutlet weak var keywordListTable: UITableView!
    
    
    //  MARK: Class's constructors
    required init(coder aDecoder: NSCoder?) {
        super.init(coder: aDecoder!);
        self._init();
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self._init();
    }
    
    
    // MARK: View's lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self._localize()
        self._visualize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    
    // MARK: Class's properties
    var listOfKeywords: NSMutableArray!
    var delegate: KeywordListViewControllerProtocol?
    
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
    
    // MARK: Class's private methods
    func _localize() {
        
    }
    
    func _visualize() {
//        getKeywordList()
    }
    
    func _init() {
        listOfKeywords = NSMutableArray()
    }
    
    
    // MARK: UITableViewDataSource.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("tableView has \(listOfKeywords.count) rows")
        return listOfKeywords.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("KeywordCell") as KeywordCell
        cell.cleanCell()
        var str = listOfKeywords.objectAtIndex(indexPath.row) as? String
        if let strD = str {
            var strArr = strD.componentsSeparatedByString("-") as [String]
            cell.languageLabel.text = strArr.last! as String
            cell.keywordLabel.text = strArr.first! as String
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    // MARK: UITableViewDelegate.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView .cellForRowAtIndexPath(indexPath) as KeywordCell
        if (delegate!.respondsToSelector(Selector("searchWithKeyWord:"))) {
            delegate?.searchWithKeyWord(cell.keywordLabel.text! as String)
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0;
    }
    
    
    // MARK: class's private methods
    func getKeywordList(list: NSMutableArray) {
        listOfKeywords = list
        keywordListTable.reloadData()
    }

}

class KeywordCell: UITableViewCell {
    
    
    // MARK: Class's properties
    var isSelected = false
    
    
    // MARK: UI's elements
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    
    // MARK: Class's public methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
        self.visualize()
        self.localize()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.isSelected = selected
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    // MARK: Class's private methods
    func initialize() {
        
    }
    
    func visualize() {
        
    }
    
    func localize() {
        
    }
    
    func cleanCell() {
        keywordLabel.text = ""
    }
}
