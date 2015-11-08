// MXPagerViewExample.m
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

#import "MXPagerViewExample.h"
#import <MXPagerView/MXPagerView.h>

@interface MXPagerViewExample () <MXPagerViewDelegate, MXPagerViewDataSource, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet MXPagerView *pagerView;
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) UIWebView     *webView;
@property (nonatomic, strong) UITextView    *textView;
@end

@implementation MXPagerViewExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pagerView.delegate = self;
    self.pagerView.dataSource = self;
    
    self.pagerView.gutterWidth = 20;
    
    //Register UItableView as page
    [self.pagerView registerClass:[UITextView class] forPageReuseIdentifier:@"TextPage"];
}

#pragma mark Properties

- (UITableView *)tableView {
    if (!_tableView) {
        //Add a table page
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIWebView *)webView {
    if (!_webView) {
        // Add a web page
        _webView = [[UIWebView alloc] init];
        NSString *strURL = @"http://nshipster.com/";
        NSURL *url = [NSURL URLWithString:strURL];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:urlRequest];
    }
    return _webView;
}

- (UITextView *)textView {
    if (!_textView) {
        // Add a text page
        _textView = [[UITextView alloc] init];
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"LongText" ofType:@"txt"];
        _textView.text = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    }
    return _textView;
}

#pragma mark <MXPagerViewDelegate>

- (void) pagerView:(nonnull MXPagerView *)pagerView didMoveToPageAtIndex:(NSInteger)index {
    NSLog(@"Did move to page with index %li", index);
}

#pragma -mark <MXPagerViewDataSource>

- (NSInteger)numberOfPagesInPagerView:(MXPagerView *)pagerView {
    return 10;
}

- (NSString *)segmentedPager:(MXPagerView *)pagerView titleForSectionAtIndex:(NSInteger)index {
    if (index < 3) {
        return [@[@"Table", @"Web", @"Text"] objectAtIndex:index];
    }
    return [NSString stringWithFormat:@"Page %li", (long) index];
}

- (UIView *)pagerView:(MXPagerView *)pagerView viewForPageAtIndex:(NSInteger)index {
    if (index < 3) {
        return [@[self.tableView, self.webView, self.textView] objectAtIndex:index];
    }
    
    //Dequeue reusable page
    UITextView *page = [self.pagerView dequeueReusablePageWithIdentifier:@"TextPage"];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"LongText" ofType:@"txt"];
    page.text = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    return page;
}

#pragma mark <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = (indexPath.row % 2) + 1;
    [self.pagerView showPageAtIndex:index animated:YES];
}

#pragma mark <UITableViewDataSource>

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = (indexPath.row % 2)? @"Text": @"Web";
    
    return cell;
}


@end
