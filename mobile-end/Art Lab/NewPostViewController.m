//
//  NewPostViewController.m
//  Art Lab
//
//  Created by 李俊宏 on 2021/7/27.
//

#import "NewPostViewController.h"
#import "NSString+Random.h"
#import "Post.h"
#import "PostFrame.h"
#import "NSString+Sandbox.h"
#import "UIColor+Hex.h"

#define kPostTextViewPlaceHolder @"Let's share..."

@interface NewPostViewController () <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(weak, nonatomic) IBOutlet UITextView *postTextView;
@property(weak, nonatomic) IBOutlet UIButton *postPictureButton;
@property(weak, nonatomic) IBOutlet UIButton *sendButton;

@property(nonatomic, copy) NSString *postText;
@property(nonatomic, copy) NSString *postPicturePath;

@end

@implementation NewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Set Text View
    self.postTextView.delegate = self;
    [self textViewShouldEndEditing:self.postTextView];
    // Set Send Button
    [self.sendButton setEnabled:NO];
    // Picture Button
    self.postPictureButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    // Set Tap Action
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditingWithTap)];
    [self.view addGestureRecognizer:tap];
}

- (void)endEditingWithTap {
    [self.view endEditing:YES];
}

- (IBAction)backButtonDidClick:(id)sender {
    if (self.postTextView.text.length == 0 && self.postPicturePath == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Want to leave?" message:@"Your text will not be saved." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *leaveAction = [UIAlertAction actionWithTitle:@"Leave" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:leaveAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)sendButtonDidClick:(id)sender {
    /**
     * Send New Post
     * NSString *text;
     * NSString *icon;
     * NSString *picture;
     * NSString *name;
     */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults stringForKey:@"name"] != nil) {

    }
    NSString *name = [userDefaults stringForKey:@"nickName"];
    if (name == nil) {
        name = @"游客";
    }
    NSString *icon = [userDefaults stringForKey:@"iconBase64"];
    if (icon == nil) {
        icon = @"user_default";
    }
    NSDictionary *dictionary = @{
            @"text": self.postText,
            @"icon": icon,
            @"picture": self.postPicturePath != nil ? self.postPicturePath : [NSNull null],
            @"name": name
    };
    Post *post = [Post postWithDict:dictionary];
    PostFrame *postFrame = [[PostFrame alloc] init];
    postFrame.post = post;
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.sendPostBlock) {
            self.sendPostBlock(postFrame);
        }
    }];
}

- (IBAction)postImageButtonDidClick:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - Image Picker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSString *imageTempPath = [[[NSString randomFileName] stringByAppendingString:@".png"] appendTemp];
    // NSLog(@"%@", imageTempPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createFileAtPath:imageTempPath contents:UIImagePNGRepresentation(image) attributes:nil];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.postPictureButton setImage:image forState:UIControlStateNormal];
        self.postPicturePath = imageTempPath;
    }];
}


#pragma mark - TextView Delegate

- (void)textViewDidChange:(UITextView *)textView {
    if (self.postTextView.text.length == 0) {
        [self.sendButton setEnabled:NO];
        // self.sendButton.titleLabel.textColor = [UIColor colorWithHexString:@"#C7C4CC" alpha:1.0];
    } else {
        [self.sendButton setEnabled:YES];
        // self.sendButton.titleLabel.textColor = [UIColor colorWithHexString:@"#8B5CFF" alpha:1.0];
    }
    self.postText = self.postTextView.text;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:kPostTextViewPlaceHolder]) {
        textView.text = nil;
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = kPostTextViewPlaceHolder;
        textView.textColor = [UIColor lightGrayColor];
    }
    return YES;
}

@end
