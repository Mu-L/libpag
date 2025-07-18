/////////////////////////////////////////////////////////////////////////////////////////////////
//
//  Tencent is pleased to support the open source community by making libpag available.
//
//  Copyright (C) 2021 Tencent. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file
//  except in compliance with the License. You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  unless required by applicable law or agreed to in writing, software distributed under the
//  license is distributed on an "as is" basis, without warranties or conditions of any kind,
//  either express or implied. see the license for the specific language governing permissions
//  and limitations under the license.
//
/////////////////////////////////////////////////////////////////////////////////////////////////

#import "ViewController.h"
#import "BackgroundView.h"
#import <libpag/PAGView.h>
#import <libpag/PAGImageView.h>
#import <libpag/PAGDiskCache.h>

#define SCREEN_WIDTH       [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT      [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (nonatomic, weak) IBOutlet BackgroundView* bgView;
@property (nonatomic, strong) UIButton* firstButton;
@property (nonatomic, strong) UIButton* secondButton;
@property (nonatomic, strong) PAGView* pagView;
@property (nonatomic, strong) UIView* pagImageViewGroup;

@end

@implementation ViewController


/**
 * Notifies the start of the animation.
 */
- (void)onAnimationStart:(PAGView*)pagView {
//    NSLog(@"[ViewController onAnimationStart]");
}

/**
 * Notifies the end of the animation.
 */
- (void)onAnimationEnd:(PAGView*)pagView {
//    NSLog(@"[ViewController onAnimationEnd]");
}

/**
 * Notifies the cancellation of the animation.
 */
- (void)onAnimationCancel:(PAGView*)pagView {
//    NSLog(@"[ViewController onAnimationCancel]");
}

/**
 * Notifies the repetition of the animation.
 */
- (void)onAnimationRepeat:(PAGView*)pagView {
//    NSLog(@"[ViewController onAnimationRepeat]");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.tintColor = [UIColor colorWithRed:0.00 green:0.35 blue:0.85 alpha:1.00];
    
    CGFloat safeDistanceBottom = [self getSafeDistanceBottom];
    CGFloat buttonHeight = 50;
    self.firstButton = [[UIButton alloc] init];
    self.firstButton.frame = CGRectMake(0, SCREEN_HEIGHT- safeDistanceBottom - buttonHeight, SCREEN_WIDTH / 2 , buttonHeight);
    [self.firstButton setTitle:@"PAGView" forState:UIControlStateNormal];
    self.firstButton.layer.cornerRadius = 20;
    self.firstButton.layer.masksToBounds = YES;
    [self.firstButton setBackgroundColor:[UIColor colorWithRed:0 green:90.0/255 blue:217.0/255 alpha:1.0]];
    [self.firstButton addTarget:self action:@selector(firstButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.firstButton setUserInteractionEnabled:YES];
    [self.view addSubview:self.firstButton];
    
    self.secondButton = [[UIButton alloc] init];
    self.secondButton.frame = CGRectMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT- safeDistanceBottom - buttonHeight, SCREEN_WIDTH / 2 , buttonHeight);
    [self.secondButton setTitle:@"PAGImageView" forState:UIControlStateNormal];
    self.secondButton.layer.cornerRadius = 20;
    self.secondButton.layer.masksToBounds = YES;
    [self.secondButton setBackgroundColor:[UIColor grayColor]];
    [self.secondButton setUserInteractionEnabled:YES];
    [self.view addSubview:self.secondButton];
    [self.secondButton addTarget:self action:@selector(secondButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self addPAGViewAndPlay];
}

- (void)addPAGViewAndPlay {
    if (self.pagView == nil) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"alpha" ofType:@"pag"];
        PAGFile* pagFile = [PAGFile Load:path];
        if ([pagFile numTexts] > 0) {
            PAGText* textData = [pagFile getTextData:0];
            textData.text = @"hah哈 哈哈👩🏼‍❤️‍👨🏽哈哈👌하";
            [pagFile replaceText:0 data:textData];
        }

        if ([pagFile numImages] > 0) {
            NSString* filePath = [[NSBundle mainBundle] pathForResource:@"mountain" ofType:@"jpg"];
            PAGImage* pagImage = [PAGImage FromPath:filePath];
            if (pagImage) {
                [pagFile replaceImage:0 data:pagImage];
            }
        }
        self.pagView = [[PAGView alloc] init];
        [self.view addSubview:self.pagView];
        [self bringButtonsToFront];
        
        self.pagView.frame = self.view.frame;
        [self.pagView setComposition:pagFile];
        [self.pagView setRepeatCount:-1];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pagViewClicked)];
        [self.pagView addGestureRecognizer:tap];
        [self.pagView addListener:self];
        [self.pagView play];
    }
}

