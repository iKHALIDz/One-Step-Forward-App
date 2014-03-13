//
//  AddGoalViewController.m
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 2/13/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "AddGoalViewController.h"

@interface AddGoalViewController ()

@end



@implementation AddGoalViewController

@synthesize deadlineLabel;
@synthesize DeadlineLabelText;
@synthesize goalID;


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
}


-(void)viewDidAppear:(BOOL)animated
{
    
    if(DeadlineLabelText!=nil)
    {
        self.deadlineLabel.text=DeadlineLabelText;
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)isSavePressed:(UIBarButtonItem *)sender {
    
//    PFObject *newGoal = [PFObject objectWithClassName:@"Goal"];
//    
//    [newGoal setObject:self.goalName.text forKey:@"GoalName"];
//    [newGoal setObject:self.goalDesc.text forKey:@"GoalDesc"];
//    [newGoal setObject:self.deadlineLabel.text forKey:@"GoalDeadline"];
//    [newGoal setObject:[NSNumber numberWithBool:NO] forKey:@"isGoalCompleted"];
//    [newGoal setObject:[NSNumber numberWithBool:YES] forKey:@"isGoalinPregress"];
//    [newGoal setObject:@"0.0" forKey:@"goalPercentage"];
    

    //[self nextIdentifies];
    
    //[newGoal setObject:self.goalID forKey:@"goalID"];
    
    //Realationship
//    [newGoal setObject:[PFUser currentUser] forKey:@"CreatedBy"];
//    
//    
//    [newGoal saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            
    
            Goal *goal=[[Goal alloc]init];
            PFUser *curreUser = [PFUser currentUser];
            goal.createdBy=[curreUser objectForKey:@"UserID"];
            goal.goalName=self.goalName.text;
            goal.goalDescription=self.goalDesc.text;
            goal.goalDeadline=self.deadlineLabel.text;
            goal.isGoalCompleted=0;
            goal.isGoalinProgress=1;
            goal.goalProgress=0.0;
            
            [goal AddGoaltoDatabase];
            [[self navigationController] popViewControllerAnimated:YES];
    
    
    
//        }}];
}


-(void)setDeadline:(NSString*)deadline;
{
    
    self.deadlineLabel.text=deadline;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"VC"])
    {
        UINavigationController *nav = [segue destinationViewController];
        CalenderViewController *vc =(CalenderViewController*)nav.topViewController;
        
        [vc setDelegate:self];
        
    }
    
}

- (void)touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (! [self isFirstResponder])
    {
        {
            if ([self.goalName isFirstResponder]) {
                [self.goalName resignFirstResponder];
            }
            if ([self.goalDesc isFirstResponder]) {
                [self.goalDesc resignFirstResponder];
                
            }
            
        }
    }
}

- (IBAction)PickADeadlineDate:(UIButton *)sender
{
    
    
}


#pragma mark Create a random number 

//-(void)nextIdentifies
//{
//    static NSString* lastID = @"lastID";
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    NSInteger identifier = [defaults integerForKey:lastID] + 1;
//    [defaults setInteger:identifier forKey:lastID];
//    [defaults synchronize];
//    self.goalID=[NSString stringWithFormat:@"%ld",(long)identifier];
//    
//}


//-(NSString*)DataFilePath{
//    
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    NSLog(@"%@",[paths objectAtIndex:0]);
//    
//    return [paths objectAtIndex:0];
//}
//
//
//-(void)AddGoaltoDatabase
//{
//
//    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
//    
//    BOOL isOpen=[db open];
//    
//    if (isOpen==NO)
//    {
//        NSLog(@"Fail to open");
//        
//    }
//    
//    NSString *createSQL= @"create table IF NOT exists Goals(goalId integer primary key,GoalName text, GoalDesc text, GoalDeadline text, isGoalCompleted integer, isGoalinPregress integer, goalPercentage REAL,CreatedBy text);";
//    
//    [db executeUpdate:createSQL];
//    
//    // 0 means False
//    // 1 means True
//    
//    PFUser *curreUser = [PFUser currentUser];
//
//    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO Goals (goalId,GoalName,GoalDesc,GoalDeadline,isGoalCompleted,isGoalinPregress,goalPercentage,CreatedBy) VALUES (%d,'%@','%@','%@','%d','%d','%f','%@')",[goalID integerValue],self.goalName.text,self.goalDesc.text,self.deadlineLabel.text,0,1,0.0,[curreUser objectForKey:@"UserID"]];
//    
//    NSLog(@"%@",insertSQL);
//    
//    
//    BOOL succ=[db executeUpdate:insertSQL];
//    
//    if (succ==YES) {
//        NSLog(@"Succseed");
//    }
//    
//    else
//    {
//        NSLog(@"Fail");
//    }
//    
//    
//    [db close];
//}
//
@end
