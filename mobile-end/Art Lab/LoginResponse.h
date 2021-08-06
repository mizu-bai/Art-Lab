//
// Created by mizu bai on 2021/7/29.
//

#import <Foundation/Foundation.h>


@interface LoginResponse : NSObject

@property (nonatomic, assign) int status;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *iconBase64;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)loginResponseWithDictionary:(NSDictionary *)dictionary;

@end
