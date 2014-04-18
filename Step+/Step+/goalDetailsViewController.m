//
//  goalDetailsViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/24/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "goalDetailsViewController.h"

#define Facebook @"Facebook"
#define Twitter @"Twitter"
#define CANCEL_BUTTON_TITLE @"Cancel"


@interface goalDetailsViewController ()

@end

@implementation goalDetailsViewController

@synthesize currentGoal;
@synthesize currentUser;

@synthesize progressList;
@synthesize progressListFromParse;
@synthesize tableview = _tableview;
@synthesize currentProgress;


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
    
    currentProgress=[[Progress alloc]init];
    
    progressList=[[NSMutableArray alloc]init];
    progressListFromParse=[[NSMutableArray alloc]init];
    
    progressList=[self getProgressList];
    
    //progressListFromParse=[self getProgressFromParse];
    
    if ([progressList count]==0)
    {
        NSLog(@"Progress, We still need to add it to DB");
        
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
    
    
    NSInteger days2=[self daysBetweenDate:[self getCurrentDataAndTime] andDate:currentGoal.goalDeadline];
    self.NumberofdaysyillDeadline.text=[NSString stringWithFormat:@"Number of days till Deadline %d days",days2];
    
    NSInteger days=[self daysBetweenDate:currentGoal.goalDate andDate:[self getCurrentDataAndTime]];
    self.numberofDaysSinceCreated.text=[NSString stringWithFormat:@"Number of days since Createted: %d days",days+1];
    
    NSLog(@"Steps %d",currentGoal.numberOfGoalSteps);
    
    progressList=[self getProgressList];
    progressListFromParse=[self getProgressFromParse];
    
    [self.tableview reloadData];
}

-(NSInteger)daysBetweenDate:(NSString*)fromDateTime andDate:(NSString*)toDateTime
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
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
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSDate *Todaydata=[NSDate date];
    
    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
    
    return currentData;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"addProgress"])
    {
        UINavigationController *nav = [segue destinationViewController];
        newProgressViewController *vc =(newProgressViewController*)nav.topViewController;

        [vc setCurrentGoal:currentGoal];
        [vc setCurrentUser:currentUser];
        
        [vc setDelegate:self];
    }
    
    if ([[segue identifier] isEqualToString:@"toGoalSuggestion"])
    {
        goalSuggestionsViewController* nav = [segue destinationViewController];
        [nav setCurrentGoal:currentGoal];
        [nav setCurrentUser:currentUser];
        
    }
    
    if ([[segue identifier] isEqualToString:@"toProgressDetails"])
    {
        ProgressDetailsViewController* nav = [segue destinationViewController];
        [nav setCurrentProgress:currentProgress];
        [nav setCurrentUser:currentUser];
        
    }
    
    if ([[segue identifier] isEqualToString:@"toLikeList"])
    {
        ProgressDetailsLikeListViewController* nav = [segue destinationViewController];
        [nav setCurrentProgress:currentProgress];
        [nav setCurrentUser:currentUser];
        
    }
    
    if ([[segue identifier] isEqualToString:@"EditGoal"])
    {
        UINavigationController *nav = [segue destinationViewController];
        EditGoalViewController *vc =(EditGoalViewController*)nav.topViewController;
        
        [vc setCurrentGoal:currentGoal];
    }
}

-(void) setGoal:(Goal *)updatedGoal
{
    self.currentGoal=updatedGoal;
}

