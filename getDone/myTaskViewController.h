//
//  FirstViewController.h
//  getDone
//
//  Created by Wagner Pinto on 3/25/15.
//  Copyright (c) 2015 weeblu.co LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "TaskCustomTableViewCell.h"

@interface myTaskViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;



@end
