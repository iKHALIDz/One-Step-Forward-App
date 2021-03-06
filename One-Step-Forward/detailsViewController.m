//
//  detailsViewController.m
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 2/21/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "detailsViewController.h"

@interface detailsViewController ()

@end

@implementation detailsViewController

@synthesize currentProgress;
//@synthesize currentGoalID;
@synthesize postArray;
//@synthesize currentGoalProgressPercentage;
@synthesize tableView = _tableView;
@synthesize doneProgress;
@synthesize array;
@synthesize currentGoal;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


- (IBAction)deleteProgress:(UIButton *)sender
{
    
    
}
-(id) initWithCoder:(NSCoder *)aDecoder
{
    
    self=[super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}


- (IBAction)DeleteGoal:(UIButton *)sender {
    
    
    Goal *goal=self.currentGoal;
    
    //goal.goalID=[currentGoalID integerValue];
    
    [goal DeleteGoalFromDatabase];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                      message:@"The goal is deleteted"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    
    [message show];

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(NSString *)getCurrentDataAndTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    NSDate *Todaydata=[NSDate date];
    
    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
    
    return currentData;
}


-(void) viewWillAppear:(BOOL)animated
{
    //self.currentGoalProgressPercentage=currentGoalProgressPercentage;
    
    self.currentGoal=currentGoal;
    
    //self.currentGoalProgressPercentage=currentGoal.goalProgress;
    self.CurrentGoalProgressLabel.text=[[NSString stringWithFormat:@"Total Percentage: %.2f",currentGoal.goalProgress] stringByAppendingString:@"%"];
    
    
    self.numberOfSteps.text=[NSString stringWithFormat:@"Number of Steps Taken: %d",currentGoal.goalSteps];
    
    array=[self getProgressList];
    [self.tableView reloadData];
    
    
    NSLog(@"Deadline: %@",currentGoal.goalDeadline);
    NSLog(@"Goal Created: %@",currentGoal.goalDate);
    NSLog(@"current Date %@ ",[self getCurrentDataAndTime]);

    
    NSInteger days=[self daysBetweenDate:currentGoal.goalDate andDate:[self getCurrentDataAndTime]];
    NSInteger days2=[self daysBetweenDate:[self getCurrentDataAndTime] andDate:currentGoal.goalDeadline];
    
    self.numberOfDaysSinceCreated.text=[NSString stringWithFormat:@"Number of days since Createted: %d",days];
    
    self.numberOfDaystillDeadline.text=[NSString stringWithFormat:@"Number of days till Deadline %d",days2];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString*)DataFilePath{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    return [paths objectAtIndex:0];
}



-(NSMutableArray *) getProgressList
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *qr=[NSString stringWithFormat:@"select * from Progress where goalId='%d';",currentGoal.goalID];
    
    
    NSLog(@"%@",qr);
    
    FMResultSet *result =[db executeQuery:qr];
    while ([result next])
    {
        Progress *progress=[[Progress alloc]init];
        
        progress.goalID=[result intForColumn:@"goalID"];
        progress.progressID=[result intForColumn:@"progressID"];
        progress.progressDescription = [result stringForColumn:@"progressDescription"];
        progress.progressPercentageToGoal = [result doubleForColumn:@"progressPercentageToGoal"];
        [list addObject:progress];
    }
    
    return list;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    array=[[NSMutableArray alloc]init];
    array=[self getProgressList];

   // NSLog(@"Progress: %f",currentGoalProgressPercentage);
    self.CurrentGoalProgressLabel.text=[[NSString stringWithFormat:@"%.2f",currentGoal.goalProgress] stringByAppendingString:@"%"];
    self.numberOfSteps.text=[NSString stringWithFormat:@"%d",currentGoal.goalSteps];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction) declareAchieved:(UIButton *)sender
{
    
    Goal *goal=self.currentGoal;
    
    goal.goalID=self.currentGoal.goalID;
    [goal declareGoalAsAchieved];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Congrats!"
                                                      message:@"The goal is Achieved"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
    
    [self.navigationController popViewControllerAnimated:YES];

    //[self dismissViewControllerAnimated:YES completion:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell2";
    progressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.progressName setText:(NSString *)[[array objectAtIndex:indexPath.row] progressDescription]];
    
    [cell.progressPercentage setText:[NSString stringWithFormat:@"%.2f",[[array objectAtIndex:indexPath.row] progressPercentageToGoal]]];

    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AddProgress"])
    {
        UINavigationController *nav = [segue destinationViewController];
        
        AddProgressViewController *vc =(AddProgressViewController*)nav.topViewController;

        //[vc setCurrentGoalID:self.currentGoalID];
        //[vc setCurrentGoalProgressPercentage:self.currentGoalProgressPercentage];
        
        [vc setCurrentGoal:self.currentGoal];
        [vc setDelegate:self];
    }
    else  if ([[segue identifier] isEqualToString:@"mangeProgress"])
    {
        UINavigationController *nav = [segue destinationViewController];
        
        MangeProgressViewController *vc =(MangeProgressViewController*)nav.topViewController;
        
        [vc setCurrentProgress:currentProgress];
        [vc setCurrentGoal:self.currentGoal];
        [vc setDelegate:self];

        
    }
}



-(void) setGoal:(Goal *)updatedGoal
{
    
    self.currentGoal=updatedGoal;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    progressTableViewCell *cell = (progressTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.deleteButton.hidden=NO;
    
    currentProgress=[[Progress alloc]init];
    
    currentProgress.progressID = [[array objectAtIndex:indexPath.row] progressID];
    
    currentProgress.progressPercentageToGoal =[[array objectAtIndex:indexPath.row] progressPercentageToGoal];
    currentProgress.goalID=currentGoal.goalID;
    currentProgress.LoggedBy=[currentGoal.createdBy integerValue];
    currentProgress.progressDescription=[[array objectAtIndex:indexPath.row]progressDescription];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    progressTableViewCell *cell = (progressTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.deleteButton.hidden=YES;
}



-(NSInteger)daysBetweenDate:(NSString*)fromDateTime andDate:(NSString*)toDateTime
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"mm/dd/yyyy"];
    
    NSDate *fromDate = [format dateFromString: fromDateTime];
    NSDate *toDate = [format dateFromString: toDateTime];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDate];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDate];
    
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}


@end
