# LVCategoryMenu
分类页面视图，适用于大部分多级商品展示页面

###Install

Manually

###Usage
初始化，并且传入点击右侧collectionView cell的事件
```objc
_mview =[[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-44) WithData:nil withSelectIndex:^(NSString * categoryId, NSIndexPath * rightIndexPath,NSString * attr_id) {
    //do something...
}];
```

```objc
__weak typeof(self)wself = self;
//设置点击左侧菜单栏时的block：请求相应的分类详情。
_mview.selecteTBBlock = ^(NSInteger index,id obj){
    //do something...
};
_mview.isRecordLastScroll=YES;
[self.view addSubview:_mview];
```