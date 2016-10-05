// PagerViewExample.swift
//
// Copyright (c) 2016 Maxime Epain
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

class PagerViewExample: UIViewController, MXPagerViewDelegate, MXPagerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    fileprivate var SpanichWhite : UIColor = UIColor(colorLiteralRed: 0.996, green: 0.992, blue: 0.941, alpha: 1) /*#fefdf0*/
    
    @IBOutlet weak var pagerView: MXPagerView!
    
    var tableView: UITableView!
    var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init pages
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = SpanichWhite
        
        webView = UIWebView()
        let url = URL(string: "http://www.aesop.com/")
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        
        //Init title
        navigationItem.title = "Page 0"
        
        //Setup pager
        pagerView.gutterWidth = 20
        
        //Register UITextView as page
        pagerView.register(UITextView.self, forPageReuseIdentifier: "TextPage")
    }

    @IBAction func previous(sender: AnyObject) {
        pagerView.showPage(at: (pagerView.indexForSelectedPage - 1), animated: true)
    }

    @IBAction func next(sender: AnyObject) {
        pagerView.showPage(at: (pagerView.indexForSelectedPage + 1), animated: true)
    }
    
    // MARK: - Pager view delegate
    
    func pagerView(_ pagerView: MXPagerView, didMoveToPageAt index: Int) {
        navigationItem.title = "Page \(index)"
    }
    
    // MARK: - Pager view data source
    
    func numberOfPages(in pagerView: MXPagerView) -> Int {
        return 10
    }
    
    func pagerView(_ pagerView: MXPagerView, viewForPageAt index: Int) -> UIView? {
        if index < 2 {
            return [tableView, webView][index]
        }
        
        let page = pagerView.dequeueReusablePage(withIdentifier: "TextPage") as! UITextView
        let filePath = Bundle.main.path(forResource: "LongText", ofType: "txt")
        page.text = try! String(contentsOfFile:filePath!, encoding: String.Encoding.utf8)
        page.backgroundColor = SpanichWhite
        
        return page
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = (indexPath.row % 2 > 0) ? "Text" : "Web"
        cell.backgroundColor = SpanichWhite
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = (indexPath.row % 2) + 1
        pagerView.showPage(at: index, animated:true)
    }
}

