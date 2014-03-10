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


@synthesize tableView;
@synthesize postArray;
@synthesize doneGoals;
@synthesize currentGoal;
@synthesize currentGoalProgressPercentage;


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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;


}
 


-(void) viewWillAppear:(BOOL)animated
{
    if ([PFUser currentUser]){
[self.tableView reloadData];
        [self getInProgressGoals:nil];
        [self getDoneGoals:nil];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (section==0)
    {
        return postArray.count;

    }
    else return doneGoals.count;
    
}


- (void)getInProgressGoals:(id)sender {
    // Create a query
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Goal"];
    postQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    //[postQuery orderByAscending:@"createdAt"];
    [postQuery orderByDescending:@"createdAt"];

    
    // Follow relationship
    [postQuery whereKey:@"CreatedBy" equalTo:[PFUser currentUser]];
    [postQuery whereKey:@"isGoalCompleted" equalTo:@NO];

    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            postArray = objects;           // Store results
            [self.tableView reloadData];   // Reload table
        }
    }];
    
}

- (void)getDoneGoals:(id)sender {
    // Create a query
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Goal"];
    postQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [postQuery orderByDescending:@"createdAt"];

    // Follow relationship
    [postQuery whereKey:@"CreatedBy" equalTo:[PFUser currentUser]];
    [postQuery whereKey:@"isGoalCompleted" equalTo:@YES];
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            doneGoals = objects;           // Store results
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


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if(section == 0)
        return @"Goals In Progress";
    else
        return @"Goals Done";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    goalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (indexPath.section==0){
        PFObject *goal = [postArray objectAtIndex:indexPath.row];
        
        [cell.goalName setText:[goal objectForKey:@"GoalName"]];
        [cell.goalDescription setText:[goal objectForKey:@"GoalDesc"]];
        [cell.goalDeadline setText:[goal objectForKey:@"GoalDeadline"]];
        [cell.goalPercentage setText:[NSString stringWithFormat:@"%.2f",[[goal objectForKey:@"goalPercentage"] doubleValue]]];
        
    }
    
    if (indexPath.section==1)
    {
        PFObject *goal2 = [doneGoals objectAtIndex:indexPath.row];

        [cell.goalName setText:[goal2 objectForKey:@"GoalName"]];
        [cell.goalDescription setText:[goal2 objectForKey:@"GoalDesc"]];
        [cell.goalDeadline setText:[goal2 objectForKey:@"GoalDeadline"]];
        [cell.goalPercentage setText:[NSString stringWithFormat:@"%.2f",[[goal2 objectForKey:@"goalPercentage"] doubleValue]]];


    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.section==0){
        PFObject *goal = [postArray objectAtIndex:indexPath.row];
        currentGoal=[goal objectForKey:@"goalID"];
        currentGoalProgressPercentage =[[goal objectForKey:@"goalPercentage"] doubleValue];
        
    }
    
    if (indexPath.section==1)
    {
        PFObject *goal2 = [doneGoals objectAtIndex:indexPath.row];
        currentGoal=[goal2 objectForKey:@"goalID"];
        currentGoalProgressPercentage =[[goal2 objectForKey:@"goalPercentage"] doubleValue];
    }
    
    
    [self performSegueWithIdentifier:@"GoalToDetails" sender:nil];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GoalToDetails"])
    {
        detailsViewController *nav = [segue destinationViewController];
        
        [nav setCurrentGoalID:self.currentGoal];
        [nav setCurrentGoalProgressPercentage:currentGoalProgressPercentage];
        
    }
}


@end
