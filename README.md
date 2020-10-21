# YGHTTPPageRequestTool
快速实现页面的分页数据请求和展示功能
在ViewController中:

@interface RMRateListVC ()

@property (nonatomic, assign) BOOL needShowHud;

@property (nonatomic, strong) UITableView *mTableView;

@property (nonatomic, strong) YGReqListDataTool *reqTool;

@property (nonatomic, strong) YGCustomTableViewDataSource *dataSource;

@end

- (void)setupData {
    
    self.needShowHud = YES;
    [self.reqTool refreshData];
}

- (void)handleRefreshAction {
    
    [self.dataSource updateDataWithArray:self.reqTool.dataArray];
    [self.mTableView reloadData];
}


#pragma mark -- lazy

- (UITableView *)mTableView {
    
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_mTableView registerClass:[RMBookDetailRateCell class] forCellReuseIdentifier:RMBookDetailRateCellIdentifier];
        _mTableView.separatorInset = UIEdgeInsetsMake(0, 60, 0, 20);
        _mTableView.dataSource = self.dataSource;
        _mTableView.estimatedRowHeight = 10;
        [self.view addSubview:_mTableView];
        _mTableView.tableFooterView = [UIView new];
        kWeakSelf(self)
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            kStrongSelf(self)
            self.needShowHud = NO;
            [self.reqTool loadMoreData];
        }];
        _mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            kStrongSelf(self)
            self.needShowHud = NO;
            [self.reqTool refreshData];
            self.mTableView.mj_footer = footer;
        }];
        _mTableView.mj_footer = footer;
        [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return _mTableView;
}

- (YGReqListDataTool *)reqTool {
    
    if (!_reqTool) {
        _reqTool = [YGReqListDataTool createReqToolWithInterface:URL_comment_index params:@{@"book_id":@(self.bookModel.id)}];
        _reqTool.dataParseBlock = ^id(NSDictionary *data) {
            RMBookRateCommentModel *commentModel = [RMBookRateCommentModel mj_objectWithKeyValues:data];
            return commentModel.comment;
        };
        kWeakSelf(self)
        _reqTool.beginRequestBlock = ^{
            kStrongSelf(self)
            if (self.needShowHud) {
                [MBProgressHUD showActivityMessageInWindow:ksLocalized(@"加载中...")];
            }
        };
        _reqTool.endRequestBlock = ^{
            kStrongSelf(self)
            if (self.needShowHud) {
                [MBProgressHUD hideHUD:nil];
            }
            [self.mTableView.mj_header endRefreshing];
            [self.mTableView.mj_footer endRefreshing];
        };
        _reqTool.refreshBlock = ^{
            kStrongSelf(self)
            [self handleRefreshAction];
        };
        _reqTool.noMoreDataBlock = ^{
            kStrongSelf(self)
            self.mTableView.mj_footer = nil;
        };
    }
    return _reqTool;
}

- (YGCustomTableViewDataSource *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [[YGCustomTableViewDataSource alloc] initWithItems:self.reqTool.dataArray cellIdentifier:RMBookDetailRateCellIdentifier singleSection:NO configureCellBlock:^(RMBookDetailRateCell *cell, RMBookCommentModel *model) {
            cell.commentModel = model;
        }];
    }
    return _dataSource;
}

参考以上代码即可快速实现分页逻辑处理和展示
