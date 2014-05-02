//
//  newProgressViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/25/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "newProgressViewController.h"

@interface newProgressViewController ()

@end

@implementation newProgressViewController

@synthesize currentGoal;
@synthesize currentUser;

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
    
    if (currentGoal.goalProgress==100.00)
    {
        self.progressPercenatge.enabled=NO;
        
    }
    //NSLog(@"66 %d",currentUser.wantsToShare);

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int) checkTheEnteredProgress
{
    
    int X=-1;
    
    //invalid input
    if ( [self.progressPercenatge.text isEqual:@""] && self.currentGoal.isGoalCompleted==NO)
    {
        
        X=-3;
    }
    
    // curent goal progress + new progress < 100
    else if (self.currentGoal.goalProgress+[self.progressPercenatge.text doubleValue] < 100 && self.currentGoal.isGoalCompleted==NO)
    {
        
        X=1;
    }
    // curent goal progress + new progress = 100
    
    else if (self.currentGoal.goalProgress+[self.progressPercenatge.text doubleValue] == 100 && self.currentGoal.isGoalCompleted==NO)
    {
        X=0;
    }
    
    // invalid input
    else if ([self.progressPercenatge.text doubleValue] > 100 && self.currentGoal.isGoalCompleted==NO)
    {
        X=-2;
    }
    
    else if (self.currentGoal.isGoalCompleted==YES)
    {
        
        X=4;
    }
    
    //NSLog(@"X= %d",X);
    return X;
}


-(NSString *)getCurrentDataAndTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    
    NSDate *Todaydata=[NSDate date];
    
    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
    
    return currentData;
}

-(NSString *)getCurrentDataAndTimeForLogging
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *Todaydata=[NSDate date];
    
    NSString *currentData= [dateFormatter stringFromDate:Todaydata];
    
    return currentData;
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


