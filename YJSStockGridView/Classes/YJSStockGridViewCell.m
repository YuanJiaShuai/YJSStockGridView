//
//  YJSStockGridViewCell.m
//  YouruiSafeConsult
//
//  Created by yjs on 2020/6/12.
//  Copyright © 2020 Going against the water, if you don’t advance, you will retreat!. All rights reserved.
//

#import "YJSStockGridViewCell.h"
#import "YJSStockGridFlowLayout.h"

@interface YJSStockGridViewCell ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

/// 左侧滚动视图
@property (nonatomic, strong) UICollectionView *leftCollectionView;
/// 右侧滚动视图
@property (nonatomic, strong) UICollectionView *rightCollectionView;

@end

@implementation YJSStockGridViewCell

#pragma mark - Initialize Methods

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dataSource:(id<YJSStockGridViewCellDataSource>)dataSource{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dataSource = dataSource;
        [self setupSubviews];
        [self setupConstraints];
        [self setupBinding];
    }
    return self;
}

#pragma mark - Overwrite Methods

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = UIColor.clearColor;
    
    CGFloat leftWidth = 0.0f;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridViewCell:widthForColumn:)]) {
        leftWidth = [self.dataSource gridViewCell:self widthForColumn:0];
    }
    
    self.leftCollectionView.frame = CGRectMake(0.0f, 0.0f, leftWidth, self.frame.size.height);
    self.rightCollectionView.frame = CGRectMake(leftWidth, 0.0f, self.frame.size.width - leftWidth, self.frame.size.height);
}

#pragma mark - Private Methods
- (void)setupSubviews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubview:self.leftCollectionView];
    [self addSubview:self.rightCollectionView];
}

- (void)setupConstraints{
    
}

- (void)setupBinding{
    
}

#pragma mark - <UIScrollViewDelate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridViewCell:didScroll:)]) {
        [self.dataSource gridViewCell:self didScroll:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridViewCell:didEndDecelerating:)]) {
        [self.dataSource gridViewCell:self didEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridViewCell:scrollViewDidEndDragging:willDecelerate:)]) {
        [self.dataSource gridViewCell:self scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfColumnsInCell:)]) {
        count = [self.dataSource numberOfColumnsInCell:self];
    }

    if (collectionView == self.leftCollectionView) {
        return (count > 0)? 1: 0;
    } else {
        return count - 1;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.leftCollectionView) {
        UICollectionViewCell *cell = nil;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridViewCell:cellForColumn:)]) {
            cell = [self.dataSource gridViewCell:self cellForColumn:0];
        }
        return cell;
    } else {
        NSInteger column = indexPath.row;
        UICollectionViewCell *cell = nil;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridViewCell:cellForColumn:)]) {
            cell = [self.dataSource gridViewCell:self cellForColumn:column + 1];
        }
        return cell;
    }
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridViewCell:didSelectItemAtColumn:)]) {
        if (collectionView == self.leftCollectionView) {
            [self.dataSource gridViewCell:self didSelectItemAtColumn:0];
        } else {
            NSInteger column = indexPath.row;
            [self.dataSource gridViewCell:self didSelectItemAtColumn:column + 1];
        }
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.leftCollectionView) {
        CGFloat leftWidth = 0.0f;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridViewCell:widthForColumn:)]) {
            leftWidth = [self.dataSource gridViewCell:self widthForColumn:0];
        }
        return CGSizeMake(leftWidth, self.frame.size.height);
    } else {
        
        CGFloat width = 0.0f;
        NSInteger column = indexPath.row;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridViewCell:widthForColumn:)]) {
            width = [self.dataSource gridViewCell:self widthForColumn:column + 1];
        }
        return CGSizeMake(width, self.frame.size.height);
    }
}


#pragma mark - property

- (UICollectionView *)leftCollectionView {
    if (!_leftCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        _leftCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _leftCollectionView.backgroundColor = UIColor.clearColor;
        _leftCollectionView.showsHorizontalScrollIndicator = NO;
        _leftCollectionView.delegate = self;
        _leftCollectionView.dataSource = self;
        _leftCollectionView.scrollEnabled = NO;
    }
    return _leftCollectionView;
}

- (UICollectionView *)rightCollectionView {
    if (!_rightCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        _rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _rightCollectionView.backgroundColor = UIColor.clearColor;
        _rightCollectionView.showsHorizontalScrollIndicator = NO;
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
    }
    return _rightCollectionView;
}

@end
