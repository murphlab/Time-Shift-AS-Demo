//
//  VideoDetailViewController.m
//  Time Shift AS
//
//  Created by Ken Murphy on 6/13/13.
//  Copyright (c) 2013 Ken Murphy. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "VideoDetailViewController.h"
#import "MyMapAnnotation.h"
#import "VideoPlayerViewController.h"

@interface VideoDetailViewController () <UIWebViewDelegate,UIScrollViewDelegate,MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIWebView *descriptionWebView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation VideoDetailViewController

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    _mapView.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.delegate = self;
    self.descriptionWebView.delegate = self;
    self.title = [self.itemData objectForKey:@"title"];
    self.videoTitle.text = self.title;
    self.location.text = [self.itemData objectForKey:@"location"];
    self.thumbnail.image = [UIImage imageNamed:[self.itemData objectForKey:@"thumbnailFile"]];
    [self.descriptionWebView loadHTMLString:[self htmlify:[self.itemData objectForKey:@"description"]] baseURL:nil];
    if (self.mapView) {
        MyMapAnnotation *mma = [[MyMapAnnotation alloc] init];
        mma.title = [self.itemData objectForKey:@"title"];
        mma.coordinate =  CLLocationCoordinate2DMake([[self.itemData objectForKey:@"lat"] doubleValue],
                                                     [[self.itemData objectForKey:@"long"] doubleValue]);
        [self.mapView addAnnotation:mma];
        self.mapView.region = MKCoordinateRegionMakeWithDistance(mma.coordinate, 6000, 6000);
    }
}

#define HTML_HEADER @"<html><head><style>body {font-size:12pt;font-family:sans-serif;}</style><head>"
#define HTML_FOOTER @"</head></html>"

-(NSString *)htmlify:(NSString *)bareHtml
{
    NSString *completeHtml = [NSString stringWithFormat:@"%@%@%@",HTML_HEADER,bareHtml,HTML_FOOTER];
    return completeHtml;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self resizeWebView:self.descriptionWebView];
        [self adjustScrollViewContentSize];
    }
}


- (void)resizeWebView:(UIWebView *)aWebView
{
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;
}

- (void)adjustScrollViewContentSize
{
    CGRect contentRect = CGRectZero;
    for (UIView *subview in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, subview.frame);
    }
    self.scrollView.contentSize = contentRect.size;
}

- (IBAction)playButtonTapped:(UIButton *)sender {
    [self playMovie];
}

- (IBAction)okButtonTapped:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

/////////////////////////////////////////////////////////////////////////
#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self resizeWebView:aWebView];
        [self adjustScrollViewContentSize];
    }
}

/////////////////////////////////////////////////////////////////////////
#pragma mark Movie playing methods

- (void)playMovie
{
    [self performSegueWithIdentifier:@"Play Video" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Play Video"]) {
        NSString *movieFileName = [self.itemData objectForKey:@"movieFile"];
        NSURL *url = [[NSBundle mainBundle] URLForResource:[movieFileName stringByDeletingPathExtension] withExtension:[movieFileName pathExtension]];
        [segue.destinationViewController setVideoURL:url];
    }
}

/////////////////////////////////////////////////////////////////////////
#pragma mark - MKMapViewDelegate

#define REUSE_ID @"MKView"

- (MKAnnotationView *)mapView:(MKMapView *)sender
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *aView = [sender dequeueReusableAnnotationViewWithIdentifier:REUSE_ID];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                reuseIdentifier:REUSE_ID];
        aView.canShowCallout = NO;

    }
    aView.annotation = annotation; // yes, this happens twice if no dequeue
    return aView;
}

@end
