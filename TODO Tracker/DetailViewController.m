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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dateChanged:(id)sender
{
    // Update the date in the model
    ((TODOItem*)self.detailItem).dueDate = self.datePicker.date;
}

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

@end
