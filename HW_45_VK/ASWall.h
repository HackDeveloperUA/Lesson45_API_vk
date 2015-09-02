//
//  ASWall.h
//  HW_45_VK
//
//  Created by MD on 02.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASWall : NSObject


@property (strong, nonatomic) NSString* type;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* text2;

@property (strong, nonatomic) NSString* date;

@property (strong, nonatomic) NSString* comments;
@property (strong, nonatomic) NSString* likes;
@property (strong, nonatomic) NSString* reposts;

@property (strong, nonatomic) NSString* urlLink;
@property (strong, nonatomic) NSURL* postPhoto;

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;
@end
