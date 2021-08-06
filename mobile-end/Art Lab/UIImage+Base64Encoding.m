//
// Created by mizu bai on 2021/7/29.
//

#import "UIImage+Base64Encoding.h"


@implementation UIImage (Base64Encoding)

+ (UIImage *)imageWithBase64Encoding:(NSString *)base64EncodingString {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64EncodingString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

+ (NSString *)base64EncodingStringWith:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    NSString *base64EncodingString = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64EncodingString;
}

@end
