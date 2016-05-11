
#import <UIKit/UIKit.h>

typedef void(^SelectedTableViewIndexBlock)(NSInteger index,id obj);

@interface MultilevelMenu : UIView<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

//选中左侧边栏的block回调
@property (nonatomic,copy)SelectedTableViewIndexBlock selecteTBBlock;


@property (nonatomic,strong)NSMutableArray * tableViewDataSource;
@property (nonatomic,strong)NSMutableArray * collectionDataSource;

@property (nonatomic,strong)UITableView *leftTable;
@property (nonatomic,strong)UICollectionView *rightCollection;
@property (nonatomic,strong)NSMutableArray * topImagesArray;

@property(strong,nonatomic,readonly) NSArray * allData;


@property(copy,nonatomic,readonly) id block;

/**
 *  是否 记录滑动位置
 */
@property(assign,nonatomic) BOOL isRecordLastScroll;
/**
 *   记录滑动位置 是否需要 动画
 */
@property(assign,nonatomic) BOOL isRecordLastScrollAnimated;

@property(assign,nonatomic,readonly) NSInteger selectIndex;

/**
 *  为了 不修改原来的，因此增加了一个属性，选中指定 行数
 */
@property(assign,nonatomic) NSInteger needToScorllerIndex;
/**
 *  颜色属性配置
 */

/**
 *  左边背景颜色
 */
@property(strong,nonatomic) UIColor * leftBgColor;
/**
 *  左边点中文字颜色
 */
@property(strong,nonatomic) UIColor * leftSelectColor;
/**
 *  左边点中背景颜色
 */
@property(strong,nonatomic) UIColor * leftSelectBgColor;

/**
 *  左边未点中文字颜色
 */

@property(strong,nonatomic) UIColor * leftUnSelectColor;
/**
 *  左边未点中背景颜色
 */
@property(strong,nonatomic) UIColor * leftUnSelectBgColor;
/**
 *  tablew 的分割线
 */
@property(strong,nonatomic) UIColor * leftSeparatorColor;

-(instancetype)initWithFrame:(CGRect)frame WithData:(NSArray*)data withSelectIndex:(void(^)(NSString * categoryId, NSIndexPath * rightIndexPath,NSString * attr_id))selectIndex;

@end

