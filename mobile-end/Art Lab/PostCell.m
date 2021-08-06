//
//  PostCell.m
//  Art Lab
//
//  Created by 李俊宏 on 2021/6/18.
//

#import "Post.h"
#import "PostFrame.h"
#import "PostCell.h"
#import "UIImage+Base64Encoding.h"
#import "UIColor+Hex.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface PostCell () <UITextFieldDelegate>

@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UILabel *nickNameLabel;
@property (nonatomic, weak) UILabel *postContentLabel;
@property (nonatomic, weak) UIImageView *pictureImageView;
@property (nonatomic, weak) UIButton *likeButton;
@property (nonatomic, weak) UIButton *forwardButton;
@property (nonatomic, weak) UITextField *commentTextField;
@property (nonatomic, weak) UILabel *commentLabel;

@property (nonatomic, assign) BOOL like;
@property (nonatomic, assign) BOOL collect;

@end

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Rewrite postFrame set method
- (void)setPostFrame:(PostFrame *)postFrame {
    _postFrame = postFrame;
    [self setCellData];
    [self setCellFrame];
}

- (void)setCellData {
    Post *model = self.postFrame.post;
    // icon
    self.iconImageView.image = [UIImage imageWithBase64Encoding:model.icon];
    if (self.iconImageView.image == nil) {
        self.iconImageView.image = [UIImage imageNamed:model.icon];
    }
    // nick name
    self.nickNameLabel.text = model.name;
    // text
    self.postContentLabel.text = model.text;
    // picture
    if (model.picture) {
        self.pictureImageView.image = [UIImage imageWithContentsOfFile:model.picture];
        if (self.pictureImageView.image != nil) {
            // NSLog(@"加载了真数据");
        } else {
            self.pictureImageView.image = [UIImage imageNamed:model.picture];
            // NSLog(@"加载了假数据");
        }
        self.pictureImageView.hidden = NO;
    } else {
        self.pictureImageView.hidden = YES;
    }
    // comment label
    NSMutableString *commentLabelText = [NSMutableString string];
    for (NSString *comment in model.commentArray) {
        [commentLabelText appendFormat:@"%@\n", comment];
    }
    self.commentLabel.text = [commentLabelText copy];
}

- (void)setCellFrame {
    // icon
    self.iconImageView.frame = self.postFrame.iconFrame;
    self.iconImageView.layer.cornerRadius = self.postFrame.iconFrame.size.width * 0.5;
    self.iconImageView.layer.masksToBounds = YES;
    // nick name
    self.nickNameLabel.frame = self.postFrame.nameFrame;
    // text
    self.postContentLabel.frame = self.postFrame.textFrame;
    // picture
    self.pictureImageView.frame = self.postFrame.picFrame;
    // like
    self.likeButton.frame = self.postFrame.likeFrame;
    // collect
    self.forwardButton.frame = self.postFrame.forwardFrame;
    // comment text field
    self.commentTextField.frame = self.postFrame.commentInputFrame;
    // comment label
    self.commentLabel.frame = self.postFrame.commentListFrame;
}

#pragma mark - Rewrite initWithStyle:reuseIndreuseIdentifier: method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // create child controls
        // icon
        UIImageView *imageViewIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:imageViewIcon];
        self.iconImageView = imageViewIcon;
        
        // nick name
        UILabel *labelNickName = [[UILabel alloc] init];
        labelNickName.font = kNameFont;
        labelNickName.textColor = [UIColor colorWithHexString:@"#696173" alpha:1.0];
        [self.contentView addSubview:labelNickName];
        self.nickNameLabel = labelNickName;
        
        // text
        UILabel *postContentLabel = [[UILabel alloc] init];
        // set text attributes
        postContentLabel.font = kTextFont;
        postContentLabel.numberOfLines = 0;
        [self.contentView addSubview:postContentLabel];
        self.postContentLabel = postContentLabel;
        
        // picture
        UIImageView *imageViewPicture = [[UIImageView alloc] init];
        imageViewPicture.contentMode = UIViewContentModeScaleAspectFill;
        imageViewPicture.layer.cornerRadius = 25;
        imageViewPicture.layer.masksToBounds = YES;
        // imageViewPicture.layer.shadowOffset = CGSizeMake(5, 5);
        imageViewPicture.layer.shadowColor = [UIColor colorWithHexString:@"#696173" alpha:1.0].CGColor;
        imageViewPicture.layer.shadowOpacity = 1.0;
        [self.contentView addSubview:imageViewPicture];
        self.pictureImageView = imageViewPicture;
        
        // like
        UIButton *likeButton = [[UIButton alloc] init];
        [likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        [likeButton addTarget:self action:@selector(likeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:likeButton];
        self.likeButton = likeButton;
        self.like = NO;

        // forward
        UIButton *forwardButton = [[UIButton alloc] init];
        [forwardButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [forwardButton addTarget:self action:@selector(collectButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:forwardButton];
        self.forwardButton = forwardButton;

        // comment input
        UITextField *commentTextField = [[UITextField alloc] init];
        commentTextField.delegate = self;
        commentTextField.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.6];
        commentTextField.layer.cornerRadius = 10;
        commentTextField.layer.masksToBounds = YES;
        // commentTextField.background = [UIImage imageNamed:@"text_field_bg"];
        // commentTextField.background.CGImage = [UIImage imageNamed:@"text_field_bg"].CGImage;
        
        [self.contentView addSubview:commentTextField];
        self.commentTextField = commentTextField;

        // comment label;
        UILabel *commentLabel = [[UILabel alloc] init];
        commentLabel.numberOfLines = 0;
        commentLabel.font = kTextFont;
        [self.contentView addSubview:commentLabel];
        self.commentLabel = commentLabel;
        
        // view
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#8B5CFF" alpha:0.3];
        self.contentView.layer.cornerRadius = 25;
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.contentView.layer.borderWidth = 10;
        self.contentView.layer.masksToBounds = YES;
    }
    return self;
}

+ (instancetype)postCellWithTableView:(UITableView *)tableView {
    static NSString *reuseID = @"post_cell";
    PostCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    return cell;
}

- (void)likeButtonDidClick:(UIButton *)sender {
    if (self.like) {
        [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"like_fill"] forState:UIControlStateNormal];
    }
    self.like = !self.like;
}

- (void)collectButtonDidClick:(UIButton *)sender {
//    if (self.collect) {
//        [sender setImage:[UIImage systemImageNamed:@"arrowshape.turn.up.forward"] forState:UIControlStateNormal];
//    } else {
//        [sender setImage:[UIImage systemImageNamed:@"arrowshape.turn.up.forward.fill"] forState:UIControlStateNormal];
//    }
//    self.collect = !self.collect;
    [SVProgressHUD showSuccessWithStatus:@"Forwarded"];
    [SVProgressHUD dismissWithDelay:1.0];
}

#pragma mark - Text Field Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSMutableArray<NSString *> *commentArray = [NSMutableArray arrayWithArray:self.postFrame.post.commentArray];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [commentArray addObject:[NSString stringWithFormat:@"%@: %@", [userDefaults objectForKey:@"nickName"], textField.text]];
    Post *post = self.postFrame.post;
    post.commentArray = commentArray;
    PostFrame *postFrame = [[PostFrame alloc] init];
    [postFrame setPost:post];
    [self setPostFrame:postFrame];
    textField.text = nil;
    [self endEditing:YES];
    return YES;
}

@end
