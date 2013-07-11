//
//  MyMapAnnotation.h
//  Time Shift AS
//
//  Created by Ken Murphy on 6/15/13.
//  Copyright (c) 2013 Ken Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyMapAnnotation : NSObject <MKAnnotation>
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong) NSDictionary *itemData;
@end
