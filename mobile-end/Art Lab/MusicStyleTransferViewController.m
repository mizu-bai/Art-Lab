//
//  MusicStyleTransferViewController.m
//  Art Lab
//
//  Created by mizu bai on 2021/7/30.
//

#import "MusicStyleTransferViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <SVProgressHUD.h>

#define kPlayImage [UIImage systemImageNamed:@"play.fill"]
#define kPauseImage [UIImage systemImageNamed:@"pause.fill"]

@interface MusicStyleTransferViewController () <AVAudioPlayerDelegate, UIDocumentPickerDelegate>

@property(weak, nonatomic) IBOutlet UIButton *playButton;
@property(weak, nonatomic) IBOutlet UIButton *backwardButton;
@property(weak, nonatomic) IBOutlet UIButton *forwardButton;
@property(weak, nonatomic) IBOutlet UISlider *progressSlider;

@property (nonatomic, copy) NSString *styleAudioFilePath;
@property (nonatomic, copy) NSString *contentAudioFilePath;
@property (nonatomic, copy) NSString *stylizedAudioFilePath;
@property (nonatomic, copy) NSURL *stylizedAudioFileURL;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation MusicStyleTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [SVProgressHUD showInfoWithStatus:@"Converting..."];
    [SVProgressHUD dismissWithDelay:1.0 completion:nil];
    [self stylize];
    self.stylizedAudioFileURL = [NSURL fileURLWithPath:self.stylizedAudioFilePath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.stylizedAudioFileURL error:NULL];
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
}

- (IBAction)playButtonDidClick:(id)sender {
    if (self.audioPlayer.isPlaying) {
        // Pause
        [self.playButton setImage:kPlayImage forState:UIControlStateNormal];
        [self.audioPlayer pause];
        [self.timer invalidate];
    } else {
        // Play
        [self.playButton setImage:kPauseImage forState:UIControlStateNormal];
        [self.audioPlayer play];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(refreshTimelineSlider) userInfo:nil repeats:YES];
    }
}

- (IBAction)backwardButtonDidClick:(id)sender {
    double currentTime = self.audioPlayer.currentTime;
    double backwardTime = currentTime - 15.0;
    if (backwardTime < 0) {
        backwardTime = 0;
    }
    [self.audioPlayer setCurrentTime:backwardTime];
    [self refreshTimelineSlider];
}

- (IBAction)forwardButtonDidClick:(id)sender {
    double currentTime = self.audioPlayer.currentTime;
    double forwardTime = currentTime + 15.0;
    if (forwardTime > self.audioPlayer.duration) {
        forwardTime = self.audioPlayer.duration;
    }
    [self.audioPlayer setCurrentTime:forwardTime];
    [self refreshTimelineSlider];
}

- (IBAction)progressSliderDidChange:(id)sender {
    double currentTime = self.audioPlayer.duration * self.progressSlider.value;
    [self.audioPlayer setCurrentTime:currentTime];
}

- (void)refreshTimelineSlider {
    float progress = (float) (self.audioPlayer.currentTime / self.audioPlayer.duration);
    [self.progressSlider setValue:progress animated:YES];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.audioPlayer = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.stylizedAudioFileURL error:NULL];
    [self playButtonDidClick:nil];
    [UIView animateWithDuration:0.2 animations:^{
        self.progressSlider.value = 0.0;
    }];
}

- (void)stylize {
    self.stylizedAudioFilePath = [[NSBundle mainBundle] pathForResource:@"Akaneya Himika Yukinohana.mp3" ofType:nil];
}

#pragma mark - Save
- (IBAction)saveButtonDidClick:(id)sender {
    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initForExportingURLs:@[self.stylizedAudioFileURL] asCopy:YES];
    documentPickerViewController.delegate = self;
    documentPickerViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentPickerViewController animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    [SVProgressHUD showInfoWithStatus:@"Saved"];
    [SVProgressHUD dismissWithDelay:1.0 completion:nil];
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    [SVProgressHUD showInfoWithStatus:@"Cancelled"];
    [SVProgressHUD dismissWithDelay:1.0 completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.audioPlayer stop];
}

@end
