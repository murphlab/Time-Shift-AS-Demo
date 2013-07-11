//
//  VideoListTableViewController.m
//  Time Shift AS
//
//  Created by Ken Murphy on 6/12/13.
//  Copyright (c) 2013 Ken Murphy. All rights reserved.
//

#import "VideoListTableViewController.h"
#import "VideoItemTabelCell.h"
#import "VideoDetailViewController.h"

@interface VideoListTableViewController ()
@end

@implementation VideoListTableViewController

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemListData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Video List Item Cell";
    VideoItemTabelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *videoListItemDict = [self.itemListData objectAtIndex:indexPath.row];
    cell.videoTitle.text = [videoListItemDict objectForKey:@"title"];
    cell.thumbnail.image = [UIImage imageNamed:[videoListItemDict objectForKey:@"thumbnailFile"]];
    cell.location.text = [videoListItemDict objectForKey:@"location"];
    return cell;
}

// table view delegate methods not needed

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Detail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        [segue.destinationViewController setItemData:[self.itemListData objectAtIndex:indexPath.row]];
    }
}

@end
