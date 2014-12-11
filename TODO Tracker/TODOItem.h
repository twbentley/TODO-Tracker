//
//  TODOItem.h
//  TODO Tracker
//
//  Created by Student on 12/2/14.
//  Copyright (c) 2014 Thomas Bentley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TODOItem : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic) NSDate* dueDate;
@property (nonatomic, copy) NSString* notes;

@end
