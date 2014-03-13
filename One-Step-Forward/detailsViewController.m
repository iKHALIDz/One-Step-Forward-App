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
@synthesize currentGoalID;
@synthesize postArray;
@synthesize currentGoalProgressPercentage;
@synthesize tableView = _tableView;
@synthesize doneProgress;
@synthesize array;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)deleteProgress:(UIButton *)sender
{
    
    /*
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Progress"];
    
    // Follow relationship
    [postQuery whereKey:@"goalID" equalTo:currentGoalID];
    [postQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!error) {
            
            NSString *selectedProgress=[object objectForKey:@"ProgressPercentage"];
            
            [object delete];

         
                self.currentGoalProgressPercentage=self.currentGoalProgressPercentage-[selectedProgress doubleValue];
                [self updateGoalAfterDeleteingAProgress:[selectedProgress doubleValue]];

        }
    }];
    
    
    [self.tableView reloadData];
*/
    
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
    
    
    Goal *goal=[[Goal alloc]init];
    
    goal.goalID=[currentGoalID integerValue];

    [goal DeleteGoalFromDatabase];
    
    
/*
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Goal"];
    
    [postQuery whereKey:@"goalID" equalTo:currentGoalID];
    [postQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
    if (!error) {
        
        [object deleteInBackground];
        
        if(!error)
         {
             
            
             PFQuery *postQuery = [PFQuery queryWithClassName:@"Progress"];
             
             // Follow relationship
             [postQuery whereKey:@"goalID" equalTo:currentGoalID];
             
             [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                 if (!error) {
                     
                     
                     for(PFObject *obj in objects)
                     {
                         
                         [obj deleteInBackground];
                     }
                 }}];
             
             
         }
    }}];
    
 */
    
    
}


-(void) viewWillAppear:(BOOL)animated
{
//    [self.tableView reloadData];
//    
//    [self getDoneProgress:nil];
    
    self.currentGoalProgressPercentage=currentGoalProgressPercentage;
    array=[self getProgressList];
    [self.tableView reloadData];
    
    
    self.CurrentGoalProgressLabel.text=[[NSString stringWithFormat:@"%.2f",currentGoalProgressPercentage] stringByAppendingString:@"%"];
 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSString*)DataFilePath{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //NSLog(@"%@",[paths objectAtIndex:0]);
    
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
    
    NSString *qr=[NSString stringWithFormat:@"select * from Progress where goalId='%ld';",(long)[currentGoalID integerValue]];
    
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
    // Return the number of rows in the section.
    
    return [array count];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    array=[[NSMutableArray alloc]init];
    array=[self getProgressList];

    
    //    PFQuery *postQuery = [PFQuery queryWithClassName:@"Progress"];
    //
    //    [postQuery whereKey:@"goalID" equalTo:currentGoalID];
    //    [postQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    //
    //        if (!error) {
    //
    //
    //           //self.label.text=[object objectForKey:@"ProgressName"];
    //
    //        }
    //    }];
    
    NSLog(@"Progress: %f",currentGoalProgressPercentage);
    self.CurrentGoalProgressLabel.text=[[NSString stringWithFormat:@"%.2f",currentGoalProgressPercentage] stringByAppendingString:@"%"];

    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction) declareAchieved:(UIButton *)sender
{
//    
//    PFQuery *postQuery = [PFQuery queryWithClassName:@"Goal"];
//    
//    [postQuery whereKey:@"goalID" equalTo:currentGoalID];
//    
//    [postQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        
//        if (!error) {
//            
//            [object setObject:@YES forKey:@"isGoalCompleted"];
//            [object setObject:@NO forKey:@"isGoalinPregress"];
//            [object setObject:@"100" forKey:@"goalPercentage"];
//            [object saveInBackground];
//        }
//    }];
//    
//    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Congrats!"
//                                                      message:@"You did Achive your goal"
//                                                     delegate:nil
//                                            cancelButtonTitle:@"OK"
//                                            otherButtonTitles:nil];
//    
//
//    [message show];
//    
    
    
    //[self declareAchieved];
    
    
    Goal *goal=[[Goal alloc]init];
    goal.goalID=[self.currentGoalID integerValue];
    
    [goal declareGoalAsAchieved];
    
    
}



