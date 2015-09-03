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
#import "ASWallTextLink.h"


#import "ASServerManager.h"
#import "ASUser.h"
#import "ASFriend.h"
#import "ASWall.h"


#import "AFNetWorking.h"
#import "UIImageView+AFNetworking.h"

#import "ASFollowerSubscriptionTVC.h"

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
static NSString* identifierWallLink       = @"ASWallTextLink";


@implementation ASUserTVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.currentUser = [[ASUser alloc] init];
    self.arrrayWall  = [NSMutableArray array];
    [self getUserFromServer];
    //[self getWallFromServer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Get Friends From Server

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



#pragma mark - Get Wall From Server

-(void)  getWallFromServer {

    NSLog(@"[count ] =====  %d",[self.arrrayWall count]);
    
  [[ASServerManager sharedManager] getWallWithID:self.userID
                                      withOffset:[self.arrrayWall count]
                                           count:20
                                       onSuccess:^(NSArray *wall) {
                                           
                                        
                                           if ([wall count] > 0) {
                                               
                                               [self.arrrayWall addObjectsFromArray:wall];
                                               
                                               NSMutableArray* newPaths = [NSMutableArray array];
                                               
                                               for (int i = (int)[self.arrrayWall count] - (int)[wall count]; i < [self.arrrayWall count]; i++){
                                                   [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:1]];
                                               }
                                               
                                               [self.tableView beginUpdates];
                                               [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
                                               [self.tableView endUpdates];
                                               self.loadingData = NO;
                                           } else {
                                               
                                               [[[UIAlertView alloc] initWithTitle:@"Страница скрыта" message:@"Страница доступна только авторизованным пользователям." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign In",nil] show];
                                           }

                                           
                                       } onFailure:^(NSError *error, NSInteger statusCode) {    }];
    
    

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
    
    
    if (indexPath.section == 1) {

        ASWall* wall = [self.arrrayWall objectAtIndex:indexPath.row];
        NSLog(@"wall.type = %@",wall.type);
        
        
        if ([wall.type isEqualToString:@"photo"] || [wall.type isEqualToString:@"video"]  ||  [wall.type isEqualToString:@"album"] ||  [wall.type isEqualToString:@"graffiti"] )
        {
          
                    ASWallTextImageCell* cell = (ASWallTextImageCell*)[tableView dequeueReusableCellWithIdentifier:identifierWallTextImage];
                    
                    if (!cell) {
                        cell = [[ASWallTextImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierWallTextImage];
                    }
                    
                    
                    [cell.userPhoto setImageWithURL:self.currentUser.mainImageURL placeholderImage:[UIImage imageNamed:@"placeholder-hi"]];
                    [cell.postPhoto setImageWithURL:wall.postPhoto placeholderImage:[UIImage imageNamed:@"placeholder-03"]];
                    
                    cell.fullName.text = [NSString stringWithFormat:@"%@ %@",_currentUser.firstName,_currentUser.lastName];
                    cell.date.text     = wall.date;
                    
                    if (wall.text) {
                        cell.superText.text = wall.text;
                    } else { cell.superText = nil; }
                    
                    cell.commentLabel.text = wall.comments;
                    cell.likeLabel.text    = wall.likes;
                    cell.repostLabel.text  = wall.reposts;
                    
                    [cell.commentButton addTarget:self action:@selector(likeRepostCommentAction:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.likeButton     addTarget:self action:@selector(likeRepostCommentAction:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.repostButton     addTarget:self action:@selector(likeRepostCommentAction:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
            
        }
    
        
        if ([wall.type isEqualToString:@"post"] || [wall.type isEqualToString:@"copy"] || [wall.type isEqualToString:@"audio"]) {
        
            ASWallTextCell* cell = (ASWallTextCell*)[tableView dequeueReusableCellWithIdentifier:identifierWallText];
            
            if (!cell) {
                cell = [[ASWallTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierWallText];
            }
 
            [cell.userPhoto setImageWithURL:self.currentUser.mainImageURL placeholderImage:[UIImage imageNamed:@"placeholder-hi"]];
            
            cell.fullName.text = [NSString stringWithFormat:@"%@ %@",_currentUser.firstName,_currentUser.lastName];
            cell.date.text     = wall.date;
            
            if (wall.text) {
                cell.superText.text = wall.text;
            } else { cell.superText = nil; }
            
            cell.commentLabel.text = wall.comments;
            cell.likeLabel.text    = wall.likes;
            cell.repostLabel.text  = wall.reposts;
            
            [cell.commentButton addTarget:self action:@selector(likeRepostCommentAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.likeButton     addTarget:self action:@selector(likeRepostCommentAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.repostButton     addTarget:self action:@selector(likeRepostCommentAction:) forControlEvents:UIControlEventTouchUpInside];
            
         return cell;
            
        }
        
        
        
        if ([wall.type isEqualToString:@"link"] ) {
            
            ASWallTextLink* cell = (ASWallTextLink*)[tableView dequeueReusableCellWithIdentifier:identifierWallLink];
            
            if (!cell) {
                cell = [[ASWallTextLink alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierWallLink];
            }
            
            [cell.userPhoto setImageWithURL:self.currentUser.mainImageURL placeholderImage:[UIImage imageNamed:@"placeholder-hi"]];
            [cell.imagePost setImageWithURL:wall.postPhoto placeholderImage:[UIImage imageNamed:@"default"]];

            cell.fullName.text = [NSString stringWithFormat:@"%@ %@",_currentUser.firstName,_currentUser.lastName];
            cell.date.text     = wall.date;
            
            cell.superText1.text = wall.text;
            cell.superText2.text = wall.text2;
            
            cell.commentLabel.text = wall.comments;
            cell.likeLabel.text    = wall.likes;
            cell.repostLabel.text  = wall.reposts;
            
            [cell.commentButton addTarget:self action:@selector(likeRepostCommentAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.likeButton     addTarget:self action:@selector(likeRepostCommentAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.repostButton     addTarget:self action:@selector(likeRepostCommentAction:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
            
        }
        
        if ([wall.type isEqualToString:@"doc"] ) {
            
            ASWallTextLink* cell = (ASWallTextLink*)[tableView dequeueReusableCellWithIdentifier:identifierWallLink];
            
            if (!cell) {
                cell = [[ASWallTextLink alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierWallLink];
            }
            
            [cell.userPhoto setImageWithURL:self.currentUser.mainImageURL placeholderImage:[UIImage imageNamed:@"placeholder-hi"]];
            
            cell.fullName.text = [NSString stringWithFormat:@"%@ %@",_currentUser.firstName,_currentUser.lastName];
            cell.date.text     = wall.date;
            
            cell.superText1.text = wall.text;
            //cell.superText2.text = wall.urlLink;
            
            cell.commentLabel.text = wall.comments;
            cell.likeLabel.text    = wall.likes;
            cell.repostLabel.text  = wall.reposts;
            
            [cell.commentButton addTarget:self action:@selector(likeRepostCommentAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.likeButton     addTarget:self action:@selector(likeRepostCommentAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.repostButton     addTarget:self action:@selector(likeRepostCommentAction:) forControlEvents:UIControlEventTouchUpInside];
            
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

    if ([cell isKindOfClass:[ASWallTextLink class]]) {
        return 162.f;
    }
    
    
    return 10.f;
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            self.loadingData = YES;
            [self getWallFromServer];
        }
    }
}

#pragma mark - Action Subscription Button

-(void) subscriptionFollowerAction:(UIButton*) sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ASFollowerSubscriptionTVC *detailVC = (ASFollowerSubscriptionTVC*)[storyboard  instantiateViewControllerWithIdentifier:@"ASFollowerSubscriptionTVC"];
    
    
    if (sender.tag == 100) {
        detailVC.identifier = @"Subscriptions";
        detailVC.ID = self.userID;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    if (sender.tag == 200) {
        detailVC.ID = self.userID;
        detailVC.identifier = @"Followers";
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}


#pragma mark - Action Like/Repost/Comment Button

-(void) likeRepostCommentAction:(UIButton*) sender {
    
    
    NSString* title = @"Ошибка доступа";
    NSString* message;
    
    
    if (sender.tag == 100) {
        message = @"Функция Комментарии доступна только авторизированым пользователям";
    }
    if (sender.tag == 200) {
        message = @"Функция Лайк доступна только авторизированым пользователям";
    }
    if (sender.tag == 300) {
        message = @"Функция Репост доступна только авторизированым пользователям";
    }
    
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sign in",nil] show];
}





@end
