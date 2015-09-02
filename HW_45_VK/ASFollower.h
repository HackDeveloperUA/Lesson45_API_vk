//
//  ASFollower.h
//  HW_45_VK
//
//  Created by MD on 02.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASFollower : NSObject

@property (strong, nonatomic) NSURL*    userPhotoURL;
@property (strong, nonatomic) NSString* fullName;
@property (strong, nonatomic) NSString* status;

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;



@end
