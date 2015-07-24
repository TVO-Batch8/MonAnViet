//
//  AddChannelController.m
//  Delicious
//
//  Created by Vinh Nguyen on 7/9/15.
//  Copyright (c) 2015 TinhVan. All rights reserved.
//

#import "AddChannelController.h"

static NSString *cellChannelID=@"cellChannelID";

@interface AddChannelController ()
@end

@implementation AddChannelController

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.addChannelTable registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:cellChannelID];
    self.navigationController.navigationBar.barStyle = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.addChannelTable.backgroundColor = [UIColor grayColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleNetworkStatusNotification" object:nil];
    [self.addChannelTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Datasource tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.idChannel.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomCell *cell= [tableView dequeueReusableCellWithIdentifier:cellChannelID];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellChannelID];
    }
    cell.channelTitle.text = [NSString stringWithFormat:@"%@",[[self.arrAddChannel objectAtIndex:2]objectAtIndex:indexPath.row]];
    cell.channelID.text = [NSString stringWithFormat:@"%@",[[self.arrAddChannel objectAtIndex:3]objectAtIndex:indexPath.row]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.arrAddChannel objectAtIndex:1]objectAtIndex:indexPath.row]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.channelImage.image = [UIImage imageWithData:imageData];
            
        });
    });
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (IBAction)saveChannel:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSManagedObject *newChannel = [NSEntityDescription insertNewObjectForEntityForName:@"Channel" inManagedObjectContext:context];
    
    [newChannel setValue:[[self.arrAddChannel objectAtIndex:2] objectAtIndex:[self.addChannelTable indexPathForSelectedRow].row] forKey:@"titleChannel"];
    [newChannel setValue:[[self.arrAddChannel objectAtIndex:1] objectAtIndex:[self.addChannelTable indexPathForSelectedRow].row] forKey:@"thumbnailChannel"];
    
    NSString *dateString =  [[self.arrAddChannel objectAtIndex:3] objectAtIndex:[self.addChannelTable indexPathForSelectedRow].row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSLog(@"%@",date);
    
    [newChannel setValue:date forKey:@"timeChannel"];
    
    [newChannel setValue:[[self.arrAddChannel objectAtIndex:0] objectAtIndex:[self.addChannelTable indexPathForSelectedRow].row] forKey:@"idChannel"];
    
    NSLog(@"%ld",(long)[self.addChannelTable indexPathForSelectedRow].row);
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    NSLog(@"Save successful");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
