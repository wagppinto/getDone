//
//  CreateTaskViewController.m
//  getDone
//
//  Created by Wagner Pinto on 3/31/15.
//  Copyright (c) 2015 weeblu.co LLC. All rights reserved.
//

#import "CreateTaskViewController.h"
#import "TaskController.h"
#import "FindFriendViewController.h"
#import "Constants.h"
#import "NSDate+CombiningDates.h"

@interface CreateTaskViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, FindFriendsDelegate>

@property (weak, nonatomic) IBOutlet UITextField *taskNameField;
@property (weak, nonatomic) IBOutlet UITextField *taskDescriptionField;
@property (weak, nonatomic) IBOutlet UITextField *taskAddressField;
@property (weak, nonatomic) IBOutlet UITextField *dueDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *dueTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *assignedLabel;

@property (nonatomic) NSDate *DueDate;

@property (weak, nonatomic) IBOutlet UISwitch *importantButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *dateSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *hourSegment;

@property (strong, nonatomic) NSDate *dayDate;
@property (strong, nonatomic) NSDateComponents *timeDate;
@property (nonatomic,strong) NSString *status;

@end

@implementation CreateTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViewController];
    [self setupTaskStatus];

    //DELEGATES
    self.taskNameField.delegate = self;
    self.taskDescriptionField.delegate = self;

    //INSTANCES
    self.timeDate = [[NSDateComponents alloc] init];
    self.dayDate = [NSDate date];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [self setupTaskStatus];
}
- (void)setupViewController {
    
    //set the dates:
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *today = [NSDate date];
    [dateFormat setDateFormat:@"E-MM/dd"];
    
    NSString *todayString = [dateFormat stringFromDate:today];
    self.dueDateLabel.text = todayString;
    self.dueTimeLabel.text = @"9:00 am";
    
}
- (void)setupTaskStatus {
    //set the status labels
    if ([self.status isEqual:StatusCreated] || self.status == nil) {
        self.assignedLabel.text = @"Not Assinged";
        self.assignedLabel.tintColor = [UIColor grayColor];
        self.shareButton.backgroundColor = [UIColor blueColor];
        [self.shareButton setTitle: @"FIND FRIEND" forState: UIControlStateNormal];
    }else {
        self.assignedLabel.text = self.assignedUser[@"userFullName"];
        self.assignedLabel.textColor = [UIColor redColor];
        self.shareButton.backgroundColor = [UIColor redColor];
        [self.shareButton setTitle: @"SHARED" forState: UIControlStateNormal];
    }

}
- (IBAction)SaveTask:(id)sender {
    NSDate *combinedDate = [NSDate dateByCombiningDay:self.dayDate time:[[NSCalendar currentCalendar] dateFromComponents:self.timeDate]];
    
    //set the status
    if (self.assignedUser == nil) {
        self.status = StatusCreated;
    }else {
        self.status = StatusAssigned;
    }
    
    //set important state:
    BOOL importantValue;
    
    if ([self.importantButton isOn]) {
        importantValue = YES;
    }else {
        importantValue = NO;
    }
    
    //save task
    if (![self.taskNameField.text isEqual: @""]) {
        [[TaskController sharedInstance]addTaskWithName:self.taskNameField.text
                                                   Desc:self.taskDescriptionField.text
                                                DueDate:combinedDate
                                                  Owner:[PFUser currentUser]
                                               Assignee:self.assignedUser
                                              Important:importantValue
                                                Current:NO
                                                Address:self.taskAddressField.text
                                                 Status:self.status];
        //create a custom delegate to allow the close button to dismiss the view.
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Task Name" message:@"You need a task name in order to save" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [error show];
    }
    
} //create the task and sabe in backgroun
- (IBAction)Cancel:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
} //dismiss the screen in case of canceling the action

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case 0:
            return 3;
            break;
            
        default:
            return 4;
            break;
    }
}

#pragma mark - SegmentControllers
- (NSDate *)formatDate:(NSInteger)days {
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = days;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    
    return nextDate;
    
}
- (IBAction)dateSegment:(id)sender {
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *today = [NSDate date];
    
    switch (self.dateSegment.selectedSegmentIndex) {
        case 0:{
            [dateFormat setDateFormat:@"E-MM/dd"];
            NSString *todayString = [dateFormat stringFromDate:today];
            self.dayDate = today;
            self.dueDateLabel.text = todayString;
        }
            break;
        case 1:{
            today = [self formatDate:1];
            [dateFormat setDateFormat:@"E-MM/dd"];
            NSString *todayString = [dateFormat stringFromDate:today];
            self.dayDate = [self formatDate:1];
            self.dueDateLabel.text = todayString;
        }
            break;
        case 2:{
            today = [self formatDate:3];
            [dateFormat setDateFormat:@"E-MM/dd"];
            NSString *todayString = [dateFormat stringFromDate:today];
            self.dayDate = [self formatDate:3];
            self.dueDateLabel.text = todayString;
        }
            break;
        default:{
            today = [self formatDate:7];
            [dateFormat setDateFormat:@"E-MM/dd"];
            NSString *todayString = [dateFormat stringFromDate:today];
            self.dayDate = [self formatDate:7];
            self.dueDateLabel.text = todayString;
        }
            break;
    }
}
- (IBAction)timeSegment:(id)sender {

    switch (self.hourSegment.selectedSegmentIndex) {
        case 0:
            self.dueTimeLabel.text = @"9:00 am";
            self.timeDate.hour = 9;
            break;
        case 1:
            self.dueTimeLabel.text = @"12:00 pm";
            self.timeDate.hour = 12;
            break;
        case 2:
            self.dueTimeLabel.text = @"3:00 pm";
            self.timeDate.hour = 15;
            break;
        default:
            self.dueTimeLabel.text = @"6:00 pm";
            self.timeDate.hour = 18;
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"newUserShare"]) {
        FindFriendViewController *friendsVC = [segue destinationViewController];
        friendsVC.delegate = self;
    }
}

# pragma mark - Custom Delegate (Find Friend)
- (void)didSelectFriend:(User *)user {
    if ([user.username isEqualToString:@"NONE"]) {
        self.assignedUser = nil;
        self.status = StatusCreated;
    }else {
        self.assignedUser = user;
        self.status = StatusAssigned;
    }
    [self setupTaskStatus];
}

# pragma mark - TextFieldDelegate:
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}//dismiss the keyboard.

@end
