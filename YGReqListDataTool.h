//
//  YGReqListDataTool.h
//  DailyYoga
//
//  Created by houhui on 2018/6/8.
//  Copyright © 2018年 Daily Yoga. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^YGDataParserBlock)(NSDictionary *data);

@interface YGReqListDataTool : NSObject

+ (instancetype)createReqToolWithInterface:(NSString *)interface
                                    params:(NSDictionary *)params;

/** 刷新数据 */
- (void)refreshData;

/** 加载更多数据 */
- (void)loadMoreData;

/** 开始请求回调 */
@property (nonatomic, copy) dispatch_block_t beginRequestBlock;

/** 结束请求回调 */
@property (nonatomic, copy) dispatch_block_t endRequestBlock;

/** 数据解析回调 */
@property (nonatomic, copy) YGDataParserBlock dataParseBlock;

/** 刷新回调 */
@property (nonatomic, copy) dispatch_block_t refreshBlock;

/** 网络错误回调 */
@property (nonatomic, copy) dispatch_block_t netWorkErrorBlock;

/** 没有更多数据回调*/
@property (nonatomic, copy) dispatch_block_t noMoreDataBlock;

/** 所有数据 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
