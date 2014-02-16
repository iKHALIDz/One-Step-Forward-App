//
//  MainMenuViewController.h
//  TestingLogin
//
//  Created by KHALID ALAHMARI on 1/29/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "goalTableViewCell.h"


@interface MainMenuViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *postArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSInteger count;

@property (nonatomic,strong) NSMutableArray *goalsName;
@property (nonatomic,strong) NSMutableArray *goalsdescription;
@property (nonatomic,strong) NSMutableArray *goalDeadline;


@end