- (IBAction)isSaveisPressed:(UIBarButtonItem *)sender {
    
    Progress *progress=[[Progress alloc]init];
    progress.progressDescription=self.progressDescription.text;
    progress.goalID=self.currentGoal.goalID;
    progress.LoggedBy=self.currentGoal.createdBy;
    progress.numberOfCommentss=0;
    progress.numberOfLikes=0;

    int check=[self checkTheEnteredProgress];
    
    if (check==1) // meaning the currentGoalProgress+new progress < 100
    {
        progress.progressPercentageToGoal=[self.progressPercenatge.text doubleValue];
        progress.progressDate=[self getCurrentDataAndTime];
        progress.stepOrder=self.currentGoal.numberOfGoalSteps+1;
        progress.progressID=[[self nextIdentifies] integerValue];

        
        [progress AddProgressltoDatabase];
        [progress AddProgresslToParse];
        
        Log *newLog=[[Log alloc]init];
        newLog.userUsername=currentUser.userUsername;
        newLog.logDate=[self getCurrentDataAndTimeForLogging];
        newLog.logContent=[NSString stringWithFormat:@"%@ / %@ / %@ ",self.progressDescription.text,self.progressPercenatge.text,currentGoal.goalName];
    
        newLog.logType=@"Progress";
        newLog.logAction=@"Log";
        newLog.month=[[self getMonth] integerValue];
        newLog.year=[[self getYear] integerValue];

        
        [newLog addLOG];

        Goal*goal=currentGoal;
        Goal*parseGoal=currentGoal;
        
        goal.numberOfGoalSteps=goal.numberOfGoalSteps+1;
        
        [goal UpdataGoalWithProgress:[self.progressPercenatge.text doubleValue] WithMark:@"+"];
        [parseGoal UpdataGoalWithProgressInParse:[self.progressPercenatge.text doubleValue] WithMark:@"+"];
        
        NSString *sum=[NSString stringWithFormat:@"%.2f",[self.progressPercenatge.text doubleValue]+goal.goalProgress];
        goal.goalProgress=[sum doubleValue];
        
        [[self delegate]setGoal:goal];
        

        // New timeline Post
            TimelinePost *newPost=[[TimelinePost alloc]init];
            
            newPost.userFirstName=currentUser.userFirsname;
            newPost.userLastName=currentUser.userLastname;
            newPost.username=currentUser.userUsername;
            newPost.userProfilePic=currentUser.userProfileImage;
            
            newPost.PostContent=[NSString stringWithFormat:@"%@ made a progress: %@ in %@",currentUser.userFirsname,progress.progressDescription,currentGoal.goalName];
            newPost.PostOtherRelatedInFormationContent=[NSString stringWithFormat:@"%d",progress.progressID];
            
            newPost.PostType=@"Progress";
            newPost.PostDate=progress.progressDate;
        
        if (currentUser.wantsToShare==YES)
        {
            [newPost NewTimelinePost];
            
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else if (check==0) // meaning the currentGoalProgress+new progress = 100
    {
        progress.progressPercentageToGoal=[self.progressPercenatge.text doubleValue];
        
        progress.progressDate=[self getCurrentDataAndTime];
        progress.progressID=[[self nextIdentifies] integerValue];
        progress.stepOrder=self.currentGoal.numberOfGoalSteps+1;
        progress.progressID=[[self nextIdentifies] integerValue];
        
        [progress AddProgressltoDatabase];
        [progress AddProgresslToParse];
        
        Log *newLog=[[Log alloc]init];
        newLog.userUsername=currentUser.userUsername;
        newLog.logDate=[self getCurrentDataAndTimeForLogging];
        newLog.logContent=[NSString stringWithFormat:@"%@ / %@ / %@ ",self.progressDescription.text,self.progressPercenatge.text,currentGoal.goalName];
        
        newLog.logType=@"Progress";
        newLog.logAction=@"Log";
        newLog.month=[[self getMonth] integerValue];
        newLog.year=[[self getYear] integerValue];

        
        [newLog addLOG];
        
        
        // New timeline Post
        
        TimelinePost *newPost=[[TimelinePost alloc]init];
      
            newPost.userFirstName=currentUser.userFirsname;
            newPost.userLastName=currentUser.userLastname;
            newPost.username=currentUser.userUsername;
            newPost.userProfilePic=currentUser.userProfileImage;
            
            newPost.PostContent=[NSString stringWithFormat:@"%@ made a progress: %@ in %@",currentUser.userFirsname,progress.progressDescription,currentGoal.goalName];
            
            
            newPost.PostOtherRelatedInFormationContent=[NSString stringWithFormat:@"%d",progress.progressID];
            
            newPost.PostType=@"Progress";
            
            newPost.PostDate=progress.progressDate;
        
        if (currentUser.wantsToShare==YES)
        {
            [newPost NewTimelinePost];
        }
        
        
        Goal *goal=currentGoal;
        
        goal.numberOfGoalSteps=goal.numberOfGoalSteps+1;
        [goal declareGoalAsAchieved];
        [goal declareGoalAsAchievedinParse];
        
       

        TimelinePost *newPost2=[[TimelinePost alloc]init];
        
        newPost2.userFirstName=currentUser.userFirsname;
        newPost2.userLastName=currentUser.userLastname;
        newPost2.username=currentUser.userUsername;
        newPost2.userProfilePic=currentUser.userProfileImage;
        
        newPost2.PostContent=[NSString stringWithFormat:@"%@ has achieved a goal: %@",currentUser.userFirsname,goal.goalName];
        newPost.PostOtherRelatedInFormationContent=[NSString stringWithFormat:@"%d",goal.goalID];
        
        newPost2.PostType=@"Goal";
        newPost2.PostDate=progress.progressDate;
        
        if (currentUser.wantsToShare==YES)
        {
            [newPost2 NewTimelinePost];
        
        }
        
        currentGoal.goalProgress=100.00;
        
        [[self delegate]setGoal:currentGoal];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    else if (check==-1) // meaning the new progress is larger than the remaining
    {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                          message:[NSString stringWithFormat:@"The current progress for the selected goal is %.2f",currentGoal.goalProgress]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];

        
        [message show];
    }
    
    else if (check==-2 || check==-3) //invalid
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                          message:@"Invalid Input"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        
        [message show];
        
    }
    
    else if (check==4) // in case the goal is done and the user wants to enter a progress
    {
        progress.progressDescription=self.progressDescription.text;
        progress.goalID=self.currentGoal.goalID;
        progress.LoggedBy=self.currentGoal.createdBy;
        progress.numberOfCommentss=0;
        progress.numberOfLikes=0;
        
        progress.progressPercentageToGoal=0;
        progress.progressDate=[self getCurrentDataAndTime];
        progress.stepOrder=self.currentGoal.numberOfGoalSteps+1;
        progress.progressID=[[self nextIdentifies] integerValue];
        
        
        
        [progress AddProgressltoDatabase];
        
        [progress AddProgresslToParse];
        
        Log *newLog=[[Log alloc]init];
        newLog.userUsername=currentUser.userUsername;
        newLog.logDate=[self getCurrentDataAndTimeForLogging];
        newLog.logContent=[NSString stringWithFormat:@"%@ / %.2f / %@ ",self.progressDescription.text,progress.progressPercentageToGoal,currentGoal.goalName];
        
        newLog.logType=@"Progress";
        newLog.logAction=@"Log";
        newLog.month=[[self getMonth] integerValue];
        newLog.year=[[self getYear] integerValue];

        [newLog addLOG];

        
        Goal*goal=currentGoal;
        Goal*parseGoal=currentGoal;
        
        goal.numberOfGoalSteps=goal.numberOfGoalSteps+1;
        
        [goal UpdataGoalWithProgress:0 WithMark:@"+"];
        [parseGoal UpdataGoalWithProgressInParse:0 WithMark:@"+"];
        
        
        NSString *sum=[NSString stringWithFormat:@"%.2f",0+goal.goalProgress];
        goal.goalProgress=[sum doubleValue];

        [[self delegate]setGoal:goal];
        
        
        // New timeline Post
        TimelinePost *newPost=[[TimelinePost alloc]init];
        
        newPost.userFirstName=currentUser.userFirsname;
        newPost.userLastName=currentUser.userLastname;
        newPost.username=currentUser.userUsername;
        newPost.userProfilePic=currentUser.userProfileImage;
        
        newPost.PostContent=[NSString stringWithFormat:@"%@ made a progress: %@ in %@",currentUser.userFirsname,progress.progressDescription,currentGoal.goalName];
        newPost.PostOtherRelatedInFormationContent=[NSString stringWithFormat:@"%d",progress.progressID];
        
        newPost.PostType=@"Progress";
        newPost.PostDate=progress.progressDate;
        
        
        if (currentUser.wantsToShare==YES)
        {
            [newPost NewTimelinePost];
            
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
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
- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
