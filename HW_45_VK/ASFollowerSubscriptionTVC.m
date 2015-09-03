//
//  ASFollowerSubscriptionTVC.m
//  HW_45_VK
//
//  Created by MD on 31.08.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASFollowerSubscriptionTVC.h"
#import "ASSubtitleCell.h"

#import "ASFollower.h"
#import "ASSubscription.h"

#import "ASServerManager.h"

#import "AFNetWorking.h"
#import "UIImageView+AFNetworking.h"


@interface ASFollowerSubscriptionTVC () 

@property (strong, nonatomic) NSMutableArray* arrayFollowerAndSubscription;
@property (assign, nonatomic) BOOL loadingData;
@end

@implementation ASFollowerSubscriptionTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loadingData = YES;
    self.arrayFollowerAndSubscription = [NSMutableArray array];
    [self getSubscriptioFollowerFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayFollowerAndSubscription count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString* identifierSubtitleCell = @"ASSubtitleCell";
    
    ASSubtitleCell* cell = (ASSubtitleCell*)[tableView dequeueReusableCellWithIdentifier:identifierSubtitleCell];
    
    if (!cell) {
        cell = [[ASSubtitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierSubtitleCell];
    }


    if ([self.identifier isEqualToString:@"Subscriptions"]) {
        
        ASSubscription* subscription = [self.arrayFollowerAndSubscription objectAtIndex:indexPath.row];
        cell.firstLabel.text  =  subscription.name;
        cell.secondLabel.text =  subscription.memberCount;
        [cell.userPhoto setImageWithURL:subscription.mainPhotoURL placeholderImage:[UIImage imageNamed:@"placeholder-hi"]];

        return cell;
    }
    
    if ([self.identifier isEqualToString:@"Followers"]) {
        
        ASFollower* follower = [self.arrayFollowerAndSubscription objectAtIndex:indexPath.row];
        
        cell.firstLabel.text  = follower.fullName;
        cell.secondLabel.text = follower.status;
        
        [cell.userPhoto setImageWithURL:follower.userPhotoURL placeholderImage:[UIImage imageNamed:@"placeholder-hi"]];
        
        return cell;
    }
    
    
    return nil;
}


#pragma mark - Server

-(void)  getSubscriptioFollowerFromServer {
    
 
    if ([self.identifier isEqualToString:@"Subscriptions"]) {
        
        [[ASServerManager sharedManager] getSubscriptionsWithId:self.ID
                                                       onOffSet:[self.arrayFollowerAndSubscription count]
                                                         count:20 onSuccess:^(NSArray *subcriptions) {
                                                           
                                                             if ([subcriptions count] > 0) {
                                                                 
                                                                 [self.arrayFollowerAndSubscription addObjectsFromArray:subcriptions];
                                                                 
                                                                 NSMutableArray* newPaths = [NSMutableArray array];
                                                                 
                                                                 for (int i = (int)[self.arrayFollowerAndSubscription count] - (int)[subcriptions count]; i < [self.arrayFollowerAndSubscription count]; i++){
                                                                     [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                                                 }
                                                                 
                                                                 [self.tableView beginUpdates];
                                                                 [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
                                                                 [self.tableView endUpdates];
                                                                 self.loadingData = NO;
                                                             }
   
                                                             
                                                             
                                                         } onFailure:^(NSError *error, NSInteger statusCode) {
                                                             
                                                         }];
                                                                
        
    }else if ([self.identifier isEqualToString:@"Followers"]) {
        
        [[ASServerManager sharedManager] getFollowersWithId:self.ID
                                                   onOffSet:[self.arrayFollowerAndSubscription count]
                                                      count:20
                                                  onSuccess:^(NSArray *followers) {
            
            if ([followers count] > 0) {
                
                [self.arrayFollowerAndSubscription addObjectsFromArray:followers];
                
                NSMutableArray* newPaths = [NSMutableArray array];
                
                for (int i = (int)[self.arrayFollowerAndSubscription count] - (int)[followers count]; i < [self.arrayFollowerAndSubscription count]; i++){
                    [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                }
                
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                self.loadingData = NO;
            }

        } onFailure:^(NSError *error, NSInteger statusCode) {
            
        }];
    }
    
    
}



#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            self.loadingData = YES;
            [self getSubscriptioFollowerFromServer];
        }
    }
}



@end
