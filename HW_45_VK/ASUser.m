//
//  ASUser.m
//  HW_45_VK
//
//  Created by MD on 31.08.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASUser.h"

@implementation ASUser

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
        //photo_max_orig,status,sex,bdate,city, online

        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName  = [responseObject objectForKey:@"last_name"];
        self.userID    = [responseObject objectForKey:@"user_id"];
        
        self.status    = [responseObject objectForKey:@"status"];
        
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"dd MMM yyyy "];
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[[responseObject objectForKey:@"date"] floatValue]];
        NSString *date = [dateFormater stringFromDate:dateTime];
        
        self.bdate   = date;
        self.country = [responseObject objectForKey:@"country"];
        self.city    = [responseObject objectForKey:@"city"];

        self.online  = [[responseObject objectForKey:@"online"] boolValue];
        
        NSString* urlString = [responseObject objectForKey:@"photo_max_orig"];
        
        if (urlString) {
            self.mainImageURL = [NSURL URLWithString:urlString];
        }
    }
    
    return self;
    
}

/*
-(NSString*) transformDate:(float) date {
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"dd MMM yyyy "];
    
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:date];
    NSString *date = [dateFormater stringFromDate:dateTime];
    
    return date;
}*/


@end
