//
//  YJSStockGridFlowLayout.m
//  YouruiSafeConsult
//
//  Created by yjs on 2020/6/12.
//  Copyright © 2020 Going against the water, if you don’t advance, you will retreat!. All rights reserved.
//

#import "YJSStockGridFlowLayout.h"

@implementation YJSStockGridFlowLayout

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSettings];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSettings];
    }
    return self;
}

- (void)initSettings {
    self.itemSize = CGSizeMake(100, 51);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (CGFloat)pageWidth {
    return self.itemSize.width + self.minimumLineSpacing;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat rawPageValue = self.collectionView.contentOffset.x / self.pageWidth;
    CGFloat currentPage = (velocity.x > 0.0) ? floor(rawPageValue) : ceil(rawPageValue);
    CGFloat nextPage = (velocity.x > 0.0) ? ceil(rawPageValue) : floor(rawPageValue);
    
    BOOL pannedLessThanAPage = fabs(1 + currentPage - rawPageValue) > 0.5;
    BOOL flicked = fabs(velocity.x) > [self flickVelocity];
    if (pannedLessThanAPage && flicked) {
        proposedContentOffset.x = nextPage * self.pageWidth;
    } else {
        proposedContentOffset.x = round(rawPageValue) * self.pageWidth;
    }
    return proposedContentOffset;
}

- (CGFloat)flickVelocity {
    return 0.3;
}

@end