//-(NSString*)DataFilePath{
//    
//    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    NSLog(@"%@",[paths objectAtIndex:0]);
//    
//    return [paths objectAtIndex:0];
//}


//UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Congrats!"
//                                                  message:@"You did Achive your goal"
//                                                 delegate:nil
//                                        cancelButtonTitle:@"OK"
//                                        otherButtonTitles:nil];
//
//
//[message show];






//- (IBAction)addProgress:(UIButton *)sender {
//
//
//
//    PFObject *newProgress = [PFObject objectWithClassName:@"Progress"];
//
//    int m=[self checkTheEnteredProgress];
//
//    if(m==1)
//    {
//
//        [newProgress setObject:self.progressTextField.text forKey:@"ProgressName"];
//        [newProgress setObject:self.progressPercentage.text forKey:@"ProgressPercentage"];
//        
//        //Realationship
//        [newProgress setObject:currentGoalID forKey:@"goalID"];
//        
//        NSLog(@"Less Than 100");
//        
//        
//        NSError *error;
//        
//        [newProgress save:&error];
//        
//        {
//            if (!error) {
//                
//                
//                [self updateGoal:[self.progressPercentage.text doubleValue]];
//                
//            }}
//        
//    }
//    
//    
//    else if (m==0)
//    {
//        [newProgress setObject:self.progressTextField.text forKey:@"ProgressName"];
//        [newProgress setObject:self.progressPercentage.text forKey:@"ProgressPercentage"];
//        
//        //Realationship
//        [newProgress setObject:currentGoalID forKey:@"goalID"];
//        
//        NSLog(@"Less Than 100");
//        
//        
//        NSError *error;
//        
//        [newProgress save:&error];
//        
//        [self declareAchieved:sender];
//        
//    }
//    
//    else if (m==-1)
//    {
//        
//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Errot!"
//                                                          message:[NSString stringWithFormat:@"The current progress for the selected goal is %.2f",currentGoalProgressPercentage]
//                                                         delegate:nil
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles:nil];
//        
//        
//        [message show];
//        
//        
//        
//    }
//    
//    else if (m==-2 || m==-3)
//    {
//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error!"
//                                                          message:@"Invalid Input"
//                                                         delegate:nil
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles:nil];
//        
//        
//        [message show];
//
//     
//    }
//}
//
//-(int) checkTheEnteredProgress
//{
//    NSLog(@"currentGoalProgressPercentage %f",self.currentGoalProgressPercentage);
//    NSLog(@"entred progressPercentage %f",[self.progressPercentage.text doubleValue]);
//
//    int X=-1;
//    
//    if ([self.progressPercentage.text isEqual:@""])
//    {
//    
//        X=-3;
//        
//    }
//    
//    else if (currentGoalProgressPercentage+[self.progressPercentage.text doubleValue] < 100) {
//        
//        X=1;
//        
//    }
//    else if (currentGoalProgressPercentage+[self.progressPercentage.text doubleValue] == 100)
//    {
//        X=0;
//    }
//    
//    else if ([self.progressPercentage.text doubleValue] > 100)
//    {
//        X=-2;
//        
//    }
//    
//    
//    NSLog(@"x= %d",X);
//    
//    return X;
//    
//}

//-(void) updateGoal :(double) progressPercentge
//{
//    PFQuery *postQuery = [PFQuery queryWithClassName:@"Goal"];
//    
//    [postQuery whereKey:@"goalID" equalTo:currentGoalID];
//    NSError *error;
//    
//    PFObject *object=[postQuery getFirstObject:&error ];
//    
//    if (!error) {
//        
//        NSLog(@"RRR");
//        NSString *sum=[NSString stringWithFormat:@"%.2f",progressPercentge+currentGoalProgressPercentage];
//        
//        NSLog(@"rr%@",sum);
//        [object setObject:sum forKey:@"goalPercentage"];
//        
//        [object save];
//        
//    }
//    
//}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell2";
    progressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    PFObject *progress = [doneProgress objectAtIndex:indexPath.row];
