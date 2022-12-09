//
//  CCSortTableView.h
//  Pods
//
//  Created by lucc on 2022/11/29.
//

#import <UIKit/UIKit.h>

@class CCSortTableView;

NS_ASSUME_NONNULL_BEGIN

@protocol CCSortTableViewDataSource <NSObject>
//数据交换回调
- (void)CC_tableView:(CCSortTableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;

@end

@interface CCSortTableView : UITableView
//数据源回调
@property (nonatomic, weak) id<CCSortTableViewDataSource> cc_dataSource;
//拖拽中cell缩放值（默认1.05）
@property (nonatomic, assign) CGFloat draggingCellScale;
//拖拽中cell的alpha值 （默认 0.8）
@property (nonatomic, assign) CGFloat draggingCellAlpha;
@end

NS_ASSUME_NONNULL_END
