//
//  MainMenuViewController.m
//  TestingLogin
//
//  Created by KHALID ALAHMARI on 1/29/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@end


@implementation MainMenuViewController


@synthesize goalsdescription,goalsName,goalDeadline;

@synthesize tableView;

@synthesize postArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

}
 


-(void) viewWillAppear:(BOOL)animated
{
    if ([PFUser currentUser]){
[self.tableView reloadData];
        [self refreshButtonHandler:nil];

    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return postArray.count;
    
    
}


- (void)refreshButtonHandler:(id)sender {
    // Create a query
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Goal"];
    postQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;

    // Follow relationship
    [postQuery whereKey:@"CreatedBy" equalTo:[PFUser currentUser]];
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            postArray = objects;           // Store results
            [self.tableView reloadData];   // Reload table
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)isSignOutPressed:(UIButton *)sender {
    
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
    

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    goalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    PFObject *goal = [postArray objectAtIndex:indexPath.row];
    
    [cell.goalName setText:[goal objectForKey:@"GoalName"]];
    [cell.goalDescription setText:[goal objectForKey:@"GoalDesc"]];
    [cell.goalDeadline setText:[goal objectForKey:@"GoalDeadline"]];
    
    
    return cell;
}

@end
