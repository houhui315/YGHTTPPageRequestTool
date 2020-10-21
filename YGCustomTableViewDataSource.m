//
//  YGCustomTableViewDataSource.m
//  DailyYoga
//
//  Created by houhui on 2018/6/8.
//  Copyright © 2018年 Daily Yoga. All rights reserved.
//

#import "YGCustomTableViewDataSource.h"

@interface YGCustomTableViewDataSource ()

@property (nonatomic, assign) BOOL singleSection;

@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, copy) YGCustomTableViewDataSourceCellConfigBlock configureCellBlock;

@end

@implementation YGCustomTableViewDataSource

- (instancetype)initWithItems:(NSArray *)anItems
               cellIdentifier:(NSString *)aCellIdentifier
                singleSection:(BOOL)singleSection
           configureCellBlock:(YGCustomTableViewDataSourceCellConfigBlock)aConfigureCellBlock {
    
    if (self = [super init]) {
        self.items = anItems;
        self.cellIdentifier = aCellIdentifier;
        self.singleSection = singleSection;
        self.configureCellBlock = aConfigureCellBlock;
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.singleSection) {
        return self.items[indexPath.row];
    }else{
        return self.items[indexPath.section];
    }
}

- (void)updateDataWithArray:(NSArray *)dataAry {
    
    self.items = dataAry;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.singleSection?1:self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.singleSection?self.items.count:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    return cell;
}


@end