- (IBAction)declareGoalAchieaved:(UIButton *)sender {
    
    Goal *goal=self.currentGoal;
    
    if (goal.goalProgress==100)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                          message:@"The Goal is already Achieved"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        
    }
    
    else
    {
        goal.goalID=self.currentGoal.goalID;
        
        goal.numberOfGoalSteps=goal.numberOfGoalSteps+1;
        
        [goal declareGoalAsAchieved];
        [goal declareGoalAsAchievedinParse];
        
        currentUser.numberOfAchievedGoals=currentUser.numberOfAchievedGoals+1;
        currentUser.numberOfInProgressGoals=currentUser.numberOfInProgressGoals-1;
        
        [currentUser UpdateUserDataDB];
        [currentUser UpdateUserParse];
        
        
        Progress *progress=[[Progress alloc]init];
        progress.progressDescription=@"Achieved Peogress";
        progress.goalID=self.currentGoal.goalID;
        progress.LoggedBy=self.currentGoal.createdBy;
        
        progress.progressPercentageToGoal=100-currentGoal.goalProgress;
        progress.progressDate=[self getCurrentDataAndTime];
        
        progress.stepOrder=self.currentGoal.numberOfGoalSteps;
        
        progress.progressID=[[self nextIdentifies] integerValue];
        progress.numberOfLikes=0;
        progress.numberOfCommentss=0;
        
        [progress AddProgressltoDatabase];
        [progress AddProgresslToParse];
        
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Congrats!"
                                                          message:@"The Goal is Achieved"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        
        
        Log *newLog=[[Log alloc]init];
        
        newLog.userUsername=currentUser.userUsername;
        newLog.logDate=[self getCurrentDataAndTimeForLogging];
        newLog.logContent=[NSString stringWithFormat:@"%@",self.currentGoal.goalName];
        newLog.logType=@"Goal";
        newLog.logAction=@"Achieve";
        newLog.month=[[self getMonth] integerValue];
        newLog.year=[[self getYear] integerValue];

        
        [newLog addLOG];
        
        
        if (currentUser.wantsToShare==YES)
        {
        
            TimelinePost *newPost=[[TimelinePost alloc]init];
            
            newPost.userFirstName=currentUser.userFirsname;
            newPost.userLastName=currentUser.userLastname;
            newPost.username=currentUser.userUsername;
            newPost.userProfilePic=currentUser.userProfileImage;
            
            newPost.PostContent=[NSString stringWithFormat:@"%@ has achieved a goal: %@",currentUser.userFirsname,goal.goalName];
            newPost.PostOtherRelatedInFormationContent=[NSString stringWithFormat:@"%d",goal.goalID];
            
            newPost.PostType=@"Goal";
            newPost.PostDate=progress.progressDate;
            
            [newPost NewTimelinePost];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
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
        progress.numberOfCommentss=[[obj objectForKey:@"numberOfComments"] integerValue];
        progress.numberOfLikes=[[obj objectForKey:@"numberOfLikes"] integerValue];
        
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
    
    
    
    cell.ProgressDate.text=[self GetTimeinWords:[[progressList objectAtIndex:indexPath.row] progressDate]];
    
    
    cell.numberOfComments.text=[NSString stringWithFormat:@"%d",[[progressListFromParse objectAtIndex:indexPath.row] numberOfCommentss]];
    
    cell.nLikes.text=[NSString stringWithFormat:@"%d",[[progressListFromParse objectAtIndex:indexPath.row] numberOfLikes]];
    
    
    [cell.comments addTarget:self action:@selector(GotoComments:)  forControlEvents:UIControlEventTouchUpInside];
    
    [cell.comments setTag:indexPath.row];
    
    
    [cell.likes addTarget:self action:@selector(GotoLikes:) forControlEvents:UIControlEventTouchUpInside];
    [cell.likes setTag:indexPath.row];
    
    
    [cell.deleteProgress addTarget:self action:@selector(deleteProgressSel:)  forControlEvents:UIControlEventTouchUpInside];
    
    [cell.deleteProgress setTag:indexPath.row];
    
    cell.deleteProgress.hidden=YES;
    
    
    return cell;
}

- (IBAction)deleteProgressSel:(id)sender
{
    NSLog(@"TTT");
    
    UIButton *button = (UIButton *)sender;
    
    int row = button.tag;
    NSLog(@"isPressed");
    
    NSLog(@"%d",row);
    
    currentProgress= [progressList objectAtIndex:row];
    
    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: @"Progress Deletion" message: @"Are you sure you want to delete" delegate: self cancelButtonTitle: @"Yes"  otherButtonTitles:@"Cancel",nil];
    updateAlert.tag=1;
    [updateAlert show];
    
}


- (IBAction)GotoLikes:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    int row = button.tag;
    NSLog(@"isPressed");
    
    NSLog(@"%d",row);
    
    currentProgress.progressID = [[progressList objectAtIndex:row] progressID];
    currentProgress.progressPercentageToGoal =[[progressList objectAtIndex:row] progressPercentageToGoal];
    
    currentProgress.goalID=currentGoal.goalID;
    
    currentProgress.LoggedBy=currentGoal.createdBy;
    
    currentProgress.progressDescription=[[progressList objectAtIndex:row]progressDescription];
    currentProgress.progressDate=[[progressList objectAtIndex:row]progressDate];
    currentProgress.stepOrder=[[progressList objectAtIndex:row]stepOrder];
    
    
    [self performSegueWithIdentifier:@"toLikeList" sender:nil];
}

