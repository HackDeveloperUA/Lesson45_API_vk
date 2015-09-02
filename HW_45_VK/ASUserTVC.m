//
//  ASUserTVC.m
//  HW_45_VK
//
//  Created by MD on 31.08.15.
//  Copyright (c) 2015 MD. All rights reserved.
//

#import "ASUserTVC.h"

#import "ASGeneralCell.h"
#import "ASStatusCell.h"
#import "ASButtonFollowerCell.h"
#import "ASWallTextImageCell.h"
#import "ASWallTextCell.h"


#import "ASServerManager.h"
#import "ASUser.h"
#import "ASFriend.h"

#import "AFNetWorking.h"
#import "UIImageView+AFNetworking.h"

@interface ASUserTVC ()

@property (strong, nonatomic) ASUser* currentUser;

@property (assign, nonatomic) BOOL loadingData;
@property (strong, nonatomic) NSMutableArray* arrrayWall;
@end


static NSString* identifierGeneral        = @"ASGeneralCell";
static NSString* identifierStatus         = @"ASStatusCell";
static NSString* identifierButtonFollower = @"ASButtonFollowerCell";
static NSString* identifierWallTextImage  = @"ASWallTextImageCell";
static NSString* identifierWallText       = @"ASWallTextCell";


@implementation ASUserTVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.currentUser = [[ASUser alloc] init];
    self.arrrayWall  = [NSMutableArray array];
    [self getUserFromServer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - get friends from server

-(void)  getUserFromServer {
    
  [[ASServerManager sharedManager] getUsersInfoUserID:self.userID onSuccess:^(ASUser *user) {
      self.currentUser = user;
    
      [[ASServerManager sharedManager] getCityInfoByID:self.currentUser.cityID onSuccess:^(NSString *city) {
          
          self.currentUser.city = city;
          
      } onFailure:^(NSError *error)     { }];
      
      
      
      [[ASServerManager sharedManager] getCounteresInfoByID:self.currentUser.countryID onSuccess:^(NSString *country) {
          
          self.currentUser.country = country;
          [self.tableView reloadData];
          
      } onFailure:^(NSError *error) {  }];
      
      
      [self.currentUser superDescripton];
      
  } onFailure:^(NSError *error, NSInteger statusCode) {
      NSLog(@"errpr = %@ statsus %d",[error localizedDescription],statusCode);
  }];
    
    

    

  
}

#pragma mark - UITabelViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 3;
    }
    
    if (section == 1) {
        return [self.arrrayWall count];
    }
   
  return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    if (indexPath.section == 0) {
        
            if (indexPath.row == 0) {
                
                ASGeneralCell* cell = (ASGeneralCell*)[tableView dequeueReusableCellWithIdentifier:identifierGeneral];
                
                if (!cell) {
                    cell = [[ASGeneralCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierGeneral];
                }
                
                if ([self.currentUser isEqual:nil]) {
                    NSLog(@"Ебать он нил ");
                }
                
                [cell.mainImage setImageWithURL:self.currentUser.mainImageURL placeholderImage:[UIImage imageNamed:@"placeholder-hi"]];
                
                cell.firstName.text = self.currentUser.firstName;
                cell.lastName.text  = self.currentUser.lastName;
                cell.dateBirth.text = self.currentUser.bdate;
                
                cell.country.text   = self.currentUser.country;
                cell.city.text      = self.currentUser.city;
                
                if (self.currentUser.online == 0) {
                    cell.online.text = @"Offline";
                } else { cell.online.text = @"Online"; }
                
                return cell;
            }
        
        if (indexPath.row == 1) {
            
            ASStatusCell* cell = (ASStatusCell*)[tableView dequeueReusableCellWithIdentifier:identifierStatus];
            
            if (!cell) {
                cell = [[ASStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStatus];
            }
            cell.status.text = self.currentUser.status;
            return cell;
        }
        
        if (indexPath.row == 2) {
            
            ASButtonFollowerCell* cell = (ASButtonFollowerCell*)[tableView dequeueReusableCellWithIdentifier:identifierButtonFollower];
            
            if (!cell) {
                cell = [[ASButtonFollowerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierButtonFollower];
            }

            [cell.subscriptionButton addTarget:self action:@selector(subscriptionFollowerAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.followerButton     addTarget:self action:@selector(subscriptionFollowerAction:) forControlEvents:UIControlEventTouchUpInside];
            
          return cell;
        }
        
        
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    id cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[ASGeneralCell class]]) {
        return 220.f;
        }
    
    if ([cell isKindOfClass:[ASStatusCell class]]) {
        return 45.f;
        }
        
    if ([cell isKindOfClass:[ASButtonFollowerCell class]]) {
        return 62.f;
        }

    if ([cell isKindOfClass:[ASWallTextImageCell class]]) {
        return 337.f;
        }
        
    if ([cell isKindOfClass:[ASWallTextCell class]]) {
        return 162.f;
        }
        
    /*
    if ([cell.reuseIdentifier isEqualToString:identifierGeneral]) {
        return 220.f;
    }

    if ([cell.reuseIdentifier isEqualToString:identifierStatus]) {
        return 45.f;
    }
    
    if ([cell.reuseIdentifier isEqualToString:identifierButtonFollower]) {
        return 62.f;
    }

    if ([cell.reuseIdentifier isEqualToString:identifierWallTextImage]) {
        return 337.f;
    }

    if ([cell.reuseIdentifier isEqualToString:identifierWallText]) {
        return 162.f;
    }
    */

    return 10.f;
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            self.loadingData = YES;
           // [self getFriendsFromServer];
        }
    }
}

#pragma mark - Action Subscription Button

-(void) subscriptionFollowerAction:(UIButton*) sender {
    
    
    if (sender.tag == 100) {
        
    }
    
    if (sender.tag == 200) {
        
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
