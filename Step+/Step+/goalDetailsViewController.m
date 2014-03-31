//
//  goalDetailsViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/24/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "goalDetailsViewController.h"

@interface goalDetailsViewController ()

@end

@implementation goalDetailsViewController

@synthesize currentGoal;
@synthesize currentUser;

@synthesize progressList;
@synthesize progressListFromParse;
@synthesize tableview = _tableview;


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
    

    // Do any additional setup after loading the view.
    
    progressList=[[NSMutableArray alloc]init];
    progressListFromParse=[[NSMutableArray alloc]init];
    
    progressList=[self getProgressList];

    
    if ([progressList count]==0)
    {
        NSLog(@"Progress, We still need to add it to DB");
        progressListFromParse=[self getProgressFromParse];
        for (Progress *newProgress in progressListFromParse)
        {
            [newProgress AddProgressltoDatabase];
        }
    }
    
    NSLog(@"%d",self.currentUser.numberOfInProgressGoals);
    NSLog(@"%d",self.currentUser.numberOfAchievedGoals);

}

-(void) viewWillAppear:(BOOL)animated
{
    self.GoalNameLable.text=currentGoal.goalName;
    self.GoalDescriptionLable.text=currentGoal.goalDescription;
    self.GoalTypeLable.text=currentGoal.goalType;
    self.TotalPercentageLable.text=[[NSString stringWithFormat:@"%.2f",currentGoal.goalProgress] stringByAppendingString:@"%"];
    
    self.NumberofStepsTakenLable.text=[NSString stringWithFormat:@"Step Taken: %d",currentGoal.numberOfGoalSteps];
    
    NSInteger days=[self daysBetweenDate:currentGoal.goalDate andDate:[self getCurrentDataAndTime]];
    NSInteger days2=[self daysBetweenDate:[self getCurrentDataAndTime] andDate:currentGoal.goalDeadline];
    
    self.numberofDaysSinceCreated.text=[NSString stringWithFormat:@"Number of days since Createted: %d",days];
    
    self.NumberofdaysyillDeadline.text=[NSString stringWithFormat:@"Number of days till Deadline %d",days2];
    
    progressList=[self getProgressList];
    [self.tableview reloadData];

}


-(NSInteger)daysBetweenDate:(NSString*)fromDateTime andDate:(NSString*)toDateTime
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/DD/YYYY hh:mm:ss"];
    
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



-(NSString *)getCurrentDataAndTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/DD/YYYY hh:mm:ss"];
    NSDate *Todaydata=[NSDate date];
    
    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
    
    return currentData;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([[segue identifier] isEqualToString:@"addProgress"])
    {
        newProgressViewController* nav = [segue destinationViewController];
        [nav setCurrentGoal:currentGoal];
        [nav setDelegate:self];
    }
}

-(void) setGoal:(Goal *)updatedGoal
{
    self.currentGoal=updatedGoal;
}

- (IBAction)declareGoalAchieaved:(UIButton *)sender {
    
    Goal *goal=self.currentGoal;
    
    goal.goalID=self.currentGoal.goalID;
    
    goal.numberOfGoalSteps=goal.numberOfGoalSteps+1;
    
    [goal declareGoalAsAchieved];
    [goal declareGoalAsAchievedinParse];
    
    currentUser.numberOfAchievedGoals=currentUser.numberOfAchievedGoals+1;
    currentUser.numberOfInProgressGoals=currentUser.numberOfInProgressGoals-1;
    
    [currentUser UpdateUserDataDB];
    
    Progress *progress=[[Progress alloc]init];
    progress.progressDescription=@"Achieved Peogress";
    progress.goalID=self.currentGoal.goalID;
    progress.LoggedBy=self.currentGoal.createdBy;
    
    progress.progressPercentageToGoal=100-currentGoal.goalProgress;
    progress.progressDate=[self getCurrentDataAndTime];
    
    progress.stepOrder=self.currentGoal.numberOfGoalSteps;
    
    progress.progressID=[[self nextIdentifies] integerValue];
    
    [progress AddProgressltoDatabase];
    [progress AddProgresslToParse];
    
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Congrats!"
                                                      message:@"The Goal is Achieved"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
    
    NSString *qr=[NSString stringWithFormat:@"select * from Progress where goalId='%d' AND createdBy='%@';",currentGoal.goalID,currentGoal.createdBy];
    
    
    NSLog(@"%@",qr);
    
    
    FMResultSet *result =[db executeQuery:qr];
    
    while ([result next])
    {
        
        Progress *progress=[[Progress alloc]init];
        
        progress.goalID=[result intForColumn:@"goalID"];
        progress.progressID=[result intForColumn:@"progressID"];
        progress.progressDescription = [result stringForColumn:@"progressDescription"];
        progress.progressPercentageToGoal = [result doubleForColumn:@"progressPercentageToGoal"];
        progress.progressDate=[result stringForColumn:@"progressDate"];
        progress.LoggedBy=[result stringForColumn:@"createdBy"];
        progress.stepOrder=[result intForColumn:@"stepOrder"];
        
        [list addObject:progress];
    }
    
    return list;
}

