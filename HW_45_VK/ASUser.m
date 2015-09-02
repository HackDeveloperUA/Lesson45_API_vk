
//
//  ASUser.m
//  HW_45_VK
//
//  Created by MD on 31.08.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASUser.h"
#import "ASServerManager.h"

@implementation ASUser

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
        //photo_max_orig,status,sex,bdate,city, online
        
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName  = [responseObject objectForKey:@"last_name"];
        self.userID    = [responseObject objectForKey:@"uid"];
        
        self.status    = [responseObject objectForKey:@"status"];
        
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"dd MMM yyyy "];
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[[responseObject objectForKey:@"date"] floatValue]];
        NSString *date = [dateFormater stringFromDate:dateTime];
        
        self.bdate     = date;
        self.cityID    = [responseObject objectForKey:@"city"];
        self.countryID = [responseObject objectForKey:@"country"];
        
        /*
        NSLog(@"Передаю city = %@",self.city);
        NSLog(@"Передаю country = %@",self.country);
        
        [[ASServerManager sharedManager] getCityInfoByID:self.city onSuccess:^(NSString *city) {
            NSLog(@"Принял city = %@",city);
            self.city = city;
        } onFailure:^(NSError *error) {
            NSLog(@"error = %@",[error localizedDescription]);
        }];
        
        [[ASServerManager sharedManager] getCounteresInfoByID:self.country onSuccess:^(NSString *country) {
            NSLog(@"Принял country = %@",country);
            self.country = country;

        } onFailure:^(NSError *error) {
            NSLog(@"error = %@",[error localizedDescription]);
        }];
        */
        
        self.online  = [[responseObject objectForKey:@"online"] boolValue];
        
        NSString* urlString = [responseObject objectForKey:@"photo_max_orig"];
        
        if (urlString) {
            self.mainImageURL = [NSURL URLWithString:urlString];
        }
    }
    
    return self;
    
}

-(void) superDescripton {
    /*
     
     @property (strong, nonatomic) NSString* firstName;
     @property (strong, nonatomic) NSString* lastName;
     
     @property (strong, nonatomic) NSString* bdate;
     @property (strong, nonatomic) NSString* country;
     @property (strong, nonatomic) NSString* city;
     @property (strong, nonatomic) NSString* status;
     @property (assign, nonatomic) BOOL online;
     
     
     @property (strong, nonatomic) NSString* userID;
     @property (strong, nonatomic) NSURL*    mainImageURL;

    */
    NSLog(@"\n\n\n\n\n\n");
    NSLog(@"First Name = %@",self.firstName);
    NSLog(@"Last Name  = %@",self.lastName);
    
    NSLog(@"bdate = %@",self.bdate);
    NSLog(@"country = %@",self.country);
    NSLog(@"city  = %@",self.city);
    NSLog(@"status = %@",self.status);
    
    NSLog(@"online = %hhd",self.online);
    NSLog(@"userID = %@",self.userID);
    NSLog(@"mainImage URL = %@",self.mainImageURL);
    
    
    
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
