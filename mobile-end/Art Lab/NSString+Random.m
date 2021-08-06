//
// Created by mizu bai on 2021/7/28.
//

#import "NSString+Random.h"


@implementation NSString (Random)

+ (NSString *)randomFileName {
    NSMutableString *randomFileName = [NSMutableString string];
    // Date
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    [randomFileName appendString:[formatter stringFromDate:date]];
    // Random Char
    NSString *charset = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    for (int i = 0; i < 5; i++) {
        [randomFileName appendFormat:@"%C", [charset characterAtIndex:arc4random_uniform((uint32_t) [charset length])]];
    }
    return [randomFileName copy];
}

@end
