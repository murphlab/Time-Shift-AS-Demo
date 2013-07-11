//
//  VideoDetailCell.h
//  Time Shift AS
//
//  Created by Ken Murphy on 7/2/13.
//  Copyright (c) 2013 Ken Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol VideoDetailCellDelegate;

@interface VideoDetailCell : UICollectionViewCell
@property (weak,nonatomic) id <VideoDetailCellDelegate> delegate;
@property (nonatomic,strong)NSDictionary *itemData;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIWebView *descriptionWebView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@end

@protocol VideoDetailCellDelegate <NSObject>
- (void)playButtonClickedInCell:(VideoDetailCell *)cell;
@end