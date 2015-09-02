//
//  ASWall.m
//  HW_45_VK
//
//  Created by MD on 02.09.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASWall.h"

@implementation ASWall



-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
    
        self.type = [[responseObject objectForKey:@"attachment"] objectForKey:@"type"];
       
        if (!self.type) {
            self.type = [responseObject objectForKey:@"post_type"];
        }
        
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"dd MMM yyyy "];
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[[responseObject objectForKey:@"date"] floatValue]];
        NSString *date   = [dateFormater stringFromDate:dateTime];
        self.date        = date;
        self.text        = [responseObject objectForKey:@"text"];

        self.comments = [[responseObject objectForKey:@"comments"] objectForKey:@"count"];
        self.likes    = [[responseObject objectForKey:@"likes"]    objectForKey:@"count"];
        self.reposts  = [[responseObject objectForKey:@"reposts"]  objectForKey:@"count"];
        

        
            if ([self.type isEqualToString:@"photo"]) {
            
                    NSString* urlString = [[[responseObject objectForKey:@"attachment"] objectForKey:@"photo"] objectForKey:@"src_big"];
                    
                    if (urlString) {
                        self.postPhoto = [NSURL URLWithString:urlString];
                    }
            }
        
        
            if ([self.type isEqualToString:@"video"]) {
                
                        self.text = [[[responseObject objectForKey:@"attachment"] objectForKey:@"video"] objectForKey:@"title"];
                        NSString* urlString = [[[responseObject objectForKey:@"attachment"] objectForKey:@"video"] objectForKey:@"image_big"];
                        
                        if (urlString) {
                            self.postPhoto = [NSURL URLWithString:urlString];
                        }
                
            }
        
        
        if ([self.type isEqualToString:@"link"]) {
            
            //self.text  = [[[responseObject objectForKey:@"attachment"] objectForKey:@"link"] objectForKey:@"description"];
            self.text2 = [[[responseObject objectForKey:@"attachment"] objectForKey:@"link"] objectForKey:@"url"];
            self.text = [[[responseObject objectForKey:@"attachment"] objectForKey:@"link"] objectForKey:@"title"];

            
            NSString* urlString = [[[responseObject objectForKey:@"attachment"] objectForKey:@"link"] objectForKey:@"image_src"];
        
            if (urlString) {
                self.postPhoto = [NSURL URLWithString:urlString];
            }
         }
        
        
        
        if ([self.type isEqualToString:@"album"]) {
            
            self.text = [[[responseObject objectForKey:@"attachment"] objectForKey:@"album"] objectForKey:@"description"];
            NSString* urlString = [[[responseObject objectForKey:@"attachment"] objectForKey:@"album"] objectForKey:@"image_src"];
            
            if (urlString) {
                self.postPhoto = [NSURL URLWithString:urlString];
            }
            
        }
        
    }
    
    return self;
    
}
@end
