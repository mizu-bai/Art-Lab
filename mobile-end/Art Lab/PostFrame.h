//
//  PostFrame.h
//  Art Lab
//
//  Created by 李俊宏 on 2021/6/18.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#define kNameFont [UIFont systemFontOfSize:16]
#define kTextFont [UIFont systemFontOfSize:16]

NS_ASSUME_NONNULL_BEGIN

@class Post;

@interface PostFrame : NSObject

@property(nonatomic, strong) Post *post;
@property(nonatomic, assign) CGRect iconFrame;
@property(nonatomic, assign) CGRect nameFrame;
@property(nonatomic, assign) CGRect textFrame;
@property(nonatomic, assign) CGRect picFrame;
@property(nonatomic, assign) CGRect likeFrame;
@property(nonatomic, assign) CGRect forwardFrame;
@property(nonatomic, assign) CGRect commentInputFrame;
@property(nonatomic, assign) CGRect commentListFrame;
@property(nonatomic, assign) CGFloat rowHeight;

@end

NS_ASSUME_NONNULL_END
