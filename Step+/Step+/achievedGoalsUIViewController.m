//
//  achievedGoalsUIViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/27/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "achievedGoalsUIViewController.h"

@interface achievedGoalsUIViewController ()

@end

@implementation achievedGoalsUIViewController

@synthesize currentUser;
@synthesize currentGoal;
@synthesize achievedGoalsArray;
@synthesize achievedGoalsArrayFromParse;
@synthesize tableviw=_tableviw;
@synthesize radialView;

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
    
    PFUser *curreUser = [PFUser currentUser];
    
    currentUser.userUsername=curreUser.username;
    
    currentGoal=[[Goal alloc]init];
    
    achievedGoalsArray=[[NSMutableArray alloc]init];
    achievedGoalsArrayFromParse=[[NSMutableArray alloc]init];
    
    achievedGoalsArray=[self getDoneGoalsFromDB];
    
    
    if ([achievedGoalsArray count]==0)
    {
       // NSLog(@"Parse, We still need to add it to DB");
        achievedGoalsArrayFromParse=[self getDoneGoalsFromParse];
        for (Goal *newgoal in achievedGoalsArrayFromParse)
        {
            [newgoal AddGoaltoDatabase];
        }
    }

}

-(void) viewWillAppear:(BOOL)animated
{
    
    achievedGoalsArray=[self getDoneGoalsFromDB];
    [self.tableviw reloadData];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableBackground.png"]];
//    
//    self.tableviw.backgroundView = imageView;
    
    self.tableviw.separatorColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    
}

- (MDRadialProgressView *)progressViewWithFrame:(CGRect)frame
{
	MDRadialProgressView *view = [[MDRadialProgressView alloc] initWithFrame:frame];
    
	view.center = CGPointMake(35,40);
    
	return view;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return achievedGoalsArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"goalCell";
    
    goalTableViewCell *cell = (goalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"goalTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    [cell.GoalName setText:(NSString *)[[achievedGoalsArray objectAtIndex:indexPath.row] goalName]];
    
    [cell.DueDate setText:[NSString stringWithFormat:@"%d Steps Taken",[[achievedGoalsArray objectAtIndex:indexPath.row] numberOfGoalSteps]]];
    
    
    CGRect frame = CGRectMake(0,0, 60, 60);
    
    radialView = [self progressViewWithFrame:frame];
    radialView.progressTotal = 100;
    radialView.progressCounter = [[achievedGoalsArray objectAtIndex:indexPath.row] goalProgress];
    radialView.theme.completedColor=[UIColor blueColor];
    radialView.theme.incompletedColor=[UIColor colorWithHexString:@"8795b1"];
    radialView.theme.thickness=10;
    radialView.theme.sliceDividerHidden = NO;
    radialView.startingSlice = 3;
    radialView.theme.sliceDividerThickness = 0;
    
    radialView.label.textColor = [UIColor blueColor];
    radialView.label.shadowColor = [UIColor clearColor];
    
    radialView.label.pointSizeToWidthFactor=0.3;

    [cell.contentView addSubview:radialView];
    
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    cell.selectedBackgroundView = myBackView;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    
    [cell.MoveCell addGestureRecognizer:longPress];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GoalCellBackground.png"]];
    
    cell.backgroundView = imageView;


    
    return cell;
}

- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableviw];
    NSIndexPath *indexPath = [self.tableviw indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableviw cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableviw addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    // Black out.
                    cell.backgroundColor = [UIColor blackColor];
                } completion:nil];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath])
            {
                
                int sourceP=[[achievedGoalsArray objectAtIndex:sourceIndexPath.row]goalPriority];
                
                int DestnationP=[[achievedGoalsArray objectAtIndex:indexPath.row]goalPriority];
                
                //NSLog(@"Source: %d",sourceP);
                //NSLog(@"Destination: %d",DestnationP);
                
                
                // ... update data source.
                [self.achievedGoalsArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                
                [[achievedGoalsArray objectAtIndex:sourceIndexPath.row] UpdateGoalPriority:(sourceP)];
                
                
                [[achievedGoalsArray objectAtIndex:indexPath.row] UpdateGoalPriority:(DestnationP)];
                
                
                
                [self.tableviw moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableviw cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                // Undo the black-out effect we did.
                cell.backgroundColor = [UIColor whiteColor];
                
            } completion:^(BOOL finished) {
                
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            sourceIndexPath = nil;
            
            break;
        }
    }
    
}

- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    currentGoal.goalID=[[NSString stringWithFormat:@"%d",[[achievedGoalsArray objectAtIndex:indexPath.row] goalID]] integerValue];
    
    currentGoal.goalName=[NSString stringWithFormat:@"%@",[[achievedGoalsArray objectAtIndex:indexPath.row] goalName]];
    
    currentGoal.goalDescription=[NSString stringWithFormat:@"%@",[[achievedGoalsArray objectAtIndex:indexPath.row] goalDescription]];
    
    currentGoal.goalDeadline=[NSString stringWithFormat:@"%@",[[achievedGoalsArray objectAtIndex:indexPath.row] goalDeadline]];
    
    currentGoal.goalProgress=[[achievedGoalsArray objectAtIndex:indexPath.row] goalProgress];
    
    currentGoal.createdBy=[NSString stringWithFormat:@"%@",[[achievedGoalsArray objectAtIndex:indexPath.row] createdBy]];
    
    currentGoal.goalDate=[NSString stringWithFormat:@"%@",[[achievedGoalsArray objectAtIndex:indexPath.row] goalDate]];
    
    currentGoal.numberOfGoalSteps=[[achievedGoalsArray objectAtIndex:indexPath.row] numberOfGoalSteps];
    currentGoal.isGoalinProgress=[[achievedGoalsArray objectAtIndex:indexPath.row] isGoalinProgress];
    currentGoal.isGoalCompleted=[[achievedGoalsArray objectAtIndex:indexPath.row] isGoalCompleted];
    currentGoal.goalType=[[achievedGoalsArray objectAtIndex:indexPath.row] goalType];
    
    
    [self performSegueWithIdentifier:@"DoneGoalToDetails" sender:nil];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

-(NSMutableArray *) getDoneGoalsFromDB
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    
    BOOL isOpen=[db open];
    
    if (isOpen==NO)
    {
        //NSLog(@"Fail to open");
        
    }
    
    NSString *query=[NSString stringWithFormat:@"select * from Goals where isGoalCompleted='1' AND isGoalinPregress='0' AND CreatedBy='%@'",currentUser.userUsername];
    
    NSString *Finalquery= [query stringByAppendingString:@"ORDER BY goalpriority DESC;"];
    
   // NSLog(@"%@",Finalquery);
    
    FMResultSet *result =[db executeQuery:Finalquery];
    
    
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
        goal.numberOfGoalSteps=[result intForColumn:@"numberofStepTaken"];
        goal.goalDate=[result stringForColumn:@"goalDate"];
        goal.goalType=[result stringForColumn:@"goalType"];
        goal.goalPriority=[result intForColumn:@"goalPriority"];

        [list addObject:goal];
    }
    return list;
}


-(NSMutableArray *) getDoneGoalsFromParse
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Goal"];
    [query whereKey:@"createdBy" equalTo:currentUser.userUsername];
    [query whereKey:@"isGoalCompleted" equalTo:@YES];
    [query whereKey:@"isGoalinProgress" equalTo:@NO];
    
    NSError *error=nil;
    
    NSArray* goals=[query findObjects:&error];
    
    for(PFObject *obj in goals)
    {
        Goal *goal=[[Goal alloc]init];
        goal.goalID= [[obj objectForKey:@"goalID"] integerValue];
        goal.goalName=[obj objectForKey:@"GoalName"];
        goal.goalDescription=[obj objectForKey:@"GoalDesc"];
        goal.goalDeadline=[obj objectForKey:@"GoalDeadline"];
        goal.isGoalCompleted=NO;
        goal.isGoalinProgress=YES;
        goal.goalProgress=[[obj objectForKey:@"goalPercentage"] doubleValue];
        
        goal.createdBy =[obj objectForKey:@"createdBy"];
        
        goal.numberOfGoalSteps=[[obj objectForKey:@"numberOfGoalSteps"] integerValue];
        goal.goalDate=[obj objectForKey:@"goalDate"];
        
        goal.goalType=[obj objectForKey:@"goalType"];
        
        [list addObject:goal];
    }
    
    return list;
    
}


-(NSString*)DataFilePath{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [paths objectAtIndex:0];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"DoneGoalToDetails"])
    {
        goalDetailsViewController *nav = [segue destinationViewController];
        [nav setCurrentGoal:currentGoal];
        [nav setCurrentUser:self.currentUser];
    }
    
    if ([[segue identifier] isEqualToString:@"newGoal"])
    {
        UINavigationController *nav = [segue destinationViewController];
        newGoalViewController *vc =(newGoalViewController*)nav.topViewController;
        [vc setCurrentUser:self.currentUser];
    }

}

- (IBAction)goToProgressList:(UIButton *)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
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


@end