//    [cell.progressName setText: [progress objectForKey:@"ProgressName"]];
//    [cell.progressPercentage setText: [progress objectForKey:@"ProgressPercentage"]];
//
    [cell.progressName setText:(NSString *)[[array objectAtIndex:indexPath.row] progressDescription]];
    
    [cell.progressPercentage setText:[NSString stringWithFormat:@"%.2f",[[array objectAtIndex:indexPath.row] progressPercentageToGoal]]];

    return cell;
}



/*
- (void)getDoneProgress:(id)sender {
    // Create a query
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Progress"];
    postQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    // Follow relationship
    [postQuery whereKey:@"goalID" equalTo:currentGoalID];
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            doneProgress = objects;           // Store results
            [self.tableView reloadData];   // Reload table
            
        }
    }];
    
}
*/


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AddProgress"])
    {
        UINavigationController *nav = [segue destinationViewController];
        
        AddProgressViewController *vc =(AddProgressViewController*)nav.topViewController;

        [vc setCurrentGoalID:self.currentGoalID];
        [vc setCurrentGoalProgressPercentage:self.currentGoalProgressPercentage];
        [vc setDelegate:self];
        
    }
    
    else  if ([[segue identifier] isEqualToString:@"mangeProgress"])
    {
        UINavigationController *nav = [segue destinationViewController];
        
        MangeProgressViewController *vc =(MangeProgressViewController*)nav.topViewController;
        
//        [vc setCurrentProgressID:self.currentProgressID];
//        [vc setCurrentProgress:self.currentProgress];

        [vc setCurrentProgress:currentProgress];
        [vc setCurrentGoalProgressPercentage:currentGoalProgressPercentage];
        
        [vc setDelegate:self];

        
        //[vc setCurrentGoalProgressPercentage:self.currentGoalProgressPercentage];
    }
}


-(void) setGoalPercentage:(double)goalPerc
{
    self.currentGoalProgressPercentage=goalPerc;
}

-(void) setGoalPercentage2:(double)goalPerc
{
    self.currentGoalProgressPercentage=goalPerc;
}




/*
-(void) updateGoalAfterDeleteingAProgress :(double) progressPercentge
{
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Goal"];
    
    [postQuery whereKey:@"goalID" equalTo:currentGoalID];
    NSError *error;
    
    PFObject *object=[postQuery getFirstObject:&error ];
    
    if (!error) {
        
        NSLog(@"RRR");
        NSString *sum=[NSString stringWithFormat:@"%.2f",currentGoalProgressPercentage];
        
        [object setObject:sum forKey:@"goalPercentage"];
        
        [object save];
        
    }
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    progressTableViewCell *cell = (progressTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.deleteButton.hidden=NO;
//    [cell.progressName setText:(NSString *)[[array objectAtIndex:indexPath.row] progressDescription]];
//    
//    [cell.progressPercentage setText:[NSString stringWithFormat:@"%.2f",[[array objectAtIndex:indexPath.row] progressPercentageToGoal]]];
    
    
    
    
    currentProgress=[[Progress alloc]init];
    
    currentProgress.progressID = [[array objectAtIndex:indexPath.row] progressID];
    
    currentProgress.progressPercentageToGoal =[[array objectAtIndex:indexPath.row] progressPercentageToGoal];
    currentProgress.goalID=[currentGoalID integerValue];
    

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    progressTableViewCell *cell = (progressTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.deleteButton.hidden=YES;
//    [cell.progressName setText:(NSString *)[[array objectAtIndex:indexPath.row] progressDescription]];
//    
//    [cell.progressPercentage setText:[NSString stringWithFormat:@"%.2f",[[array objectAtIndex:indexPath.row] progressPercentageToGoal]]];
    
    
}


- (MDRadialProgressView *)progressViewWithFrame:(CGRect)frame
{
	MDRadialProgressView *view = [[MDRadialProgressView alloc] initWithFrame:frame];
    
	// Only required in this demo to align vertically the progress views.
	view.center = CGPointMake(self.view.center.x + 80, view.center.y);
	
	return view;
}

- (UILabel *)labelAtY:(CGFloat)y andText:(NSString *)text
{
	CGRect frame = CGRectMake(5, y, 180, 50);
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.text = text;
	label.numberOfLines = 0;
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [label.font fontWithSize:14];
    
	return label;
}

@end
