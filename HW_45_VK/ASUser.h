//
//  ASUser.h
//  HW_45_VK
//
//  Created by MD on 31.08.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASUser : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;

@property (strong, nonatomic) NSString* bdate;
@property (strong, nonatomic) NSString* country;
@property (strong, nonatomic) NSString* city;
@property (strong, nonatomic) NSString* status;
@property (assign, nonatomic) BOOL online;


@property (strong, nonatomic) NSString* userID;
@property (strong, nonatomic) NSURL*    mainImageURL;

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;

@end
