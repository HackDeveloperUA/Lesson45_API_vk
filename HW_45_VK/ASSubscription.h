//
//  ASSubscription.h
//  HW_45_VK
//
//  Created by MD on 02.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASSubscription : NSObject

@property (strong, nonatomic) NSURL*    mainPhotoURL;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* memberCount;

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;


@end
