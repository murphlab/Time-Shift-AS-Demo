//
//  Data.m
//  Time Shift AS
//
//  Created by Ken Murphy on 6/12/13.
//  Copyright (c) 2013 Ken Murphy. All rights reserved.
//

#import "DataSingleton.h"

#define DATA_FILE @"TimeShiftData"

@implementation DataSingleton

// Method for obtaining singleton:

+ (DataSingleton *)sharedInstance
{
    static dispatch_once_t _singletonPredicate;
    static DataSingleton *sharedObject = nil;

    dispatch_once(&_singletonPredicate, ^{
        sharedObject = [[super allocWithZone:nil] init];
    });
    
    return sharedObject;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self loadData];
    }
    return self;
}

- (void)loadData
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:DATA_FILE withExtension:@"plist"];
    if (!url) [NSException raise:@"Could not open data file" format:@"Could not open data file %@.plist",DATA_FILE];
    NSArray *unsortedData = [[NSArray alloc] initWithContentsOfURL:url];
    self.data = [unsortedData sortedArrayUsingComparator: ^(id obj1, id obj2) {
        NSString *title1 = [obj1 objectForKey:@"title"];
        NSString *title2 = [obj2 objectForKey:@"title"];
        return [title1 compare:title2];
    }];
}

@end
