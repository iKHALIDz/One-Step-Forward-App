//
//  UserProfileViewControllerDetailsViewController.m
//  Step+
//
//  Created by KHALID ALAHMARI on 4/8/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "UserProfileViewControllerDetailsViewController.h"

@interface UserProfileViewControllerDetailsViewController ()

@end

@implementation UserProfileViewControllerDetailsViewController

@synthesize radialView;
@synthesize cgoal;
@synthesize currentUser;
@synthesize progressListTable=_progressListTable;
@synthesize progressListFromParse;

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
    
    NSLog(@"T: %d",cgoal.goalID);
    
    self.goalName.text=cgoal.goalName;
    self.goalDescription.text=cgoal.goalDescription;
    self.stepTaken.text=[NSString stringWithFormat:@"%d Steps Taken",cgoal.numberOfGoalSteps];
    
    CGRect frame = CGRectMake(0,-10, 100, 100);
    
    radialView = [self progressViewWithFrame:frame];
    radialView.progressTotal = 100;
    radialView.progressCounter = cgoal.goalProgress;
    
    radialView.theme.completedColor=[UIColor blueColor];
    radialView.theme.incompletedColor=[UIColor colorWithHexString:@"8795b1"];
    radialView.theme.thickness=10;
    radialView.theme.sliceDividerHidden = NO;
    radialView.startingSlice = 3;
    radialView.theme.sliceDividerThickness = 0;
    
    radialView.label.textColor = [UIColor blueColor];
    radialView.label.shadowColor = [UIColor clearColor];
    
    radialView.label.pointSizeToWidthFactor=0.3;
    
    [self.ProgressPercentage addSubview:radialView];

    
    progressListFromParse=[[NSMutableArray alloc]init];
    
    progressListFromParse=[self getProgressFromParse];
    
    self.title=@"Goal Details";
    
    self.doneOutlet.enabled=NO;
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


- (MDRadialProgressView *)progressViewWithFrame:(CGRect)frame
{
	MDRadialProgressView *view = [[MDRadialProgressView alloc] initWithFrame:frame];
    
	view.center = CGPointMake(30,22);
    
	return view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)send:(UIButton *)sender {
    
    NSLog(@"Goal%@",cgoal.createdBy);
    NSLog(@"Goal%@",currentUser.userUsername);
    NSLog(@"Goal%d",cgoal.goalID);
    
    PFObject *newGoalSuggestion= [PFObject objectWithClassName:@"GoalSuggestion"];
    
    [newGoalSuggestion setObject: cgoal.createdBy forKey:@"To"];
    
    [newGoalSuggestion setObject: currentUser.userUsername  forKey:@"From"];
    
    [newGoalSuggestion setObject: [NSString stringWithFormat:@"%d",cgoal.goalID ] forKey:@"GoalID"];
    
    [newGoalSuggestion setObject: self.suggestionTextField.text forKey:@"SuggestionText"];
    
    
    NSData *pictureData = UIImagePNGRepresentation(currentUser.userProfileImage);
    PFFile *file = [PFFile fileWithName:@"img" data:pictureData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        [newGoalSuggestion setObject:file forKey:@"FromuserProfilePic"];
        [newGoalSuggestion saveEventually];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return progressListFromParse.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


-(NSMutableArray *) getProgressFromParse
{
    NSMutableArray *list=[[NSMutableArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Progress"];
    
    [query whereKey:@"createdBy" equalTo:cgoal.createdBy];
    
    [query whereKey:@"goalID" equalTo:[NSString stringWithFormat:@"%d",cgoal.goalID]];
    
    [query orderByAscending:@"LogDate"];
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"progressCell";
    
    ProgressTableViewCell *cell = (ProgressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"progressTableViewCell" owner:self options:nil];
    
    cell = [nib objectAtIndex:0];
    
    [cell.progressName setText:(NSString *)[[progressListFromParse objectAtIndex:indexPath.row] progressDescription]];
    
    [cell.progressPercentage setText:[NSString stringWithFormat:@"%.2f",[[progressListFromParse objectAtIndex:indexPath.row] progressPercentageToGoal]]];
    
    [cell.cellStepOrder setText:[NSString stringWithFormat:@"Step: %d",[[progressListFromParse objectAtIndex:indexPath.row] stepOrder]]];
    
    
    
    cell.ProgressDate.text=[self GetTimeinWords:[[progressListFromParse objectAtIndex:indexPath.row] progressDate]];
    
    
    cell.numberOfComments.text=[NSString stringWithFormat:@"%d",[[progressListFromParse objectAtIndex:indexPath.row] numberOfCommentss]];
    
    cell.nLikes.text=[NSString stringWithFormat:@"%d",[[progressListFromParse objectAtIndex:indexPath.row] numberOfLikes]];
    
    
//    [cell.comments addTarget:self action:@selector(GotoComments:)  forControlEvents:UIControlEventTouchUpInside];
//    
//    [cell.comments setTag:indexPath.row];
//    
//    
//    [cell.likes addTarget:self action:@selector(GotoLikes:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.likes setTag:indexPath.row];
//    
//    
//    [cell.deleteProgress addTarget:self action:@selector(deleteProgressSel:)  forControlEvents:UIControlEventTouchUpInside];
//    
//    [cell.deleteProgress setTag:indexPath.row];
    
    cell.deleteProgress.hidden=YES;
    cell.comments.hidden=NO;
    cell.likes.hidden=NO;
    
    
    return cell;
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

- (void)touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (! [self isFirstResponder])
    {
        if ([self.suggestionTextField isFirstResponder])
        {
            [self.suggestionTextField resignFirstResponder];
            [self keyboardWillHide];

            [self setViewMovedUp:NO];
        }
    }
}

#define kOFFSET_FOR_KEYBOARD 200

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}






- (IBAction)BackISPressedisPre:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(IBAction)editingChanged
{
    // make sure all fields are have something in them
    
    if (self.suggestionTextField.text.length > 0)
    {
        self.doneOutlet.enabled=YES;
    }
    else
    {
        self.doneOutlet.enabled=NO;
    }
}


- (IBAction)dissmissKeyboard:(id)sender {
    
    //[self keyboardWillHide];
    
    //[self setViewMovedUp:NO];
    
    [self.suggestionTextField resignFirstResponder];

}


@end
