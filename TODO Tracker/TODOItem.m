//
//  TODOItem.m
//  TODO Tracker
//
//  Created by Student on 12/2/14.
//  Copyright (c) 2014 Thomas Bentley. All rights reserved.
//

#import "TODOItem.h"

@implementation TODOItem

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.dueDate forKey:@"date"];
    [encoder encodeObject:self.notes forKey:@"notes"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.title = [decoder decodeObjectForKey:@"title"];
        self.dueDate = [decoder decodeObjectForKey:@"date"];
        self.notes = [decoder decodeObjectForKey:@"notes"];
    }
    return self;
}

@end
