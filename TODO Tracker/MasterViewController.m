//
//  MasterViewController.m
//  TODO Tracker
//
//  Created by Student on 12/2/14.
//  Copyright (c) 2014 Thomas Bentley. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // Subscribe to AppResignActiveNotification event
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleResignActiveNotification:) name:@"AppResignActiveNotification" object:nil];
    
    // Check user data
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    for (int i = 0; i < 1; i++)
    {
         NSData *encodedObject = [defaults objectForKey:[NSString stringWithFormat:@"%d", i]];
        //id object = [defaults objectForKey:[NSString stringWithFormat:@"%d", i]];
        id object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        [self.objects insertObject:object atIndex:i];
    }
}

- (void)handleResignActiveNotification:(NSNotification *)notification
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    // Save all objects to user defaults (object:"indexNumber")
    for(int i = 0; i < self.objects.count; i++)
    {
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.objects[i]];

        [defaults setValue:encodedObject forKey:[NSString stringWithFormat: @"%d", i]];
    }
    [defaults synchronize];
    
    NSData *encodedObject = [defaults valueForKey:[NSString stringWithFormat:@"%d", 0]];
    id object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    NSLog(@"%@", object);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!self.objects)
    {
        self.objects = [[NSMutableArray alloc] init];
    }
    
    // Make a new TODO item with default values and add to display list
    TODOItem* item = [[TODOItem alloc] init];
    item.title = [[NSString alloc] initWithFormat:@"Item %lu", self.objects.count + 1];
    item.dueDate = [NSDate date];
    [self.objects insertObject: item atIndex:0];
    
     
    //[self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //((TODOItem*)self.detailViewController.detailItem).dueDate = self.detailViewController.datePicker.date;
    //NSLog(@"%@", self.detailViewController.detailItem);
   // [self.objects[indexPath.row] setTitle:[self.detailViewController.detailItem title]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Enable re-order control in edit mode
    cell.showsReorderControl = YES;

    NSDate *object = self.objects[indexPath.row];
    
    // The text for the item cell should be the item's title
    cell.textLabel.text = [(TODOItem*)object title];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"moveRowAtIndexPath: %lu", toIndexPath.row );
}

@end
