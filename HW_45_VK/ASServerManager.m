//
//  ASServerManager.m
//  HW_45_VK
//
//  Created by MD on 31.08.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASServerManager.h"

#import "ASSubscription.h"
#import "ASFollower.h"

#import "ASFriend.h"
#import "ASUser.h"
#import "ASWall.h"

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

-(void) getWallWithID:(NSString*) userId
           withOffset:(NSInteger) offset
                count:(NSInteger) count
            onSuccess:(void(^)(NSArray* wall)) success
            onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userId,      @"owner_id",
                            @(count),     @"count",
                            @(offset),    @"offset",
                            @"owner",  @"fields", nil];
    
    
    
    [self.requestOperationManager GET:@"wall.get"
                           parameters:params
     
                              success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                                  
                                  NSArray* wallArray = [responseObject objectForKey:@"response"];
                                  NSMutableArray* objectsArray = [NSMutableArray array];
                            
                                  
                                 
                                  NSLog(@" [wallArray] = %@",wallArray);
                                  NSLog(@" [wallArray count] = %d",[wallArray count]);
                                  
                                  if (wallArray) {
                                    
                                      //-1
                                      for (int i=1; i<[wallArray count]-1; i++) {
                                          
                                          NSDictionary* dict = [wallArray objectAtIndex:i];
                                          NSLog(@"responce Object = %@",dict);
                    
                                          ASWall* wall = [[ASWall alloc] initWithServerResponse:dict];
                                          [objectsArray addObject:wall];
                                      }
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







- (void) getFriendsWithOffset:(NSInteger) offset
                        count:(NSInteger) count
                    onSuccess:(void(^)(NSArray* friends)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"10468851", @"user_id",
                            @"hints",    @"order",
                            @(count),     @"count",
                            @(offset),    @"offset",
                            @"photo_100,city,status",  @"fields",
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
                            @"photo_max_orig,country,city,sex,bdate,status,online",  @"fields",
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

- (void)getCounteresInfoByID:(NSString *)ids
                   onSuccess:(void (^) (NSString *country)) success
                   onFailure:(void (^) (NSError *error)) failure {
    
    NSDictionary *paramDictionary = [NSDictionary dictionaryWithObjectsAndKeys:ids,@"country_ids", nil];

    [self.requestOperationManager GET:@"database.getCountriesById" parameters:paramDictionary
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *objects =   [responseObject objectForKey:@"response"];
        NSString* country = [[objects firstObject] objectForKey:@"name"];

        success(country);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}






- (void)getCityInfoByID:(NSString *)ids onSuccess:(void (^) (NSString *city)) success onFailure:(void (^) (NSError *error)) failure {
    
    NSDictionary *paramDictionary = [NSDictionary dictionaryWithObjectsAndKeys:ids,@"city_ids", nil];
    
    [self.requestOperationManager GET:@"database.getCitiesById" parameters:paramDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *objects = [responseObject objectForKey:@"response"];
        NSString* city = [[objects firstObject] objectForKey:@"name"];
        
        success(city);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
}




- (void) getSubscriptionsWithId:(NSString*) userId
                       onOffSet:(NSInteger) offset
                          count:(NSInteger) count
                      onSuccess:(void(^)(NSArray* subcriptions)) success
                      onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    
    
    // user_id extended offset count fields
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userId,        @"user_id",
                            @"1",          @"extended",
                            @(offset),     @"offset",
                            @"20",         @"count",
                            @"members_count,photo_100,status",  @"fields", nil];
    
    
    
    [self.requestOperationManager GET:@"users.getSubscriptions"
                           parameters:params
     
                              success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                                  
                                  NSLog(@"users.getSubscriptions JSON: %@",responseObject);
                                  
                        
                                  NSArray* subcriptArray = [responseObject objectForKey:@"response"];
                                  NSMutableArray* objectsArray = [NSMutableArray array];
                                  
                                  
                                  for (NSDictionary* dict in subcriptArray) {
                                     
                                      ASSubscription* subscript = [[ASSubscription alloc] initWithServerResponse:dict];
                                      [objectsArray addObject:subscript];
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




- (void) getFollowersWithId:(NSString*) userId
                   onOffSet:(NSInteger) offset
                      count:(NSInteger) count
                  onSuccess:(void(^)(NSArray* followers)) success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    
    //user_id offset count fields name_case
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userId,        @"user_id",
                            @(offset),     @"offset",
                            @(count),      @"count",
                            @"photo_100,status",  @"fields",
                            @"nom",        @"name_case", nil];
    
    
    [self.requestOperationManager GET:@"users.getFollowers"
                           parameters:params
     
                              success:^(AFHTTPRequestOperation *operation,NSDictionary *responseObject) {
                                  
                                  NSDictionary *dictsArray = [responseObject objectForKey:@"response"];
                                  
                                  NSArray *dictsArrayItems = [dictsArray objectForKey:@"items"];
                                  
                                  
                                  NSMutableArray *objectArray = [NSMutableArray array];
                                  
                                  for (NSDictionary *dict in dictsArrayItems) {
                                      ASFollower* follower = [[ASFollower alloc] initWithServerResponse:dict];
                                      [objectArray addObject:follower];
                                  }
                                  
                                  if (success) {
                                      success(objectArray);
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
