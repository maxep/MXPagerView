// MXPagerViewController.m
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

#import "MXPagerViewController.h"

@interface MXPagerViewController () <MXPageSegueDelegate>

@end

@implementation MXPagerViewController {
    UIViewController *_pageViewController;
    NSInteger _pageIndex;
}

@synthesize pagerView = _pagerView;

- (void)loadView {
    self.view = self.pagerView;
}

#pragma mark Properties

- (MXPagerView *)pagerView {
    if (!_pagerView) {
        _pagerView = [[MXPagerView alloc] init];
        _pagerView.delegate    = self;
        _pagerView.dataSource  = self;
    }
    return _pagerView;
}

#pragma mark <MXPagerViewControllerDataSource>

- (NSInteger) numberOfPagesInPagerView:(nonnull MXPagerView *)pagerView {
    NSArray *segues = [self valueForKey:@"storyboardSegueTemplates"] ;
    return segues.count;
}

- (UIView *)pagerView:(MXPagerView *)pagerView viewForPageAtIndex:(NSInteger)index {
    
    UIViewController *viewController = [self pagerView:pagerView viewControllerForPageAtIndex:index];
    
    if (viewController) {
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
        
        return viewController.view;
    }
    return nil;
}

- (UIViewController *)pagerView:(MXPagerView *)pagerView viewControllerForPageAtIndex:(NSInteger)index {
    if (self.storyboard) {
        @try {
            NSString *identifier = [self pagerView:pagerView segueIdentifierForPageAtIndex:index];
            _pageIndex = index;
            [self performSegueWithIdentifier:identifier sender:nil];
            return _pageViewController;
        }
        @catch(NSException *exception) {}
    }
    return nil;
}

- (NSString *)pagerView:(MXPagerView *)pagerView segueIdentifierForPageAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:MXSeguePageIdentifierFormat, (long)index];
}

#pragma mark <MXPageSegueDelegate>

- (NSInteger)pageIndex {
    return _pageIndex;
}

- (void)setPageViewController:(UIViewController*)pageViewController{
    _pageViewController = pageViewController;
}

@end

#pragma mark MXPageSegue class

NSString * const MXSeguePageIdentifierFormat = @"mx_page_%ld";

@implementation MXPageSegue

@dynamic sourceViewController;
@synthesize pageIndex = _pageIndex;

- (instancetype)initWithIdentifier:(nullable NSString *)identifier source:(UIViewController <MXPageSegueDelegate>*)source destination:(UIViewController *)destination {
    if (self = [super initWithIdentifier:identifier source:source destination:destination]) {
        
        if ([source respondsToSelector:@selector(pageIndex)]) {
            _pageIndex = source.pageIndex;
        }
    }
    return self;
}

- (void)perform {
    if ([self.sourceViewController respondsToSelector:@selector(setPageViewController:)]) {
        self.sourceViewController.pageViewController = self.destinationViewController;
    }
}

@end
