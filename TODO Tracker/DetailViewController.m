//
//  DetailViewController.m
//  TODO Tracker
//
//  Created by Student on 12/2/14.
//  Copyright (c) 2014 Thomas Bentley. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)awakeFromNib
{
    // Replace the title navigation item with an editable text box
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 22)];
    self.titleText = textField;
    textField.text = @"Insert Title Here";
    textField.font = [UIFont boldSystemFontOfSize:19];
    textField.textColor = [UIColor blackColor];
    textField.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = textField;
    self.titleText.delegate = self;
}

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem)
    {        
        _detailItem = newDetailItem;

        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem)
    {
        //self.detailDescriptionLabel.text = [self.detailItem description];
        
        // Set the title of the detail view to the name of the currently selected object
        self.titleItem.title = [(TODOItem*)self.detailItem title];
        ((UITextField*)self.navigationItem.titleView).text = [(TODOItem*)self.detailItem title];

        // Set the date picker date to the current item's due date
        self.datePicker.date = [(TODOItem*)self.detailItem dueDate];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    // Add "delegate" method for when the date changes in the date picker
    [self.datePicker addTarget:self action:@selector(dateChanged:)
              forControlEvents:UIControlEventValueChanged];
    
    self.tableView.delegate = self;
    [self.tableView setEditing:YES animated:NO];
    
    // If an item is selected, show the date picker
    if(self.detailItem)
        self.datePicker.alpha = 1.0f;
    else
        self.datePicker.alpha = 0.0f;
     // If an item is selected, show the calendar button
    if(self.detailItem)
        self.calendarButton.alpha = 1.0f;
    else
        self.calendarButton.alpha = 0.0f;
    // If an item is selected, show the label
    if(self.detailItem)
        self.dueDateLabel.alpha = 1.0f;
    else
        self.dueDateLabel.alpha = 0.0f;
    // If an item is selected, show the notes box
    if(self.detailItem)
    {
        self.noteView.alpha = 1.0f;
        self.noteView.layer.borderWidth = 1.0f;
        self.noteView.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    else
        self.noteView.alpha = 0.0f;
    // If an item is selected, show the notes label
    if(self.detailItem)
        self.noteLabel.alpha = 1.0f;
    else
        self.noteLabel.alpha = 0.0f;
    if(self.detailItem)
        self.alarmButton.alpha = 1.0f;
    else
        self.alarmButton.alpha = 0.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Date Picker delegate

- (void)dateChanged:(id)sender
{
    // Update the date in the model
    ((TODOItem*)self.detailItem).dueDate = self.datePicker.date;
}

#pragma mark - Text Field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Close the keyboard
    [textField resignFirstResponder];
    
    // Update title in model and view
    ((TODOItem*)self.detailItem).title = ((UITextField*)self.navigationItem.titleView).text;
    UINavigationController *masterController = [self.splitViewController.viewControllers objectAtIndex:0];
    UITableViewController *tableController = (UITableViewController *)masterController.visibleViewController;
    UITableView *tableView = tableController.tableView;
    [tableView reloadData];
    
    return YES;
}

#pragma mark - Buttons

- (void)animateButton:(UIButton*)button
{
    // Animate alpha on button press
    [UIView beginAnimations:NULL context:NULL];
    [UIView setAnimationDuration:1.0];
    // Animations to be executed
    [button setAlpha:0];
    [button setAlpha:1];
    /* end animations to be executed */
    [UIView commitAnimations]; // execute the animations listed above
}

- (IBAction)addToCalendarButtonClick:(id)sender
{    
    // Animate the pressing of this button
    [self animateButton:(UIButton*)sender];
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    // Bring up alert view to notify user
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Event added: %@", self.titleText.text] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
    [alertView show];
    
    // Give access to calendar
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:
     ^(BOOL granted, NSError *error) {
        if(granted)
        {
            // create/edit your event here
            EKEvent *event = [EKEvent eventWithEventStore:eventStore];
            
            // title of the event
            event.title = self.titleText.text;
            
            // start tomorrow
            //event.startDate= [[NSDate date] dateByAddingTimeInterval:86400];
            event.startDate = self.datePicker.date;
            
            // duration = 1 h
            //event.endDate= [[NSDate date] dateByAddingTimeInterval:90000];
            event.endDate = event.startDate;
            
            // set the calendar of the event. - here default calendar
            [event setCalendar:[eventStore defaultCalendarForNewEvents]];
            
            // store the event
            NSError *err;
             [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        }}];
}

- (IBAction)addToAlarmsButtonClick:(id)sender
{
    // Animate this button
    [self animateButton:(UIButton*)sender];
    
    // Make a new event store
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    // Bring up alert view to notify user
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Reminder added: %@", self.titleText.text] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continue", nil];
    [alertView show];
    
    // Authorize the app for access to reminders
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    if (authorizationStatus == EKAuthorizationStatusNotDetermined || authorizationStatus == EKAuthorizationStatusAuthorized)
    {
    [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:
     ^(BOOL granted, NSError *error) {
         if(granted)
         {
             // Create a new reminder
             EKReminder *reminder = [EKReminder
                            reminderWithEventStore: eventStore];
    
             reminder.title = self.titleText.text;

             reminder.calendar = [eventStore defaultCalendarForNewReminders];
    
             NSDate *date = [self.datePicker date];
    
             EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:date];
    
             [reminder addAlarm:alarm];
    
             NSError *error = nil;
    
             // Save reminder to Reminders
             [eventStore saveReminder:reminder commit:YES error:&error];
             
             if (error)
                 NSLog(@"error = %@", error);
         }
     }];
    }
}



@end
