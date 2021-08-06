//
//  Post.m
//  Art Lab
//
//  Created by 李俊宏 on 2021/6/18.
//

#import "Post.h"

@implementation Post

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)postWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
