//
//  CCMeidaFormatFactoryTestController.m
//  CCKit_Example
//
//  Created by lucc on 2022/4/24.
//  Copyright © 2022 lucc. All rights reserved.
//

#import "CCMeidaFormatFactoryTestController.h"
#import <Masonry/Masonry.h>
#import "CCKit.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CCMediaFormatFactory.h"
#import "YYAnimatedImageView.h"
#import <YYImage/YYImage.h>

@interface CCMeidaFormatFactoryTestController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIButton *pickImgBtn;
@property (nonatomic, strong) UIButton *liveToGifBtn;
@property (nonatomic, strong) UIButton *liveToVideoBtn;
@property (nonatomic, strong) UIButton *gifToVideoBtn;
@property (nonatomic, strong) UIButton *videoToGifBtn;
@property (nonatomic, strong) UIButton *videoConverFormatBtn;
@property (nonatomic, strong) PHLivePhoto *selectLivePhoto;
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, copy) NSString *selectGifUrl;
@property (nonatomic, strong) YYAnimatedImageView *animationImageView;
@end

@implementation CCMeidaFormatFactoryTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.animationImageView];
    [self.animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.size.mas_equalTo(CGSizeMake(150, 150));
        make.centerX.mas_equalTo(0);
    }];
    [self.view addSubview:self.pickImgBtn];
    [self.pickImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-KSafeBottomHeight-20);
    }];
    [self.view addSubview:self.liveToGifBtn];
    [self.liveToGifBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo(self.pickImgBtn.mas_top).offset(-10);
    }];
    [self.view addSubview:self.liveToVideoBtn];
    [self.liveToVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo(self.liveToGifBtn.mas_top).offset(-10);
    }];
    [self.view addSubview:self.gifToVideoBtn];
    [self.gifToVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo(self.liveToVideoBtn.mas_top).offset(-10);
    }];
    [self.view addSubview:self.videoToGifBtn];
    [self.videoToGifBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo(self.gifToVideoBtn.mas_top).offset(-10);
    }];
    [self.view addSubview:self.videoConverFormatBtn];
    [self.videoConverFormatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.equalTo(self.videoToGifBtn.mas_top).offset(-10);
    }];
}

- (void)pickAction {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = NO;
    NSArray *mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeLivePhoto,(NSString *)kUTTypeGIF, (NSString *)kUTTypeVideo, (NSString *)kUTTypeMovie];
    imagePicker.mediaTypes = mediaTypes;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)convertLivePhotoToGif {
    if (!self.selectLivePhoto) {
        NSLog(@"You must select live photo first");
        return;
    }
    [CCMediaFormatFactory convertLivePhoto:self.selectLivePhoto toGif:nil scale:0.5 framesPerSecond:4 completion:^(NSString *url, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        YYImage *img = [YYImage imageWithContentsOfFile:url];
        self.animationImageView.image = img;
    }];
}

- (void)convertLivePhotoToVideo {
    if (!self.selectLivePhoto) {
        NSLog(@"You must select live photo first");
        return;
    }
    [CCMediaFormatFactory convertLivePhoto:self.selectLivePhoto toVideo:nil completion:^(NSString * url, NSError *error) {
        NSLog(@"url = %@, error = %@", url, error);
    }];
}

- (void)convertVideoToGif {
    if (!self.videoUrl) {
        NSLog(@"You must select video first");
        return;
    }
    [CCMediaFormatFactory convertVideo:self.videoUrl toGif:nil completion:^(NSString *url, NSError *error) {
        NSLog(@"url = %@, error = %@", url, error);
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        YYImage *img = [YYImage imageWithContentsOfFile:url];
        self.animationImageView.image = img;
    }];
}

- (void)convertGifToVideo {
    if (!self.selectGifUrl) {
        NSLog(@"You must select gif first");
        return;
    }
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:self.selectGifUrl options:NSDataReadingMappedIfSafe error:&error];
    [CCMediaFormatFactory convertGif:data toVideo:nil speed:1 size:CGSizeZero repeat:0 completion:^(NSString *url, NSError *error) {
        NSLog(@"url = %@, error = %@", url, error);
    }];
}

- (void)videoConverFormatAction {
    if (!self.videoUrl) {
        NSLog(@"You must select video first");
        return;
    }
    [CCMediaFormatFactory convertVideo:self.videoUrl to:nil outputFileType:CCVideoFileTypeMp4 presetType:CCExportPresetTypeMediumQuality completion:^(NSString * _Nullable url, NSError * _Nullable error) {
        NSLog(@"url = %@, error = %@", url, error);
    }];
}

