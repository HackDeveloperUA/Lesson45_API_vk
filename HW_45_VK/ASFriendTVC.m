//
//  ASFriendTVC.m
//  HW_45_VK
//
//  Created by MD on 31.08.15.
//  Copyright (c) 2015 MD. All rights reserved.
//


#import "ASFriendTVC.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "ASServerManager.h"

#include "ASSubtitleCell.h"
#import "ASFriend.h"


#import "ASUserTVC.h"

@interface ASFriendTVC ()

@property (strong, nonatomic) NSMutableArray* arrayFriends;
@property (assign, nonatomic) BOOL loadingData;
@end


@implementation ASFriendTVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayFriends = [NSMutableArray array];
    self.loadingData = YES;
    [self getFriendsFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get friends from server


-(void) getFriendsFromServer {
    
    [[ASServerManager sharedManager] getFriendsWithOffset:[self.arrayFriends count]
                                                    count:20
                                                onSuccess:^(NSArray *friends) {
                                                
             if ([friends count] > 0) {
            
                 [self.arrayFriends addObjectsFromArray:friends];

                 NSMutableArray* newPaths = [NSMutableArray array];
                
                for (int i = (int)[self.arrayFriends count] - (int)[friends count]; i < [self.arrayFriends count]; i++){
                    [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                
                 for (ASFriend* friend in friends) {
                     [[ASServerManager sharedManager] getCityInfoByID:@(friend.cityID) onSuccess:^(NSString *city) {
                         friend.city = city;
                         [self.tableView reloadData];
                     } onFailure:^(NSError *error) { }];
                 }
                 
                 
    
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                self.loadingData = NO;
             }
                                                    
        }
        onFailure:^(NSError *error, NSInteger statusCode) {
            NSLog(@"error = %@, code = %ld", [error localizedDescription], (long)statusCode);
        }];
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            self.loadingData = YES;
            [self getFriendsFromServer];
        }
    }
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayFriends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString* identifier = @"ASSubtitleCell";
    
    ASSubtitleCell* cell = (ASSubtitleCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ASSubtitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    ASFriend* friend = [self.arrayFriends objectAtIndex:indexPath.row];
    
    cell.firstLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
    if (friend.city) {
        cell.secondLabel.text = friend.city;
    } else if (friend.status) {
        cell.secondLabel.text = friend.status;

    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:friend.imageURL];
    
    __weak ASSubtitleCell* weakCell = cell;
    
    cell.userPhoto.image = nil;
    
    [cell.userPhoto setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       weakCell.userPhoto.image = image;
                                       //[weakCell layoutSubviews];
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       
                                   }];
    
    return cell;
}

#pragma mark - UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ASUserTVC *detailVC = (ASUserTVC *)[storyboard  instantiateViewControllerWithIdentifier:@"ASUserTVC"];
    ASFriend *friend = [self.arrayFriends objectAtIndex:indexPath.row];
    
    detailVC.userID = friend.userID;
    NSLog(@"friend.userID = %@ ",friend.userID);
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
