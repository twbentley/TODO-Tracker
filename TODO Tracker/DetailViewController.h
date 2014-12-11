//
//  DetailViewController.h
//  TODO Tracker
//
//  Created by Student on 12/2/14.
//  Copyright (c) 2014 Thomas Bentley. All rights reserved.
//

#import <UIKit/UIKit.h>
@import EventKit;
@import QuartzCore;

#import "TODOItem.h"	
#import "MasterViewController.h"

@interface DetailViewController : UIViewController<UITextFieldDelegate, UITableViewDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleItem;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker* datePicker;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UITextView *noteView;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;

@property (weak, nonatomic) UITextField* titleText;

@end

