//
//  VideoDetailCell.m
//  Time Shift AS
//
//  Created by Ken Murphy on 7/2/13.
//  Copyright (c) 2013 Ken Murphy. All rights reserved.
//

#import "VideoDetailCell.h"

@implementation VideoDetailCell

- (IBAction)playButtonClicked:(id)sender {
    [self.delegate playButtonClickedInCell:self];
}

@end
