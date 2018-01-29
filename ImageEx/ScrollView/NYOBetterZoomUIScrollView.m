//
//  NYOBetterUIScrollView.m
//  ZoomTest
//
//  Created by Liam on 14/04/2010.
//  Copyright 2010 Liam Jones (nyoron.co.uk). All rights reserved.
//

#import "NYOBetterZoomUIScrollView.h"

@interface NYOBetterZoomUIScrollView ()

@property(nonatomic, assign) CGSize ccontentSize;

@end

@implementation NYOBetterZoomUIScrollView


#pragma mark -
#pragma mark Initialisers


- (id)initWithFrame:(CGRect)aFrame {
    if ((self = [super initWithFrame:aFrame])) {
        // Initialization code
    }
    return self;
}


- (id)initWithChildView:(UIView *)aChildView {
	if (self = [super init]) {
        [self setChildView: aChildView];
    }
    return self;
}


- (id)initWithFrame:(CGRect)aFrame andChildView:(UIView *)aChildView  {
    if (self = [super initWithFrame:aFrame]) {
        [self setChildView: aChildView];
    }
    return self;
}

- (void)setZoomForContentSize:(CGSize)contentSize {

    self.ccontentSize = contentSize;
    // Work out a nice minimum zoom for the contetnt - if it's smaller than the ScrollView then 1.0x zoom otherwise a scaled down zoom so it fits in the ScrollView entirely when zoomed out
    CGSize scrollSize = self.frame.size;
    CGFloat widthRatio = scrollSize.width / contentSize.width;
    CGFloat heightRatio = scrollSize.height / contentSize.height;
    CGFloat minimumZoom = MIN(1.0, (widthRatio > heightRatio) ? heightRatio : widthRatio);
    
    [self setMinimumZoomScale:minimumZoom];
}

- (void)updateZoomScale {
    BOOL wasAtMinimumZoom = NO;

    if(self.zoomScale == self.minimumZoomScale) {
        wasAtMinimumZoom = YES;
    }

    [self setZoomForContentSize:self.ccontentSize];

    if (wasAtMinimumZoom || self.zoomScale < self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
}


#pragma mark -
#pragma mark Accessors


- (UIView *)childView {
    return _childView;
}


-(void)setChildView:(UIView *)aChildView {
	if (_childView != aChildView) {
		[_childView removeFromSuperview];
        _childView = aChildView;
		[super addSubview:_childView];
		[self setContentOffset:CGPointZero];
    }
}


#pragma mark -
#pragma mark UIScrollView


// Rather than the default behaviour of a {0,0} offset when an image is too small to fill the UIScrollView we're going to return an offset that centres the image in the UIScrollView instead.
- (void)setContentOffset:(CGPoint)anOffset {

	if(_childView != nil) {
		CGSize zoomViewSize = _childView.frame.size;
		CGSize scrollViewSize = self.bounds.size;
		
        if(zoomViewSize.width < scrollViewSize.width) {
            anOffset.x = -(scrollViewSize.width - zoomViewSize.width) / 2.0;
        }

        if(zoomViewSize.height < scrollViewSize.height) {
            anOffset.y = -(scrollViewSize.height - zoomViewSize.height) / 2.0;
        }
	}
	super.contentOffset = anOffset;
}


@end