-(NSMutableArray *) getProgressFromParse
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Progress"];
    
    [query whereKey:@"createdBy" equalTo:currentGoal.createdBy];
    
    [query whereKey:@"goalID" equalTo:[NSString stringWithFormat:@"%d",currentGoal.goalID]];
    
    NSError *error=nil;
    NSArray* progresses=[query findObjects:&error];
    
    for(PFObject *obj in progresses)
    {
        Progress *progress=[[Progress alloc]init];
        
        progress.goalID= [[obj objectForKey:@"goalID"] integerValue];
        progress.progressID= [[obj objectForKey:@"progressID"] integerValue];
        progress.progressDescription=[obj objectForKey:@"ProgressName"];
        progress.progressDate=[obj objectForKey:@"LogDate"];
        progress.stepOrder=[[obj objectForKey:@"stepOrder"] integerValue];
        progress.progressPercentageToGoal=[[obj objectForKey:@"ProgressPercentage"] doubleValue];
        progress.LoggedBy=[obj objectForKey:@"createdBy"];
        
        [list addObject:progress];
    }
    
    return list;
    
}


-(NSString *)nextIdentifies
{
    static NSString* lastID = @"lastID";
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSInteger identifier = [defaults integerForKey:lastID] + 1;
    [defaults setInteger:identifier forKey:lastID];
    [defaults synchronize];
    return [NSString stringWithFormat:@"%ld",(long)identifier];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [progressList count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    static NSString *simpleTableIdentifier = @"progressCell";
    
    ProgressTableViewCell *cell = (ProgressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"progressTableViewCell" owner:self options:nil];
    
    cell = [nib objectAtIndex:0];
    
    [cell.progressName setText:(NSString *)[[progressList objectAtIndex:indexPath.row] progressDescription]];
    
    [cell.progressPercentage setText:[NSString stringWithFormat:@"%.2f",[[progressList objectAtIndex:indexPath.row] progressPercentageToGoal]]];
    
    [cell.cellStepOrder setText:[NSString stringWithFormat:@"Step: %d",[[progressList objectAtIndex:indexPath.row] stepOrder]]];
    
    
    
    cell.ProgressDate.text=[self GetWordyTime:[[progressList objectAtIndex:indexPath.row] progressDate]];

;

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}




- (IBAction)deleteGoal:(UIBarButtonItem *)sender {
    
    Goal *goal=self.currentGoal;
    Progress *progress=[[Progress alloc]init];
    progress.goalID=currentGoal.goalID;
    progress.LoggedBy=currentGoal.createdBy;
    
    
    [goal DeleteGoalFromDatabase];
    [progress DeleteProgressFromDatabase];
    [goal DeleteGoalFromParse];
    [progress DeleteProgressFromParse];
    
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                      message:@"The goal is deleteted"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(NSString *) GetWordyTime: (NSString *) Y
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/DD/YYYY hh:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate *dateFromString = [[NSDate alloc]init];
    
    dateFromString = [dateFormatter dateFromString:Y];
    
    NSLog(@"%@",Y);
    
    NSString *strDate = [dateFormatter stringFromDate:dateFromString];
    
    NSLog(@"%@",strDate);
    
    NSString * I=[dateFromString prettyDate];
    
    
    NSLog(@"%@",I);
    
    return I;
}

@end
