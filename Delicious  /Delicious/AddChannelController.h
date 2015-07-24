//
//  AddChannelController.h
//  Delicious
//
//  Created by Vinh Nguyen on 7/9/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import <CoreData/CoreData.h>

@interface AddChannelController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *addChannelTable;

@property (strong,nonatomic) NSMutableArray *idChannel;

@property (strong,nonatomic) NSArray *arrAddChannel;

@property (strong) NSManagedObject *channel;

- (IBAction)saveChannel:(id)sender;

@end
