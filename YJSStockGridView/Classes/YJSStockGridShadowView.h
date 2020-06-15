//
//  YJSStockGridShadowView.h
//  YouruiSafeConsult
//
//  Created by yjs on 2020/6/12.
//  Copyright © 2020 Going against the water, if you don’t advance, you will retreat!. All rights reserved.
//

#import "YJSStockGridView.h"

NS_ASSUME_NONNULL_BEGIN

/// 网格视图（增加滚动阴影处理）
@interface YJSStockGridShadowView : YJSStockGridView

/// 左侧渐变图层
@property (nonatomic, strong, readonly) UIView *leftSideFadeView;

@end

NS_ASSUME_NONNULL_END
