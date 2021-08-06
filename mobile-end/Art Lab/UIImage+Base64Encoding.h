//
// Created by mizu bai on 2021/7/29.
//

#import <UIKit/UIKit.h>

@interface UIImage (Base64Encoding)

+ (UIImage *)imageWithBase64Encoding:(NSString *)base64EncodingString;
+ (NSString *)base64EncodingStringWith:(UIImage *)image;

@end
