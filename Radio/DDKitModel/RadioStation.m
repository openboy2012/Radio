//
//  RadioStation.m
//  Radio
//
//  Created by Diaoshu on 15-1-31.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "RadioStation.h"

NSString * const kIconImageDidLoadNotification = @"com.station.icon";

@interface RadioStation()

@property (readwrite, nonatomic, strong) AFHTTPRequestOperation *avatarImageRequestOperation;

@end

@implementation RadioStation

+ (NSString *)jsonNode{
    return @"Item";
}

+ (NSDictionary *)jsonMappings{
    NSDictionary *mappings = @{@"StationID":@"id",
                               @"StationName":@"name",
                               @"StationDescription":@"desc"};
    return mappings;
}

+ (void)getStationList:(id)params showHUD:(BOOL)show parentClass:(id)pClass success:(DDBasicSuccessBlock)success failure:(DDBasicFailureBlock)failure{
    [[self class] get:@"index.php" params:params showHUD:show parentViewController:pClass success:success failure:failure];
}

+ (NSOperationQueue *)sharedProfileImageRequestOperationQueue {
    static NSOperationQueue *_sharedProfileImageRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedProfileImageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_sharedProfileImageRequestOperationQueue setMaxConcurrentOperationCount:8];
    });
    
    return _sharedProfileImageRequestOperationQueue;
}

- (NSImage *)icon {
    if (!_icon && !_avatarImageRequestOperation) {
        NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.picture]];
        [mutableRequest setValue:@"image/*" forHTTPHeaderField:@"Accept"];
        AFHTTPRequestOperation *imageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:mutableRequest];
        imageRequestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [imageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSImage *responseImage) {
            self.icon = responseImage;
            
            _avatarImageRequestOperation = nil;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kIconImageDidLoadNotification object:self userInfo:nil];
        } failure:nil];
        
        [imageRequestOperation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
            return [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:cachedResponse.userInfo storagePolicy:NSURLCacheStorageAllowed];
        }];
        
        _avatarImageRequestOperation = imageRequestOperation;
        
        [[[self class] sharedProfileImageRequestOperationQueue] addOperation:_avatarImageRequestOperation];
    }
    
    return _icon;
}


@end
