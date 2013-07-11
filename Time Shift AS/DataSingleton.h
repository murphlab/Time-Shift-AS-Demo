//
//  Data.h
//  Time Shift AS
//
//  Created by Ken Murphy on 6/12/13.
//  Copyright (c) 2013 Ken Murphy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSingleton : NSObject

@property (nonatomic,strong) NSArray *data;

+ (DataSingleton *)sharedInstance;

@end
