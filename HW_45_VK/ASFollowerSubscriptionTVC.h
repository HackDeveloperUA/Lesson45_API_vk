//
//  ASFollowerSubscriptionTVC.h
//  HW_45_VK
//
//  Created by MD on 31.08.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASFollowerSubscriptionTVC : UITableViewController <UITableViewDataSource,UITableViewDelegate ,UIScrollViewDelegate>

@property (strong, nonatomic) NSString* identifier;
@property (strong, nonatomic) NSString* ID;

-(void)  getSubscriptioFollowerFromServer;

@end
