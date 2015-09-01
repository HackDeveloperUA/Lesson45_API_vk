//
//  ASServerManager.m
//  HW_45_VK
//
//  Created by MD on 31.08.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASServerManager.h"

#import "ASFriend.h"
#import "ASUser.h"

@implementation ASServerManager


+(ASServerManager*) sharedManager {
    
    static ASServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
      dispatch_once(&onceToken, ^{
          manager = [[ASServerManager alloc] init];
   });
    
    return manager;
}


-(id) init {
    
    self = [super init];
    
    if (self) {
        NSURL* url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
}



#pragma mark - get data from server

- (void) getFriendsWithOffset:(NSInteger) offset
                        count:(NSInteger) count
                    onSuccess:(void(^)(NSArray* friends)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"201621080", @"user_id",
                            @"hints",    @"order",
                            @(count),     @"count",
                            @(offset),    @"offset",
                            @"photo_100",  @"fields",
                            @"nom",       @"name_case", nil];
    
    
    
    [self.requestOperationManager GET:@"friends.get"
                           parameters:params
     
                              success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                                  
                                  NSLog(@"JSON - %@",responseObject);
                                  
                                  NSArray* friendsArray = [responseObject objectForKey:@"response"];
                                  NSMutableArray* objectsArray = [NSMutableArray array];
                                  
                                  
                                  for (NSDictionary* dict in friendsArray) {
                                      
                                      ASFriend* friend = [[ASFriend alloc] initWithServerResponse:dict];
                                      [objectsArray addObject:friend];
                                  }
                                  
                                  
                                  if (success) {
                                      success(objectsArray);
                                  }
                              }
     
     
                              failure:^(AFHTTPRequestOperation *operation, NSError* error){
                                  NSLog(@"Error: %@",error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];
}



- (void) getUsersInfoUserID:(NSString*) userId
                  onSuccess:(void(^)(ASUser* user)) success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    
    //photo_max_orig,status,sex,bdate,city, online
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userId,          @"user_ids",
                            @"photo_max_orig,city,sex,bdate,status,city,online",  @"fields",
                            @"nom",             @"name_case", nil];
    
    
    
    [self.requestOperationManager GET:@"users.get"
                           parameters:params
     
                              success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                                  
                                  NSLog(@"JSON: %@",responseObject);
                                  
                                  NSArray* friendsArray = [responseObject objectForKey:@"response"];
                                  ASUser* user = nil;
                                  
                                  for (NSDictionary* dict in friendsArray) {
                                      
                                      user = [[ASUser alloc] initWithServerResponse:dict];
                                  }
                                  
                                  if (success) {
                                      success(user);
                                  }
                              }
        
                              failure:^(AFHTTPRequestOperation *operation, NSError* error){
                                  
                                  NSLog(@"Error: %@",error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];
}


@end
