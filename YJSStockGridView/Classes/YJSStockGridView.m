//
//  YJSStockGridView.m
//  YouruiSafeConsult
//
//  Created by yjs on 2020/6/12.
//  Copyright © 2020 Going against the water, if you don’t advance, you will retreat!. All rights reserved.
//

#import "YJSStockGridView.h"

@interface YJSStockGridView ()<YJSStockGridViewCellDataSource, UITableViewDataSource, UITableViewDelegate>

/// 重用信息
@property (nonatomic, strong) NSMutableDictionary *reuseDict;

@property (nonatomic, strong) YJSStockGridViewCell *sectionHeaderView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGPoint cellLastOffset;

@end

@implementation YJSStockGridView

#pragma mark - Initialize Methods
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
    }
    return self;
}

#pragma mark - Private Methods
- (void)fs_scrollToLastScrollX {
    NSArray *cells = [self.tableView visibleCells];
    for (YJSStockGridViewCell *cell in cells) {
        cell.rightCollectionView.delegate = nil;
        [cell.rightCollectionView setContentOffset:CGPointMake(self.cellLastOffset.x, 0) animated:NO];
        cell.rightCollectionView.delegate = cell;
    }
    
    self.sectionHeaderView.rightCollectionView.delegate = nil;
    [self.sectionHeaderView.rightCollectionView setContentOffset:CGPointMake(self.cellLastOffset.x, 0) animated:NO];
    self.sectionHeaderView.rightCollectionView.delegate = self.sectionHeaderView;
}

#pragma mark - Public Methods
- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier{
    if (cellClass) {
        [self.reuseDict setObject:NSStringFromClass(cellClass) forKey:identifier];
    }
}

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier column:(NSInteger)column inGridCell:(nonnull YJSStockGridViewCell *)girdCell{
    //第0列
    if (!column) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        return [girdCell.leftCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    } else {
        NSInteger section = column - 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        return [girdCell.rightCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    }
}

- (void)reloadHead{
    [self.sectionHeaderView.leftCollectionView reloadData];
    [self.sectionHeaderView.rightCollectionView reloadData];
}

/// 刷新（包括表头+表）
- (void)reloadData{
    [self.sectionHeaderView.leftCollectionView reloadData];
    [self.sectionHeaderView.rightCollectionView reloadData];
    [self.tableView reloadData];
}

#pragma mark - Overwrite Methods

- (void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self fs_scrollToLastScrollX];
}

#pragma mark - <YJSStockGridViewCellDataSource>
- (NSInteger)numberOfColumnsInCell:(YJSStockGridViewCell *)cell{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfColumnsInGridView:)]) {
        return [self.dataSource numberOfColumnsInGridView:self];
    } else {
        return 0;;
    }
}

- (CGFloat)gridViewCell:(YJSStockGridViewCell *)cell widthForColumn:(NSInteger)column{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridView:widthForColumn:)]) {
        return [self.dataSource gridView:self widthForColumn:column];
    } else {
        return 0.0f;
    }
}

- (UICollectionViewCell *)gridViewCell:(YJSStockGridViewCell *)cell cellForColumn:(NSInteger)column{
    if (cell == self.sectionHeaderView) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridView:cellForHeaderWithColumn:inGridCell:)]) {
            return [self.dataSource gridView:self cellForHeaderWithColumn:column inGridCell:cell];
        } else {
            return nil;
        }
    } else {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridView:cellForRow:column:inGridCell:)]) {
            return [self.dataSource gridView:self cellForRow:cell.gridRowIndex column:column inGridCell:cell];
        } else {
            return nil;
        }
    }
}

- (void)gridViewCell:(YJSStockGridViewCell *)cell didSelectItemAtColumn:(NSInteger)column{
    if (cell == self.sectionHeaderView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:didSelctedHeaderWithColumn:)]) {
            [self.delegate gridView:self didSelctedHeaderWithColumn:column];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(gridView:didSelctedAtRow:column:)]) {
            [self.delegate gridView:self didSelctedAtRow:cell.gridRowIndex column:column];
        }
    }
}