- (void)addPAGImageViewsAndPlay {
    if (self.pagImageViewGroup == nil) {
        self.pagImageViewGroup = [[UIView alloc] init];
        self.pagImageViewGroup.frame = self.view.frame;
        [self.view addSubview:self.pagImageViewGroup ];
        float startY = 100;
        float itemWidth = SCREEN_WIDTH / 4;
        float itemHeight = itemWidth;
        for (int i = 0; i < 20; i++) {
            PAGImageView* pagImageView = [[PAGImageView alloc] initWithFrame:CGRectMake(itemWidth * (i % 4), (i / 4) * itemHeight + startY, itemWidth, itemHeight)];
            NSString* path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", i] ofType:@"pag" inDirectory:@"list"];
            [pagImageView setPath:path];
            [self.pagImageViewGroup addSubview:pagImageView];
            [pagImageView setRepeatCount:-1];
            [pagImageView play];
        }
        [self.view addSubview:self.pagImageViewGroup];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pagImageViewClicked)];
        [self.pagImageViewGroup addGestureRecognizer:tap];
        [self bringButtonsToFront];
    }
}

- (CGFloat)getSafeDistanceBottom {
    if (@available(iOS 13.0, *)) {
        NSSet *set = [UIApplication sharedApplication].connectedScenes;
        UIWindowScene *windowScene = [set anyObject];
        UIWindow *window = windowScene.windows.firstObject;
        return window.safeAreaInsets.bottom;
    } else if (@available(iOS 11.0, *)) {
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        return window.safeAreaInsets.bottom;
    }
    return 0;
}

- (void)pagViewClicked{
    if (self.pagView.isPlaying) {
        [self.pagView stop];
    } else {
        [self.pagView play];
    }
}

- (void)pagImageViewClicked{
    [PAGDiskCache RemoveAll];
    
    NSString *message = @"Disk Cache Removed!";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    auto duration = NSEC_PER_SEC / 2;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)firstButtonClicked {
    if (self.pagImageViewGroup) {
        [self.pagImageViewGroup removeFromSuperview];
        self.pagImageViewGroup = nil;
        [self.secondButton setBackgroundColor:[UIColor grayColor]];
    }
    if (self.pagView == nil) {
        [self addPAGViewAndPlay];
        [self.firstButton setBackgroundColor:[UIColor colorWithRed:0 green:90.0/255 blue:217.0/255 alpha:1.0]];
    }
}

- (void)secondButtonClicked{
    if (self.pagView) {
        [self.pagView removeFromSuperview];
        [self.pagView freeCache];
        self.pagView = nil;
        [self.firstButton setBackgroundColor:[UIColor grayColor]];
    }
    if (self.pagImageViewGroup == nil) {
        [self addPAGImageViewsAndPlay];
    }
    [self.secondButton setBackgroundColor:[UIColor colorWithRed:0 green:90.0/255 blue:217.0/255 alpha:1.0]];
}

- (void)bringButtonsToFront {
    [self.view bringSubviewToFront:self.firstButton];
    [self.view bringSubviewToFront:self.secondButton];
}

@end
