// MXPagerViewExample.swift
//
// Copyright (c) 2015 Maxime Epain
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import MXPagerView

class MXPagerViewExample: UIViewController, MXPagerViewDelegate, MXPagerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var pagerView: MXPagerView!
    
    var tableView: UITableView!
    var webView: UIWebView!
    var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init pages
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.webView = UIWebView()
        let url = NSURL(string: "http://nshipster.com/");
        let request = NSURLRequest(URL: url!);
        self.webView.loadRequest(request);
        
        self.textView = UITextView()
        let filePath = NSBundle.mainBundle().pathForResource("LongText", ofType: "txt")
        self.textView.text = try! String(contentsOfFile:filePath!, encoding: NSUTF8StringEncoding)
        
        //Init title
        self.navigationItem.title = "Page 0"
        
        //Setup pager
        self.pagerView.gutterWidth = 20
        
        //Register UITextView as page
        self.pagerView.registerClass(UITextView.self, forPageReuseIdentifier: "TextPage")
    }

    @IBAction func previous(sender: AnyObject) {
        self.pagerView.showPageAtIndex((self.pagerView.indexForSelectedPage - 1), animated: true)
    }

    @IBAction func next(sender: AnyObject) {
        self.pagerView.showPageAtIndex((self.pagerView.indexForSelectedPage + 1), animated: true)
    }
    
    // MARK: - Pager view delegate
    
    func pagerView(pagerView: MXPagerView, didMoveToPageAtIndex index: Int) {
        self.navigationItem.title = String(format: "Page %li", index)
    }
    
    // MARK: - Pager view data source
    
    func numberOfPagesInPagerView(pagerView: MXPagerView) -> Int {
        return 10
    }
    
    func pagerView(pagerView: MXPagerView, viewForPageAtIndex index: Int) -> UIView? {
        if index < 3 {
            return [self.tableView, self.webView, self.textView][index]
        }
        
        let page = pagerView.dequeueReusablePageWithIdentifier("TextPage") as! UITextView
        let filePath = NSBundle.mainBundle().pathForResource("LongText", ofType: "txt")
        page.text = try! String(contentsOfFile:filePath!, encoding: NSUTF8StringEncoding)
        
        return page
    }

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel?.text = (indexPath.row % 2 > 0) ? "Text" : "Web"
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = (indexPath.row % 2) + 1
        self.pagerView.showPageAtIndex(index, animated:true)
    }
}

