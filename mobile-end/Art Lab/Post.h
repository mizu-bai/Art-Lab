//
//  Post.h
//  Art Lab
//
//  Created by 李俊宏 on 2021/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : NSObject

@property(nonatomic, copy) NSString *text;
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *picture;
@property(nonatomic, copy) NSString *name;
@property (nonatomic, assign) int like;
@property (nonatomic, strong) NSArray<NSString *> *commentArray;

- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)postWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
