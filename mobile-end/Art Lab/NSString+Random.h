//
// Created by mizu bai on 2021/7/28.
//

#import <Foundation/Foundation.h>

@interface NSString (Random)

/**
 * Create random file name
 * Format: yyyy-MM-dd-xxxxx (5 random char)
 * @return (NSString *) randomFileName
 */

+ (NSString *)randomFileName;

@end