- (IBAction)GotoComments:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    int row = button.tag;
    NSLog(@"isPressed");
    
    NSLog(@"%d",row);
    
    currentProgress.progressID = [[progressList objectAtIndex:row] progressID];
    currentProgress.progressPercentageToGoal =[[progressList objectAtIndex:row] progressPercentageToGoal];
    
    currentProgress.goalID=currentGoal.goalID;
    
    currentProgress.LoggedBy=currentGoal.createdBy;
    
    currentProgress.progressDescription=[[progressList objectAtIndex:row]progressDescription];
    currentProgress.progressDate=[[progressList objectAtIndex:row]progressDate];
    currentProgress.stepOrder=[[progressList objectAtIndex:row]stepOrder];
    
    [self performSegueWithIdentifier:@"toProgressDetails" sender:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (IBAction)deleteGoal:(UIBarButtonItem *)sender {
    
    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle: @"Goal Deletion" message: @"Are you sure you want to delete" delegate: self cancelButtonTitle: @"Yes"  otherButtonTitles:@"Cancel",nil];
    
    updateAlert.tag=0;
    [updateAlert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==0)
    {
        if(buttonIndex==0)
        {
            NSLog(@"Yes Goal is deleted");
            Goal *goal=self.currentGoal;
            Progress *progress=[[Progress alloc]init];
            progress.goalID=currentGoal.goalID;
            progress.LoggedBy=currentGoal.createdBy;
            
            
            [goal DeleteGoalFromDatabase];
            [progress DeleteProgressFromDatabase];
            [goal DeleteGoalFromParse];
            [progress DeleteProgressFromParse];
            
            Log *newLog=[[Log alloc]init];
            
            newLog.userUsername=currentUser.userUsername;
            newLog.logDate=[self getCurrentDataAndTimeForLogging];
            newLog.logContent=[NSString stringWithFormat:@"%@",self.currentGoal.goalName];
            newLog.logType=@"Goal";
            newLog.logAction=@"Deleted";
            newLog.month=[[self getMonth] integerValue];
            newLog.year=[[self getYear] integerValue];

            [newLog addLOG];

            
            if (goal.isGoalCompleted==NO)
            {
                currentUser.numberOfInProgressGoals=currentUser.numberOfInProgressGoals-1;
                [currentUser UpdateUserDataDB];
                [currentUser UpdateUserParse];
                
                
            }
            else
            {
                currentUser.numberOfAchievedGoals=currentUser.numberOfAchievedGoals-1;
                
                [currentUser UpdateUserDataDB];
                [currentUser UpdateUserParse];
                
            }
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                              message:@"The goal is deleteted"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            
            [message show];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
        else
        {
            NSLog(@"NO Goal isn't deleted");
            
        }
    }
    else
    {
        if(buttonIndex==0)
        {
            
            NSLog(@"Yes Progress is Deleted");
            [currentProgress DeleteSingleProgressFromParse];
            [currentProgress DeleteSingleProgressFromDatabase];
            
            Log *newLog=[[Log alloc]init];
            
            [newLog addLOG];

            
            Goal*goal=currentGoal;
            Goal*parseGoal=currentGoal;
            
            goal.numberOfGoalSteps=goal.numberOfGoalSteps-1;
            
            
            if ((goal.goalProgress==100 && goal.goalProgress-currentProgress.progressPercentageToGoal<100))
            {
                goal.isGoalCompleted=NO;
                goal.isGoalinProgress=NO;
                
                [goal declareGoalAsUNAchieved];
                [goal declareGoalAsUNAchievedinParse];
                
                currentUser.numberOfInProgressGoals=currentUser.numberOfInProgressGoals+1;
                currentUser.numberOfAchievedGoals=currentUser.numberOfAchievedGoals-1;
                [currentUser UpdateUserDataDB];
                [currentUser UpdateUserParse];

            }
            
    
            [goal UpdataGoalWithProgress:currentProgress.progressPercentageToGoal WithMark:@"-"];
            
            [parseGoal UpdataGoalWithProgressInParse:currentProgress.progressPercentageToGoal WithMark:@"-"];
            
            self.TotalPercentageLable.text=[[NSString stringWithFormat:@"%.2f",currentGoal.goalProgress-currentProgress.progressPercentageToGoal] stringByAppendingString:@"%"];
            
    
            
            self.NumberofStepsTakenLable.text=[NSString stringWithFormat:@"Step Taken: %d",currentGoal.numberOfGoalSteps-1];
            
            
            [progressList removeObject:currentProgress];
            
            [self.tableview reloadData];
            
        }
        
        else
        {
            NSLog(@"No Progress isn't Deleted");
            
            
        }
    }
    
}

-(NSString *) GetTimeinWords: (NSString *) Y
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate *dateFromString = [[NSDate alloc]init];
    
    dateFromString = [dateFormatter dateFromString:Y];
    
    
    
    
    NSString * I=[dateFromString prettyDate];
    
    return I;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProgressTableViewCell *cell = (ProgressTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.deleteProgress.hidden=NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProgressTableViewCell *cell = (ProgressTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.deleteProgress.hidden=YES;
    
}



-(NSString *)getCurrentDataAndTimeForLogging
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *Todaydata=[NSDate date];
    
    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
    
    return currentData;
}

-(NSString *)getMonth
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSDate *Todaydata=[NSDate date];
    
    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
    
    return currentData;
}

-(NSString *)getYear
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSDate *Todaydata=[NSDate date];
    
    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
    
    return currentData;
}

- (IBAction)shareSocial:(id)sender {
    
    
    if(!self.actionSheet){
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Share A goal"
                                                                delegate:self cancelButtonTitle:nil
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:nil];
        
        [actionSheet addButtonWithTitle:Facebook];
        [actionSheet addButtonWithTitle:Twitter];
        [actionSheet addButtonWithTitle:CANCEL_BUTTON_TITLE];
        [actionSheet setCancelButtonIndex:actionSheet.numberOfButtons-1];
        [actionSheet showInView:sender];
        
        self.actionSheet = actionSheet;
    }

    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if([choice isEqualToString:Facebook]){
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [controller setInitialText:@"First post from my iPhone app"];
            [self presentViewController:controller animated:YES completion:Nil];
    }
        
    else if([choice isEqualToString:Twitter])
    {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:@"Great fun to learn iOS programming at appcoda.com!"];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
    }
}
    
}

@end
