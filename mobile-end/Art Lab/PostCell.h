//
//  PostCell.h
//  Art Lab
//
//  Created by 李俊宏 on 2021/6/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PostFrame;

@interface PostCell : UITableViewCell

@property(nonatomic, strong) PostFrame *postFrame;

+ (instancetype)postCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
