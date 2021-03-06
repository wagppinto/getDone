//
//  Task.m
//  getDone
//
//  Created by Wagner Pinto on 3/27/15.
//  Copyright (c) 2015 weeblu.co LLC. All rights reserved.
//

#import "Task.h"

static NSString * const TaskClassName = @"Task";

@implementation Task

@dynamic taskName;
@dynamic taskDescription;
@dynamic taskLocation;
@dynamic taskOwner;
@dynamic taskAssignee;
@dynamic taskDueDate;
@dynamic taskImportant;
@dynamic Status;
@dynamic taskRecurring;
@dynamic taskAddress;

+ (NSString *)parseClassName {
    return TaskClassName;
}

+ (void)load {
    [self registerSubclass];
}

@end
