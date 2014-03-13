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


@synthesize tableView = _tableView;

@synthesize postArray;
@synthesize doneGoals;
@synthesize currentGoal;
@synthesize currentGoalProgressPercentage;
@synthesize currentUserID;
@synthesize array,array2;


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
    
    if (![currentUserID isEqualToString:@""])
    {
        PFUser *curreUser = [PFUser currentUser];
        currentUserID=[curreUser objectForKey:@"UserID"];

    }
    
    NSLog(@"User ID: %@",currentUserID);
    array=[[NSMutableArray alloc]init];
    array2=[[NSMutableArray alloc]init];
    //array=[self getinProgressGoalsFromDB];
    //array2=[self getDoneGoalsFromDB];
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
//    if ([PFUser currentUser]){
//        [self.tableView reloadData];
        //[self getInProgressGoals:nil];
        //[self getDoneGoals:nil];
    
        array=[self getinProgressGoalsFromDB];
        array2=[self getDoneGoalsFromDB];
        [self.tableView reloadData];

        
//    }
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
        return array.count;
    }
    else return array2.count;
}


//- (void)getInProgressGoals:(id)sender {
//    // Create a query
//    PFQuery *postQuery = [PFQuery queryWithClassName:@"Goal"];
//    postQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    //[postQuery orderByAscending:@"createdAt"];
//    [postQuery orderByDescending:@"createdAt"];
//
//    
//    // Follow relationship
//    [postQuery whereKey:@"CreatedBy" equalTo:[PFUser currentUser]];
//    [postQuery whereKey:@"isGoalCompleted" equalTo:@NO];
//
//    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            postArray = objects;           // Store results
//            [self.tableView reloadData];   // Reload table
//        }
//    }];
//    
//}

