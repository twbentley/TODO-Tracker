//
//  MasterViewController.h
//  TODO Tracker
//
//  Created by Student on 12/2/14.
//  Copyright (c) 2014 Thomas Bentley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TODOItem.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (nonatomic) NSMutableArray* todoItems;

@end

