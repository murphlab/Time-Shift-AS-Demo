//
//  VideoItemTabelCell.h
//  Time Shift AS
//
//  Created by Ken Murphy on 6/14/13.
//  Copyright (c) 2013 Ken Murphy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoItemTabelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *videoTitle;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@end