//- (void)getDoneGoals:(id)sender {
//    // Create a query
//    PFQuery *postQuery = [PFQuery queryWithClassName:@"Goal"];
//    postQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
//    [postQuery orderByDescending:@"createdAt"];
//
//    // Follow relationship
//    [postQuery whereKey:@"CreatedBy" equalTo:[PFUser currentUser]];
//    [postQuery whereKey:@"isGoalCompleted" equalTo:@YES];
//    
//    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            doneGoals = objects;           // Store results
//            [self.tableView reloadData];   // Reload table
//        }
//    }];
//    
//}

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
//        PFObject *goal = [postArray objectAtIndex:indexPath.row];
//        
//        [cell.goalName setText:[goal objectForKey:@"GoalName"]];
//        [cell.goalDescription setText:[goal objectForKey:@"GoalDesc"]];
//        [cell.goalDeadline setText:[goal objectForKey:@"GoalDeadline"]];
//        [cell.goalPercentage setText:[NSString stringWithFormat:@"%.2f",[[goal objectForKey:@"goalPercentage"] doubleValue]]];
        
        cell.backgroundColor=[UIColor grayColor];

            [cell.goalName setText:(NSString *)[[array objectAtIndex:indexPath.row] goalName]];
            [cell.goalDescription setText:(NSString *)[[array objectAtIndex:indexPath.row] goalDescription]];
            [cell.goalDeadline setText:(NSString *)[[array objectAtIndex:indexPath.row] goalDeadline]];
            [cell.goalPercentage setText:[NSString stringWithFormat:@"%.2f",[[array objectAtIndex:indexPath.row] goalProgress]]];
        
        //[cell.goalPercentage setText:(NSString *)[[array objectAtIndex:indexPath.row] goalPercentage]];

        
        
        
    }
    
    if (indexPath.section==1)
    {
//        PFObject *goal2 = [doneGoals objectAtIndex:indexPath.row];
//
//        [cell.goalName setText:[goal2 objectForKey:@"GoalName"]];
//        [cell.goalDescription setText:[goal2 objectForKey:@"GoalDesc"]];
//        [cell.goalDeadline setText:[goal2 objectForKey:@"GoalDeadline"]];
//        [cell.goalPercentage setText:[NSString stringWithFormat:@"%.2f",[[goal2 objectForKey:@"goalPercentage"] doubleValue]]];
        
        
        cell.backgroundColor=[UIColor whiteColor];
        
        [cell.goalName setText:(NSString *)[[array2 objectAtIndex:indexPath.row] goalName]];
        [cell.goalDescription setText:(NSString *)[[array2 objectAtIndex:indexPath.row] goalDescription]];
        [cell.goalDeadline setText:(NSString *)[[array2 objectAtIndex:indexPath.row] goalDeadline]];
        //[cell.goalPercentage setText:(NSString *)[[array2 objectAtIndex:indexPath.row] goalPercentage]];
        
        [cell.goalPercentage setText:[NSString stringWithFormat:@"%.2f",[[array2 objectAtIndex:indexPath.row] goalProgress]]];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.section==0){
//        PFObject *goal = [postArray objectAtIndex:indexPath.row];
//        currentGoal=[goal objectForKey:@"goalID"];
//        currentGoalProgressPercentage =[[goal objectForKey:@"goalPercentage"] doubleValue];
        currentGoalProgressPercentage=[[array objectAtIndex:indexPath.row] goalProgress];
        currentGoal = [NSString stringWithFormat:@"%d",[[array objectAtIndex:indexPath.row] goalID]] ;

        NSLog(@"%f",currentGoalProgressPercentage);
        
    }
    
    if (indexPath.section==1)
    {
//        PFObject *goal2 = [doneGoals objectAtIndex:indexPath.row];
//        currentGoal=[goal2 objectForKey:@"goalID"];
//        currentGoalProgressPercentage =[[goal2 objectForKey:@"goalPercentage"] doubleValue];
        
        currentGoalProgressPercentage=[[array2 objectAtIndex:indexPath.row] goalProgress];
        currentGoal = [NSString stringWithFormat:@"%d",[[array2 objectAtIndex:indexPath.row] goalID]] ;
        
        NSLog(@"%f",currentGoalProgressPercentage);
        
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

-(NSString*)DataFilePath{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //NSLog(@"%@",[paths objectAtIndex:0]);
    
    return [paths objectAtIndex:0];
}

-(NSMutableArray *) getDoneGoalsFromDB
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *createSQL= @"create table IF NOT exists Goals(goalId integer primary key,GoalName text, GoalDesc text, GoalDeadline text, isGoalCompleted integer, isGoalinPregress integer, goalPercentage REAL,CreatedBy text);";
    
    [db executeUpdate:createSQL];
    
    
    FMResultSet *result =[db executeQuery:@"select * from Goals where isGoalCompleted='1' AND isGoalinPregress='0';"];
    
    while ([result next])
    {
        Goal *goal=[[Goal alloc]init];
        goal.goalID=[result intForColumn:@"goalId"];
        goal.goalName=[result stringForColumn:@"GoalName"];
        goal.goalDescription=[result stringForColumn:@"GoalDesc"];
        goal.goalDeadline=[result stringForColumn:@"GoalDeadline"];
        goal.isGoalCompleted=[result intForColumn:@"isGoalCompleted"];
        goal.isGoalinProgress=[result intForColumn:@"isGoalinPregress"];
        goal.goalProgress=[result doubleForColumn:@"goalPercentage"];
        goal.createdBy =[result stringForColumn:@"CreatedBy"];

        [list addObject:goal];
    }
    
    return list;
}

-(NSMutableArray *) getinProgressGoalsFromDB
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    
    NSString *createSQL= @"create table IF NOT exists Goals(goalId integer primary key,GoalName text, GoalDesc text, GoalDeadline text, isGoalCompleted integer, isGoalinPregress integer, goalPercentage REAL,CreatedBy text);";
    
    [db executeUpdate:createSQL];
    

    FMResultSet *result =[db executeQuery:@"select * from Goals where isGoalinPregress='1' AND isGoalCompleted='0';"];
    
    while ([result next])
    {
        Goal *goal=[[Goal alloc]init];
        goal.goalID=[result intForColumn:@"goalId"];
        goal.goalName=[result stringForColumn:@"GoalName"];
        goal.goalDescription=[result stringForColumn:@"GoalDesc"];
        goal.goalDeadline=[result stringForColumn:@"GoalDeadline"];
        goal.isGoalCompleted=[result intForColumn:@"isGoalCompleted"];
        goal.isGoalinProgress=[result intForColumn:@"isGoalinPregress"];
        goal.goalProgress=[result doubleForColumn:@"goalPercentage"];
        goal.createdBy =[result stringForColumn:@"CreatedBy"];
        
        [list addObject:goal];
    }
    
    return list;
}

@end
