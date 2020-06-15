//
//  YJSStockGridShadowView.m
//  YouruiSafeConsult
//
//  Created by yjs on 2020/6/12.
//  Copyright © 2020 Going against the water, if you don’t advance, you will retreat!. All rights reserved.
//

#import "YJSStockGridShadowView.h"

@interface YJSStockGridShadowView ()

/// 左侧渐变图层
@property (nonatomic, strong) UIView *leftSideFadeView;

@end

@implementation YJSStockGridShadowView

#pragma mark - Initialize Methods

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBinding];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupBinding{
    //滚动阴影
    __weak typeof(self) weakSelf = self;
    self.gridViewDidScrollBlock = ^(YJSStockGridView * _Nonnull gridView) {
        weakSelf.leftSideFadeView.hidden = (gridView.contentOffset.x <= 0.0f);
    };
}


#pragma mark - Overwrite Methods
- (void)layoutSubviews{
    [super layoutSubviews];

    if (!self.leftSideFadeView.superview) {
        
        CGFloat leftOffset = 0.0f;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridView:widthForColumn:)]) {
            leftOffset = [self.dataSource gridView:self widthForColumn:0];
        }
        [self addSubview:self.leftSideFadeView];
        self.leftSideFadeView.frame = CGRectMake(leftOffset, 0, 10, self.frame.size.height);
    }
}


+ (UIImage *)colorWithGradientwithSize:(CGSize)size andColors:(NSArray *)colors {
    
    //Create our background gradient layer
    CAGradientLayer *backgroundGradientLayer = [CAGradientLayer layer];
    
    //Set the frame to our object's bounds
    backgroundGradientLayer.frame = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    //To simplfy formatting, we'll iterate through our colors array and create a mutable array with their CG counterparts
    NSMutableArray *cgColors = [[NSMutableArray alloc] init];
    for (UIColor *color in colors) {
        [cgColors addObject:(id)[color CGColor]];
    }
    
    backgroundGradientLayer.colors = cgColors;
    
    //Specify the direction our gradient will take
    [backgroundGradientLayer setStartPoint:CGPointMake(0.0, 0.5)];
    [backgroundGradientLayer setEndPoint:CGPointMake(1.0, 0.5)];
    
    //Convert our CALayer to a UIImage object
    UIGraphicsBeginImageContext(backgroundGradientLayer.bounds.size);
    [backgroundGradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return backgroundColorImage;
}


#pragma mark - property

- (UIView *)leftSideFadeView{
    if (!_leftSideFadeView) {
        UIImage *image = [YJSStockGridShadowView colorWithGradientwithSize:CGSizeMake(10.0f, 10.0f) andColors:@[[UIColor colorWithWhite:0.0f alpha:0.1f], [UIColor colorWithWhite:0.0f alpha:0.0f]]];
        _leftSideFadeView = [[UIView alloc] init];
        _leftSideFadeView.layer.contents = (id) image.CGImage;
        _leftSideFadeView.hidden = YES;
    }
    return _leftSideFadeView;
}

@end

