//
//  ASServerManager.h
//  HW_45_VK
//
//  Created by MD on 31.08.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "ASUser.h"

@interface ASServerManager : NSObject


@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;


+(ASServerManager*) sharedManager;

- (void) getFriendsWithOffset:(NSInteger) offset
                        count:(NSInteger) count
                    onSuccess:(void(^)(NSArray* friends)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;




- (void) getSubscriptionsWithId:(NSString*) userId
                       onOffSet:(NSInteger) offset
                          count:(NSInteger) count
                      onSuccess:(void(^)(NSArray* subcriptions)) success
                      onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;



- (void) getFollowersWithId:(NSString*) userId
                   onOffSet:(NSInteger) offset
                      count:(NSInteger) count
                  onSuccess:(void(^)(NSArray* followers)) success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;






- (void) getUsersInfoUserID:(NSString*) userId
                  onSuccess:(void(^)(ASUser* user)) success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


- (void)getCityInfoByID:(NSString *)ids onSuccess:(void (^) (NSString *city)) success onFailure:(void (^) (NSError *error)) failure;


@end
