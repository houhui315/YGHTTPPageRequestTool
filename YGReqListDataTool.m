//
//  YGReqListDataTool.m
//  DailyYoga
//
//  Created by houhui on 2018/6/8.
//  Copyright © 2018年 Daily Yoga. All rights reserved.
//

#import "YGReqListDataTool.h"

@interface YGReqListDataTool () {
    
}

#define RMPageCount 10

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) NSInteger mCurrPage;
@property (nonatomic, strong) NSString *mInterface;
@property (nonatomic, strong) NSDictionary *mParams;

@end

@implementation YGReqListDataTool

+ (instancetype)createReqToolWithInterface:(NSString *)interface
                                    params:(NSDictionary *)params {
    if (interface.length) {
        return [[self alloc] initWithRequestInterface:interface params:params];
    }else{
        NSAssert(interface, @"参数不能为空");
        return nil;
    }
}

-(void)dealloc {
    NSLog(@"YGReqListDataTool dealloc");
}

- (instancetype)init {
    
    NSAssert(NO, @"不能调用该方法初始化");
    return self;
}

- (instancetype)initWithRequestInterface:(NSString *)interface
                                  params:(NSDictionary *)params {
    
    if (self = [super init]) {
        self.mInterface = interface;
        self.mParams = params;
    }
    return self;
}

- (void)refreshData {
    
    self.mCurrPage = 1;
    [self requestForGroupListWithPage:self.mCurrPage];
}

- (void)loadMoreData {
    
    [self requestForGroupListWithPage:self.mCurrPage + 1];
}

- (void)requestForGroupListWithPage:(NSInteger)page {
    
    if (self.isLoading) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.mParams];
    [params setValue:@(page) forKey:@"page"];
    [params setValue:@(RMPageCount) forKey:@"size"];
    
    if (self.beginRequestBlock) {
        self.beginRequestBlock();
    }
    
    self.isLoading = YES;
    
    kWeakSelf(self)
    [RMHTTPInstance requestPOSTWithHttpURLPath:self.mInterface parameters:params complateBlock:^(id data, NSString *msg, NSError *error) {
        kStrongSelf(self)
        self.isLoading = NO;
        if (!self) {
            return;
        }
        if (!error.code) {
            self.mCurrPage = page;
            [self handleRequestData:data];
            if (self.refreshBlock) {
                self.refreshBlock();
            }
        }else{
            [[YGToastCenter defaultCenter] postAlertWithMessage:msg];
            if (self.netWorkErrorBlock) {
                self.netWorkErrorBlock();
            }
        }
        if (self.endRequestBlock) {
            self.endRequestBlock();
        }
    }];
}

- (void)handleRequestData:(id)result {
    
    if (self.mCurrPage == 1) {
        [self.dataArray removeAllObjects];
    }
    if (result) {
        
        NSMutableArray *mArray = [NSMutableArray array];
        if (self.dataParseBlock) {
            mArray = self.dataParseBlock(result);
        }else{
            mArray = [NSMutableArray arrayWithArray:result];
        }
        if (mArray && mArray.count) {
            [self.dataArray addObjectsFromArray:mArray];
        }
        if (mArray.count < RMPageCount) {
            [GCDQueue executeInMainQueue:^{
                if (self.noMoreDataBlock) {
                    self.noMoreDataBlock();
                }
            }];
        }
    }
}

#pragma mark - lazy

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
