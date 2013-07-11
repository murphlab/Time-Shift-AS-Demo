//
//  MyNavigationController.m
//  Time Shift AS
//
//  Created by Ken Murphy on 6/13/13.
//  Copyright (c) 2013 Ken Murphy. All rights reserved.
//

#import "MyNavigationController.h"
#import "DataSingleton.h"
#import "VideoListTableViewController.h"
#import "MapViewController.h"

@interface MyNavigationController ()
@end

@implementation MyNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.tintColor = [UIColor darkGrayColor];
    
    DataSingleton *sharedDataSingleton = [DataSingleton sharedInstance];
    id rootVC = [self.viewControllers objectAtIndex:0];
    
    // could be assigning to VideoListTableViewController or MapViewController:
    // (using duck typing here but a protocol might have been good)
    if ([rootVC respondsToSelector:@selector(setItemListData:)])
        [rootVC setItemListData:sharedDataSingleton.data];
}

@end
