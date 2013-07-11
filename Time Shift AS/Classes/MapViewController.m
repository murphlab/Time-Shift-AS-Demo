//
//  MapViewController.m
//  Time Shift AS
//
//  Created by Ken Murphy on 6/13/13.
//  Copyright (c) 2013 Ken Murphy. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "MyMapAnnotation.h"

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showAllBarButtonItem;
@property (nonatomic) BOOL viewHasAppeared;
@end

@implementation MapViewController

- (void)loadAnnotationsFromModel
{
    for (NSDictionary *item in self.itemListData) {
        MyMapAnnotation *mma = [[MyMapAnnotation alloc] init];
        mma.title = [item objectForKey:@"title"];
        mma.coordinate =  CLLocationCoordinate2DMake([[item objectForKey:@"lat"] doubleValue],
                                                     [[item objectForKey:@"long"] doubleValue]);
        mma.itemData = item;
        [self.mapView addAnnotation:mma];
    }
}

- (void)updateMapView
{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.itemListData) [self loadAnnotationsFromModel];
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    _mapView.delegate = self;
    [self updateMapView];
}

- (void)setItemListData:(NSArray *)itemListData
{
    _itemListData = itemListData;
    [self updateMapView];
}

#define PADDING_FACTOR 1.1;
- (void)calulateRegionAnimated:(BOOL)animated
{
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees maxLong = -180;
    CLLocationDegrees minLong = 180;
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        if (annotation.coordinate.latitude > maxLat) maxLat = annotation.coordinate.latitude;
        if (annotation.coordinate.longitude > maxLong) maxLong = annotation.coordinate.longitude;
        if (annotation.coordinate.latitude < minLat) minLat = annotation.coordinate.latitude;
        if (annotation.coordinate.longitude < minLong) minLong = annotation.coordinate.longitude;
    }
    MKCoordinateSpan span;
    span.latitudeDelta =  ( maxLat - minLat );
    span.longitudeDelta = ( maxLong - minLong );
    CLLocationCoordinate2D center;
    center.latitude = minLat + span.latitudeDelta / 2;
    center.longitude = minLong + span.longitudeDelta / 2;
    span.latitudeDelta *= PADDING_FACTOR;
    span.longitudeDelta *= PADDING_FACTOR;
    MKCoordinateRegion region;
    region.center = center;
    region.span = span;
    [self.mapView setRegion:region animated:animated];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.viewHasAppeared) [self calulateRegionAnimated:NO];
    self.viewHasAppeared = YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    NSSet *visibleAnnotations = [self.mapView annotationsInMapRect:[self.mapView visibleMapRect]];
    [self updateShowAllButtonWithVisibleAnnotations:visibleAnnotations];
}

- (IBAction)showAllBarButtonItemClicked:(UIBarButtonItem *)sender {
    [self calulateRegionAnimated:YES];
    NSSet *visibleAnnotations = [self.mapView annotationsInMapRect:[self.mapView visibleMapRect]];
    [self updateShowAllButtonWithVisibleAnnotations:visibleAnnotations];
}

/////////////////////////////////////////////////////////////////////////
#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSSet *visibleAnnotations = [self.mapView annotationsInMapRect:[self.mapView visibleMapRect]];
    [self updateShowAllButtonWithVisibleAnnotations:visibleAnnotations];
}

-(void)updateShowAllButtonWithVisibleAnnotations:(NSSet *)visibleAnnotations
{
    int visibleAnnotationCount = visibleAnnotations.count;
    BOOL newHiddenState = visibleAnnotationCount == self.itemListData.count;
    self.showAllBarButtonItem.enabled = !newHiddenState;
    //TODO: why does this animation not work?
    /*
    if (newHiddenState != self.showAllButton.hidden) {
        [UIView animateWithDuration:3.0
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{ self.showAllButton.hidden = newHiddenState; }
                         completion:nil];
    }
     */
}

#define REUSE_ID @"MKView"

- (MKAnnotationView *)mapView:(MKMapView *)sender
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *aView = [sender dequeueReusableAnnotationViewWithIdentifier:REUSE_ID];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                         reuseIdentifier:REUSE_ID];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,53,30)];
        UIButtonType buttonType = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? UIButtonTypeInfoLight : UIButtonTypeDetailDisclosure;
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:buttonType];
    }
    aView.annotation = annotation; // yes, this happens twice if no dequeue
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    return aView;
}

- (void)mapView:(MKMapView *)sender didSelectAnnotationView:(MKAnnotationView *)aView {
    if ([aView.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {    
        NSString *thumbFileName = [[((MyMapAnnotation *)aView.annotation) itemData] objectForKey:@"thumbnailFile"];
        [(UIImageView *)aView.leftCalloutAccessoryView setImage:[UIImage imageNamed:thumbFileName]];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"Show Detail" sender:view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Detail"]) {
        MKAnnotationView *view = (MKAnnotationView *)sender;
        [segue.destinationViewController setItemData:[(MyMapAnnotation *)view.annotation itemData]];
    }
}

@end