#pragma mark - UIImagePickerController Delegate method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ( [mediaType isEqualToString:@"public.movie" ])
    {
        
        NSLog(@"Picked a movie at URL %@",  [info objectForKey:UIImagePickerControllerMediaURL]);
        NSURL *fileURL =  [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"> %@", [fileURL absoluteString]);
        self.videoUrl = fileURL;
    } else {
        PHLivePhoto *livePhoto = [info objectForKey:UIImagePickerControllerLivePhoto];
        if(livePhoto) {
            self.selectLivePhoto = livePhoto;
        } else {
            NSURL *referenceUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
            if ([referenceUrl.absoluteString containsString:@"=GIF"]) {
                NSURL *url = [info objectForKey:UIImagePickerControllerImageURL];
                self.selectGifUrl = url.relativePath;
                YYImage *img = [YYImage imageWithContentsOfFile:self.selectGifUrl];
                self.animationImageView.image = img;
                return;
            }
            // create an alert view
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Not a Live Photo" message:@"Sadly this is a standard UIImage so we can't show it in our Live Photo View. Try another one." preferredStyle:UIAlertControllerStyleAlert];
            
            // add a single action
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Thanks, Phone!" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:action];
            
            // and display it
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

#pragma mark - Getter

- (UIButton *)pickImgBtn {
    if (!_pickImgBtn) {
        _pickImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pickImgBtn setTitle:@"选取图片" forState:UIControlStateNormal];
        [_pickImgBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _pickImgBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _pickImgBtn.backgroundColor = UIColor.redColor;
        _pickImgBtn.layer.cornerRadius = 0.0f;
        [_pickImgBtn addTarget:self action:@selector(pickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pickImgBtn;
}

- (UIButton *)liveToGifBtn {
    if (!_liveToGifBtn) {
        _liveToGifBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_liveToGifBtn setTitle:@"Live to Gif" forState:UIControlStateNormal];
        [_liveToGifBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _liveToGifBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _liveToGifBtn.backgroundColor = UIColor.yellowColor;
        _liveToGifBtn.layer.cornerRadius = 0.0f;
        [_liveToGifBtn addTarget:self action:@selector(convertLivePhotoToGif) forControlEvents:UIControlEventTouchUpInside];
    }
    return _liveToGifBtn;
}

- (UIButton *)liveToVideoBtn {
    if (!_liveToVideoBtn) {
        _liveToVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_liveToVideoBtn setTitle:@"Live to Video" forState:UIControlStateNormal];
        [_liveToVideoBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _liveToVideoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _liveToVideoBtn.backgroundColor = UIColor.yellowColor;
        _liveToVideoBtn.layer.cornerRadius = 0.0f;
        [_liveToVideoBtn addTarget:self action:@selector(convertLivePhotoToVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _liveToVideoBtn;
}

- (UIButton *)gifToVideoBtn {
    if (!_gifToVideoBtn) {
        _gifToVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gifToVideoBtn setTitle:@"Gif to Video" forState:UIControlStateNormal];
        [_gifToVideoBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _gifToVideoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _gifToVideoBtn.backgroundColor = UIColor.greenColor;
        _gifToVideoBtn.layer.cornerRadius = 0.0f;
        [_gifToVideoBtn addTarget:self action:@selector(convertGifToVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gifToVideoBtn;
}

- (UIButton *)videoToGifBtn {
    if (!_videoToGifBtn) {
        _videoToGifBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoToGifBtn setTitle:@"Video to Gif" forState:UIControlStateNormal];
        [_videoToGifBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _videoToGifBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _videoToGifBtn.backgroundColor = UIColor.blueColor;
        _videoToGifBtn.layer.cornerRadius = 0.0f;
        [_videoToGifBtn addTarget:self action:@selector(convertVideoToGif) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoToGifBtn;
}

- (UIButton *)videoConverFormatBtn {
    if (!_videoConverFormatBtn) {
        _videoConverFormatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_videoConverFormatBtn setTitle:@"Video to video" forState:UIControlStateNormal];
        [_videoConverFormatBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _videoConverFormatBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _videoConverFormatBtn.backgroundColor = UIColor.blueColor;
        _videoConverFormatBtn.layer.cornerRadius = 0.0f;
        [_videoConverFormatBtn addTarget:self action:@selector(videoConverFormatAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoConverFormatBtn;
}

- (YYAnimatedImageView *)animationImageView {
    if (!_animationImageView) {
        _animationImageView = [[YYAnimatedImageView alloc] init];
        _animationImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _animationImageView;
}

@end
