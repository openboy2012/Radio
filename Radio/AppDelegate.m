//
//  AppDelegate.m
//  Radio
//
//  Created by Diaoshu on 15-1-30.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "AppDelegate.h"
#import "RadioStation.h"
#import "AudioStreamer.h"
#import "AFNetworking.h"

@interface AppDelegate ()<NSTableViewDataSource,NSTableViewDelegate>{
    NSMutableArray *stationList;
}

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, strong) AudioStreamer *streamer;
@property (nonatomic, strong) IBOutlet NSTableView *tableView;
@property (nonatomic, strong) IBOutlet NSArrayController *stationArrayController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    if(!stationList)
        stationList = [[NSMutableArray alloc] initWithCapacity:0];
    [stationList removeAllObjects];
    
    NSDictionary *params = @{@"q":@"admin/station/station/bygroupid",
                             @"id":@(10)};
    [RadioStation getStationList:params
                         showHUD:NO
                     parentClass:nil
                         success:^(id data) {
                             NSArray *list = data;
                             [stationList addObjectsFromArray:list];
                             [self.stationArrayController addObjects:list];
                             [self audioStart:list[0]];
                             [self.tableView reloadData];
                         }
                         failure:^(NSError *error, NSDictionary *info) {
                         }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kIconImageDidLoadNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        [self.tableView reloadData];
    }];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)audioStart:(RadioStation *)station{
    if(self.streamer){
        [self.streamer stop];
        self.streamer = nil;
    }
    NSLog(@"streamURL = %@",station.streamURL);
    self.streamer = [[AudioStreamer alloc] initWithURL:[NSURL URLWithString:station.streamURL]];
    [self.streamer start];
}

#pragma mark - NSTableView DataSource Methods

//- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
//    return stationList.count;
//}

//- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
//    NSString *key = [tableColumn identifier];
//    RadioStation *s = [stationList objectAtIndex:row];
//    return [s valueForKey:key];
//}
//
//- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
//    if(!cell)
//        cell = [[NSImageCell alloc] init];
//    NSImageView *imageV = [[NSImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
//    imageV.image = [stationList[row] icon];
//    [cell addSubview:imageV];
//}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    [self audioStart:stationList[row]];
    return YES;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{

}

@end
