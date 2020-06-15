//
//  YJSStockGridView.h
//  YouruiSafeConsult
//
//  Created by yjs on 2020/6/12.
//  Copyright © 2020 Going against the water, if you don’t advance, you will retreat!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJSStockGridViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class YJSStockGridView;
@protocol YJSStockGridViewDataSource <NSObject>

/// 多少列
/// @param gridView 网格视图
- (NSInteger)numberOfColumnsInGridView:(YJSStockGridView *)gridView;

/// 多少行
/// @param gridView 网格视图
- (NSInteger)numberOfRowsInGridView:(YJSStockGridView *)gridView;

/// 返回对应的单元（内容区域）
/// @param gridView 网格视图
/// @param girdCell 网格对应的行Cell
/// @param row 行位置
/// @param column 列位置
- (UICollectionViewCell *)gridView:(YJSStockGridView *)gridView cellForRow:(NSInteger)row column:(NSInteger)column inGridCell:(YJSStockGridViewCell *)girdCell;

/// 返回对应的单元（固定头部区域）
/// @param gridView 网格视图
/// @param girdCell 网格对应的行Cell
/// @param column 列位置
- (UICollectionViewCell *)gridView:(YJSStockGridView *)gridView cellForHeaderWithColumn:(NSInteger)column inGridCell:(YJSStockGridViewCell *)girdCell;

/// 列宽
/// @param gridView 网格视图
- (CGFloat)gridView:(YJSStockGridView *)gridView widthForColumn:(NSInteger)column;

/// 行高
/// @param gridView 网格视图
- (CGFloat)gridView:(YJSStockGridView *)gridView heightForRow:(NSInteger)row;

/// 固定头部高度
/// @param gridView 网格视图
- (CGFloat)gridViewHeightForHeader:(YJSStockGridView *)gridView;

@end

@protocol YJSStockGridViewDelegate <NSObject>

@optional

/// 点击对应的视图
/// @param gridView 网格视图
/// @param row 对应的行
/// @param column 对应的列
- (void)gridView:(YJSStockGridView *)gridView didSelctedAtRow:(NSInteger)row column:(NSInteger)column;

/// 点击对应的视图（固定头部区域）
/// @param gridView 网格视图
/// @param column 对应的列
- (void)gridView:(YJSStockGridView *)gridView didSelctedHeaderWithColumn:(NSInteger)column;

/// 水平开始滚动
/// @param scrollView scrollView
- (void)horizontalScrollViewWillBeginDragging:(UIScrollView *)scrollView;

/// 水平停止滚动
/// @param scrollView scrollView
- (void)horizontalScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

/// 水平自由停止滚动
/// @param scrollView scrollView
/// @param decelerate decelerate
- (void)horizontalScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

/// 垂直开始滚动
/// @param scrollView scrollView
- (void)verticalScrollViewWillBeginDragging:(UIScrollView *)scrollView;

/// 垂直停止滚动
/// @param scrollView scrollView
- (void)verticalScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

/// 垂直自由停止滚动
/// @param scrollView scrollView
/// @param decelerate decelerate
- (void)verticalScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end

/// 网格视图
@interface YJSStockGridView : UIView

/// 尽量不要操作TableView
@property (nonatomic, strong, readonly) UITableView *tableView;

/// 滚动回调Block（用于一些定制需求）
@property (nonatomic, copy, nullable) void (^gridViewDidScrollBlock) (YJSStockGridView *gridView);

/// 滚动回调Block（用于一些定制需求）
@property (nonatomic, copy, nullable) void (^gridViewDidEndDeceleratingBlock) (YJSStockGridView *gridView);

/// 滚动回调Block（用于一些定制需求）
@property (nonatomic, copy, nullable) void (^gridViewDidEndDraggingBlock) (YJSStockGridView *gridView, BOOL WillDecelerate);

/// 右边内容滚动偏移值
@property (nonatomic, assign, readonly) CGPoint contentOffset;

/// 内容大小
@property (nonatomic, assign, readonly) CGSize contentSize;

/// 数据源
@property (nonatomic, weak) id<YJSStockGridViewDataSource> dataSource;

/// 委托
@property (nonatomic, weak) id<YJSStockGridViewDelegate> delegate;

/// 注册cell用于重用
/// @param cellClass cell类
/// @param identifier 标识
- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

/// 从重用队列取
/// @param identifier 标识
/// @param column 列
/// @param girdCell 网格对应的行Cell
- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier column:(NSInteger)column inGridCell:(YJSStockGridViewCell *)girdCell;

/// 刷新表头
- (void)reloadHead;

/// 刷新（包括表头+表）
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
