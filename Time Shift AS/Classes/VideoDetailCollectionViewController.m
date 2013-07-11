//
//  VideoDetailCollectionViewController.m
//  Time Shift AS
//
//  Created by Ken Murphy on 7/2/13.
//  Copyright (c) 2013 Ken Murphy. All rights reserved.
//

/*
 NOTE ON STORYBOARD WORKAROUND FOR CELL LAYOUT PROBLEM
 
 There have been issues w/ the layout of the cells, where a cell
 ends up "under" its neighbor, leaving a blank space where it
 should be.  Attemtped various fixes disccussed here:
 
 http://stackoverflow.com/q/12927027/2547916
 
 These involved sublcassing UICollectionViewFlowLayout,
 but that seemed to introduce other issues (didn't
 seem to play nice with storyboard).
 
 Finally looked into this answer:
 
 http://stackoverflow.com/a/13289769/2547916
 
 "What works for me is to set bottom sectionInset to a value less than top inset."
 
 In storyboard size settings for the collection view,
 I bumped Top Inset from 0 to 1. This (so far) seemed to fix it!
 */

#import "VideoDetailCollectionViewController.h"
#import "VideoDetailCell.h"
#import "MyMapAnnotation.h"
#import "VideoPlayerViewController.h"
#import <MapKit/MapKit.h>
// DISABLING due to performance issues:
//#import <QuartzCore/QuartzCore.h>

@interface VideoDetailCollectionViewController () <UICollectionViewDataSource,UICollectionViewDelegate,VideoDetailCellDelegate,MKMapViewDelegate>

@end

@implementation VideoDetailCollectionViewController

/////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.itemListData count];
}

#define HTML_HEADER @"<html><head><style>body {font-size:14pt;font-family:sans-serif;}</style><head>"
#define HTML_FOOTER @"</head></html>"

-(NSString *)htmlify:(NSString *)bareHtml
{
    NSString *completeHtml = [NSString stringWithFormat:@"%@%@%@",HTML_HEADER,bareHtml,HTML_FOOTER];
    return completeHtml;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Video Detail Cell";
    VideoDetailCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    /* DISABLING due to performance issues:
    cell.layer.borderWidth = 2.0f;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.cornerRadius = 9.0f;
    */
    
     NSDictionary *item = [self.itemListData objectAtIndex:indexPath.row];
    
    cell.delegate = self;
    cell.mapView.delegate = self;
    cell.itemData = item;
    cell.movieTitle.text = [item objectForKey:@"title"];
    cell.location.text = [item objectForKey:@"location"];
    [cell.descriptionWebView loadHTMLString:[self htmlify:[item objectForKey:@"description"]] baseURL:nil];
    cell.thumbnailImage.image = [UIImage imageNamed:[item objectForKey:@"thumbnailFile"]];
    MyMapAnnotation *mma = [[MyMapAnnotation alloc] init];
    mma.title = [item objectForKey:@"title"];
    mma.coordinate =  CLLocationCoordinate2DMake([[item objectForKey:@"lat"] doubleValue],
                                                 [[item objectForKey:@"long"] doubleValue]);
    [cell.mapView removeAnnotations:cell.mapView.annotations];
    [cell.mapView addAnnotation:mma];
    cell.mapView.region = MKCoordinateRegionMakeWithDistance(mma.coordinate, 6000, 6000);
    
    return cell;
}

// UICollectionViewDelegate methods not needed

/////////////////////////////////////////////////////////////////////////
#pragma mark - MovieDetailCellDelegate

- (void)playButtonClickedInCell:(VideoDetailCell *)cell
{
    [self performSegueWithIdentifier:@"Play Video" sender:cell];
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

/////////////////////////////////////////////////////////////////////////
#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Play Video"]) {
        NSString *movieFileName = [[sender itemData] objectForKey:@"movieFile"];
        NSURL *url = [[NSBundle mainBundle] URLForResource:[movieFileName stringByDeletingPathExtension] withExtension:[movieFileName pathExtension]];
        [segue.destinationViewController setVideoURL:url];
    }
}

@end
