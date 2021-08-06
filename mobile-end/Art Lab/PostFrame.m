//
//  PostFrame.m
//  Art Lab
//
//  Created by 李俊宏 on 2021/6/18.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "PostFrame.h"


#define kScreenWidth UIScreen.mainScreen.bounds.size.width

@implementation PostFrame

#pragma mark - Rewrite set method of post

- (void)setPost:(Post *)post {
    _post = post;
    CGFloat margin = 25;
    
    // icon
    CGFloat iconWidth = 35;
    CGFloat iconHeight = 35;
    CGFloat iconX = margin;
    CGFloat iconY = margin;
    _iconFrame = CGRectMake(iconX, iconY, iconWidth, iconHeight);
    
    // nick name
    NSString *nickName = post.name;
    CGFloat nameX = CGRectGetMaxX(_iconFrame) + margin * 0.5;
    CGSize nameSize = [self sizeWithText:nickName andMaxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) andFont:kNameFont];
    CGFloat nameWidth = nameSize.width;
    CGFloat nameHeight = nameSize.height;
    CGFloat nameY = iconY + (iconHeight - nameHeight) / 2;
    _nameFrame = CGRectMake(nameX, nameY, nameWidth, nameHeight);
    
    // text
    CGFloat textX = _nameFrame.origin.x;
    CGFloat textY = CGRectGetMaxY(_iconFrame) + margin * 0.5;
    CGSize textSize = [self sizeWithText:post.text andMaxSize:CGSizeMake(kScreenWidth - 2 * margin, CGFLOAT_MAX) andFont:kTextFont];
    CGFloat textWidth = textSize.width;
    CGFloat textHeight = textSize.height;
    _textFrame = CGRectMake(textX, textY, textWidth, textHeight);
    
    // picture
    // CGFloat picWidth = (kScreenWidth - 3 * margin) * 0.5;
    CGFloat picWidth = kScreenWidth * 0.6;
    CGFloat picHeight = picWidth * 0.75;
    CGFloat picX = iconX;
    CGFloat picY = CGRectGetMaxY(_textFrame) + margin;
    _picFrame = CGRectMake(picX, picY, picWidth, picHeight);

    // forward
    CGFloat forwardWidth = 20;
    CGFloat forwardHeight = 20;
    CGFloat forwardX = kScreenWidth - 1.5 * margin - forwardWidth;
    CGFloat forwardY = margin + CGRectGetMaxY(self.post.picture ? _picFrame : _textFrame);
    _forwardFrame = CGRectMake(forwardX, forwardY, forwardWidth, forwardHeight);

    // like
    CGFloat likeWidth = 20;
    CGFloat likeHeight = 20;
    CGFloat likeX = forwardX - margin - likeWidth;
    CGFloat likeY = forwardY;
    _likeFrame = CGRectMake(likeX, likeY, likeWidth, likeHeight);

    // comment input
    CGFloat commentInputWidth = likeX - 2 * margin;
    CGFloat commentInputHeight = 30;
    CGFloat commentInputX = margin;
    CGFloat commentInputY = forwardY;
    _commentInputFrame = CGRectMake(commentInputX, commentInputY, commentInputWidth, commentInputHeight);

    // comment list
    NSMutableString *commentLabel = [NSMutableString string];
    for (NSString *comment in self.post.commentArray) {
        [commentLabel appendFormat:@"%@\n", comment];
    }
    CGFloat commentLabelX = margin;
    CGFloat commentLabelY = CGRectGetMaxY(_commentInputFrame) + margin * 0.5;
    CGSize commentLabelSize = [self sizeWithText:[commentLabel copy] andMaxSize:CGSizeMake(CGFLOAT_MAX, kScreenWidth - 2 * margin) andFont:kTextFont];
    CGFloat commentLabelWidth = commentLabelSize.width;
    CGFloat commentLabelHeight = commentLabelSize.height;
    _commentListFrame = CGRectMake(commentLabelX, commentLabelY, commentLabelWidth, commentLabelHeight);
    
    // row height
    _rowHeight = CGRectGetMaxY(_commentListFrame) + 0.8 * margin;
}

#pragma mark - Compute Text Size with String and Max Size and Font

- (CGSize)sizeWithText:(NSString *)text andMaxSize:(CGSize)maxSize andFont:(UIFont *)font {
    NSDictionary *attr = @{NSFontAttributeName: font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
}

@end
