//
//  DetailViewController.h
//  TODO Tracker
//
//  Created by Student on 12/2/14.
//  Copyright (c) 2014 Thomas Bentley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TODOItem.h"	
#import "MasterViewController.h"

@interface DetailViewController : UIViewController<UITextFieldDelegate
>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleItem;
@property (weak, nonatomic) UITextField* titleText;
@property (weak, nonatomic) IBOutlet UIDatePicker* datePicker;

@end

