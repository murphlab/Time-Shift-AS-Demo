//
//  VideoPlayerViewController.m
//  Time Shift AS
//
//  Created by Ken Murphy on 6/25/13.
//  Copyright (c) 2013 Ken Murphy. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayerViewController ()
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;
@end

@implementation VideoPlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setAmbientAudioCategory];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self playMovie];
}

- (void)setAmbientAudioCategory
{
    /*
     Set AV session category to ambient, so that playing
     movies won't interrupt audio from other apps.
     This is based on the assumption that all movies
     are silent. This could change. Maybe programatically
     detect if the movie has audio and set the category
     appropriately?
     */
    
    NSError *setCategoryError = nil;
    BOOL success = [[AVAudioSession sharedInstance]
                    setCategory: AVAudioSessionCategoryAmbient
                    error: &setCategoryError];
    
    if (!success) {
        NSLog(@"Error trying to set category: %@", setCategoryError);
    }
}

- (void)playMovie
{
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.videoURL];
    [self.moviePlayer play];
    [self.view addSubview:self.moviePlayer.view];
    self.moviePlayer.view.frame = self.view.bounds;
    [self.moviePlayer setFullscreen:YES];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    // for when movie finishes by completing playback:
    [center addObserver:self
               selector:@selector(handleMoviePlayerFinish:)
                   name:MPMoviePlayerPlaybackDidFinishNotification
                 object:self.moviePlayer];
    
    // for when user clicks "done":
    [center addObserver:self
               selector:@selector(handleMoviePlayerFinish:)
                   name:MPMoviePlayerDidExitFullscreenNotification
                 object:self.moviePlayer];
    
    // app state notifiers:
    [center addObserver:self
               selector:@selector(appWillResignActive:)
                   name:UIApplicationWillResignActiveNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(appDidBecomeActive:)
                   name:UIApplicationDidBecomeActiveNotification
                 object:nil];
}

- (void)handleMoviePlayerFinish:(NSNotification *)notification
{    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    [center removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [center removeObserver:self name:MPMoviePlayerDidExitFullscreenNotification object:self.moviePlayer];
    
    [center removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [center removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self.moviePlayer setFullscreen:NO];
    [self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];
    self.moviePlayer = nil;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)appWillResignActive:(NSNotification *)notification
{
    [self.moviePlayer pause];
}

- (void)appDidBecomeActive:(NSNotification *)notification
{
    [self.moviePlayer play];
}

@end
