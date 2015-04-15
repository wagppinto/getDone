//
//  Status.m
//  getDone
//
//  Created by Wagner Pinto on 4/8/15.
//  Copyright (c) 2015 weeblu.co LLC. All rights reserved.
//

#import "Status.h"

static NSString * const StatusClassName = @"TaskStatus";

@implementation Status


@dynamic StatusName;

+ (NSString *)parseClassName {
    return StatusClassName ;
}

+ (void)load {
    [self registerSubclass];
}


@end
