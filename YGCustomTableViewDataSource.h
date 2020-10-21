//
//  YGCustomTableViewDataSource.h
//  DailyYoga
//
//  Created by houhui on 2018/6/8.
//  Copyright © 2018年 Daily Yoga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^YGCustomTableViewDataSourceCellConfigBlock)(id cell, id model);

@interface YGCustomTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSArray *items;

- (instancetype)initWithItems:(NSArray *)anItems
               cellIdentifier:(NSString *)aCellIdentifier
                singleSection:(BOOL)singleSection
           configureCellBlock:(YGCustomTableViewDataSourceCellConfigBlock)aConfigureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

- (void)updateDataWithArray:(NSArray *)dataAry;

@end
