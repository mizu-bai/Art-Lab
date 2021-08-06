//
//  NewPostViewController.h
//  Art Lab
//
//  Created by 李俊宏 on 2021/7/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PostFrame;

@interface NewPostViewController : UIViewController

@property (nonatomic, copy) void (^sendPostBlock)(PostFrame *postFrame);

@end

NS_ASSUME_NONNULL_END
