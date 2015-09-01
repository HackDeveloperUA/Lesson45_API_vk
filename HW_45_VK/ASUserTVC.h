//
//  ASUserTVC.h
//  HW_45_VK
//
//  Created by MD on 31.08.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASFriend.h"

@interface ASUserTVC : UITableViewController

@property (strong, nonatomic) ASFriend* currentFriend;
@property (strong, nonatomic) NSString* userID;
@end
