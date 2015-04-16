//
//  RadioStation.h
//  Radio
//
//  Created by Diaoshu on 15-1-31.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "DDBasicModel.h"

extern NSString * const kIconImageDidLoadNotification;

@interface RadioStation : DDBasicModel

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *streamURL;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, strong) NSImage *icon;

+ (void)getStationList:(id)params
               showHUD:(BOOL)show
           parentClass:(id)pClass
               success:(DDBasicSuccessBlock)success
               failure:(DDBasicFailureBlock)failure;

@end