- (void)gridViewCell:(YJSStockGridViewCell *)sender didScroll:(UIScrollView *)scrollView{
    if (scrollView == sender.rightCollectionView) {
        NSArray<YJSStockGridViewCell *> *cells = [self.tableView visibleCells];
        for (YJSStockGridViewCell *cell in cells) {
            if (cell != sender) {
                cell.rightCollectionView.delegate = nil;
                [cell.rightCollectionView setContentOffset:CGPointMake(sender.rightCollectionView.contentOffset.x, 0) animated:NO];
                cell.rightCollectionView.delegate = cell;
            }
        }
        
        if (sender != self.sectionHeaderView) {
            self.sectionHeaderView.rightCollectionView.delegate = nil;
            [self.sectionHeaderView.rightCollectionView setContentOffset:CGPointMake(sender.rightCollectionView.contentOffset.x, 0) animated:NO];
            self.sectionHeaderView.rightCollectionView.delegate = self.sectionHeaderView;
        }
    }
    
    self.cellLastOffset = sender.rightCollectionView.contentOffset;
    
    if (self.gridViewDidScrollBlock) {
        self.gridViewDidScrollBlock(self);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(horizontalScrollViewWillBeginDragging:)]) {
        [self.delegate horizontalScrollViewWillBeginDragging:scrollView];
    }
}

- (void)gridViewCell:(YJSStockGridViewCell *)cell didEndDecelerating:(UIScrollView *)scrollView{
    if (self.gridViewDidEndDeceleratingBlock) {
        self.gridViewDidEndDeceleratingBlock(self);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(horizontalScrollViewDidEndDecelerating:)]) {
        [self.delegate horizontalScrollViewDidEndDecelerating:scrollView];
    }
}

- (void)gridViewCell:(YJSStockGridViewCell *)cell scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelera{
    if (self.gridViewDidEndDraggingBlock) {
        self.gridViewDidEndDraggingBlock(self, decelera);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(horizontalScrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate horizontalScrollViewDidEndDragging:scrollView willDecelerate:decelera];
    }
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)tasection{
    NSInteger rows = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfRowsInGridView:)]) {
        rows = [self.dataSource numberOfRowsInGridView:self];
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YJSStockGridViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass(YJSStockGridViewCell.class)];
    if (!cell) {
        cell = [[YJSStockGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:NSStringFromClass(YJSStockGridViewCell.class)
                                          dataSource:self];
        
        for (NSString *key in self.reuseDict.allKeys) {
            Class class = NSClassFromString([self.reuseDict objectForKey:key]);
            [cell.leftCollectionView registerClass:class forCellWithReuseIdentifier:key];
            [cell.rightCollectionView registerClass:class forCellWithReuseIdentifier:key];
        }
    }
    
    //更新内容
    cell.gridRowIndex = indexPath.row;
    [cell.leftCollectionView reloadData];
    [cell.rightCollectionView reloadData];
    
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = 0.0f;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridViewHeightForHeader:)]) {
        height = [self.dataSource gridViewHeightForHeader:self];
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0.0f;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(gridView:heightForRow:)]) {
        height = [self.dataSource gridView:self heightForRow:indexPath.row];
    }
    return height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeaderView;
}

#pragma mark - property

- (NSMutableDictionary *)reuseDict {
    if (!_reuseDict) {
        _reuseDict = [NSMutableDictionary dictionary];
    }
    return _reuseDict;
}

- (UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        //关闭估算行高
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}

- (YJSStockGridViewCell *)sectionHeaderView {
    if (!_sectionHeaderView) {
        YJSStockGridViewCell *cell = [[YJSStockGridViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(YJSStockGridViewCell.class) dataSource:self];
        for (NSString *key in self.reuseDict.allKeys) {
            Class class = NSClassFromString([self.reuseDict objectForKey:key]);
            [cell.leftCollectionView registerClass:class forCellWithReuseIdentifier:key];
            [cell.rightCollectionView registerClass:class forCellWithReuseIdentifier:key];
        }
        _sectionHeaderView = cell;
    }
    return _sectionHeaderView;
}

- (CGPoint)contentOffset{
    return self.cellLastOffset;
}

- (CGSize)contentSize{
    CGFloat height = self.tableView.contentSize.height;
    CGFloat width = self.sectionHeaderView.leftCollectionView.contentSize.width + self.sectionHeaderView.rightCollectionView.contentSize.width;
    return CGSizeMake(width, height);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if([self.delegate respondsToSelector:@selector(verticalScrollViewWillBeginDragging:)]){
        [self.delegate verticalScrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if([self.delegate respondsToSelector:@selector(verticalScrollViewDidEndDecelerating:)]){
        [self.delegate verticalScrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if([self.delegate respondsToSelector:@selector(verticalScrollViewDidEndDragging:willDecelerate:)]){
        [self.delegate verticalScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}


@end
