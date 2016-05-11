

#import "MultilevelMenu.h"
#import "MultilevelTableViewCell.h"
#import "MultilevelCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "CollectionHeader.h"
#import "CollectionHeaderWithBanner.h"

#define kLeftWidth 80
#define kTableViewCellHeight 64
#define kCellRightLineTag 100
#define kImageDefaultName @"tempShop"
#define kMultilevelCollectionViewCell @"MultilevelCollectionViewCell"
#define kMultilevelCollectionHeader   @"CollectionHeader"//CollectionHeader
#define kMultilevelCollectionHeaderWithBanner   @"CollectionHeaderWithBanner"//CollectionHeader

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface MultilevelMenu()


@property (nonatomic,strong)NSString * selectedCategoryId;
@property (nonatomic,assign)NSInteger selectedCategoryIndex;
@property (nonatomic,assign)BOOL isReturnLastOffset;
@property (nonatomic,strong)NSArray *headerIconArray;
@end
@implementation MultilevelMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame WithData:(NSArray *)data withSelectIndex:(void (^)(NSString * categoryId, NSIndexPath * rightIndexPath,NSString * attr_id))selectIndex
{
    self=[super initWithFrame:frame];
    if (self) {

        
        _tableViewDataSource     = [NSMutableArray array];
        _collectionDataSource    = [NSMutableArray array];
        _topImagesArray          = [NSMutableArray array];
        self.leftSelectColor     = [UIColor colorWithRed:0.98 green:0.32 blue:0.32 alpha:1];
        self.leftSelectBgColor   = [UIColor whiteColor];
        
        self.leftBgColor         = UIColorFromRGB(0xF3F4F6);
        self.leftSeparatorColor  = UIColorFromRGB(0xE5E5E5);
        
        self.leftUnSelectBgColor = UIColorFromRGB(0xF3F4F6);
        self.leftUnSelectColor   = [UIColor blackColor];
        
        self.headerIconArray = @[@"category_icon_red",@"category_icon_orange",@"category_icon_purple",@"category_icon_blue",@"category_icon_roseRed"];
        _block          = selectIndex;
        _selectIndex    = 0;
        _allData        = data;
        
        
        /**
         左边的视图
        */
        self.leftTable  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kLeftWidth, frame.size.height)];
        self.leftTable.dataSource   = self;
        self.leftTable.delegate     = self;
        
        self.leftTable.tableFooterView=[[UIView alloc] init];
        [self addSubview:self.leftTable];
        
        self.leftTable.backgroundColor=self.leftBgColor;
        
        if ([self.leftTable respondsToSelector:@selector(setLayoutMargins:)]) {
            self.leftTable.layoutMargins=UIEdgeInsetsZero;
        }
        if ([self.leftTable respondsToSelector:@selector(setSeparatorInset:)]) {
            self.leftTable.separatorInset=UIEdgeInsetsZero;
        }
        self.leftTable.separatorColor = self.leftSeparatorColor;
        self.leftTable.showsHorizontalScrollIndicator = NO;
        self.leftTable.showsVerticalScrollIndicator = NO;
        //self.leftTable.scrollEnabled = NO;
        
        /**
         右边的视图
         */
        float leftMargin = 3;

        
        //CollectionView
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        flowLayout.minimumInteritemSpacing  =0.f;//左右间隔
        flowLayout.minimumLineSpacing       =0.f;
        
        
        self.rightCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(kLeftWidth+leftMargin,0,kScreenWidth-kLeftWidth-leftMargin*2,frame.size.height) collectionViewLayout:flowLayout];
        
        self.rightCollection.delegate   = self;
        self.rightCollection.dataSource = self;
        
        //标签cell
        UINib *nib=[UINib nibWithNibName:kMultilevelCollectionViewCell bundle:nil];
        [self.rightCollection registerNib: nib forCellWithReuseIdentifier:kMultilevelCollectionViewCell];
        
        //header
        UINib *header=[UINib nibWithNibName:kMultilevelCollectionHeader bundle:nil];
        [self.rightCollection registerNib:header forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMultilevelCollectionHeader];
        
        UINib *headerWithBanner=[UINib nibWithNibName:kMultilevelCollectionHeaderWithBanner bundle:nil];
        [self.rightCollection registerNib:headerWithBanner forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMultilevelCollectionHeaderWithBanner];
        
        [self addSubview:self.rightCollection];
        
      
        self.isReturnLastOffset = YES;
        
        self.rightCollection.backgroundColor = self.leftSelectBgColor;

        self.backgroundColor = self.leftSelectBgColor;
        
    }
    return self;
}

-(void)setNeedToScorllerIndex:(NSInteger)needToScorllerIndex{
    
        /**
         *  滑动到 指定行数
//         */

    [self.leftTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:needToScorllerIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    _selectIndex = needToScorllerIndex;
        

    _needToScorllerIndex = needToScorllerIndex;
}

-(void)setleftTableCellSelected:(BOOL)selected withCell:(MultilevelTableViewCell*)cell
{
    if (selected) {
        
        cell.titile.textColor   = self.leftSelectColor;
        cell.backgroundColor    = self.leftSelectBgColor;
    }
    else{
        cell.titile.textColor   = self.leftUnSelectColor;
        cell.backgroundColor    = self.leftUnSelectBgColor;
    }
   

}

#pragma mark---左边的tablew 代理
#pragma mark--deleagte
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return self.allData.count;
    return self.tableViewDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * Identifier=@"MultilevelTableViewCell";
    MultilevelTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (!cell) {
        cell=[[NSBundle mainBundle] loadNibNamed:@"MultilevelTableViewCell" owner:self options:nil][0];
    }
    
    
    cell.selectionStyle     = UITableViewCellSelectionStyleNone;
    NSDictionary * menuDic  = self.tableViewDataSource[indexPath.row];
    cell.titile.text        = menuDic[@"gc_name"];

    if (_selectedCategoryId == nil) {//添加默认值
        _selectedCategoryId = self.tableViewDataSource[0][@"gc_id"];
    }
    //必须与当前选中的cell比较
    if (indexPath.row == _selectedCategoryIndex) {
        [self setleftTableCellSelected:YES withCell:cell];
        
    }else{
        [self setleftTableCellSelected:NO withCell:cell];

    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins=UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset=UIEdgeInsetsZero;
    }
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kTableViewCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置当前选中的分类的index，collectionView的header用。
    _selectedCategoryIndex = indexPath.row;
    //消去第一个cell的选择状态
    NSIndexPath * firstIndexPath  = [NSIndexPath indexPathForRow:0 inSection:0];
    MultilevelTableViewCell * firstcell=(MultilevelTableViewCell*)[tableView cellForRowAtIndexPath:firstIndexPath];
    [self setleftTableCellSelected:NO withCell:firstcell];
    
    
    MultilevelTableViewCell * cell=(MultilevelTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
   
    _selectIndex = indexPath.row;
    [self setleftTableCellSelected:YES withCell:cell];

    NSDictionary * menuDic = self.tableViewDataSource[indexPath.row];
    
    
    _selectedCategoryId = menuDic[@"gc_id"];
    
    NSLog(@"categoryId:%@   categoryName:%@",_selectedCategoryId, menuDic[@"gc_name"]);
    _selecteTBBlock(indexPath.row,menuDic[@"gc_id"]);

    //tableView咋不动(⊙o⊙)？
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self setleftTableCellSelected:YES withCell:cell];

    [self.rightCollection scrollRectToVisible:CGRectMake(0, 0, self.rightCollection.frame.size.width, self.rightCollection.frame.size.height) animated:YES];
    

}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    MultilevelTableViewCell * cell = (MultilevelTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.titile.textColor=self.leftUnSelectColor;
    UILabel * line=(UILabel*)[cell viewWithTag:100];
    line.backgroundColor=tableView.separatorColor;

    [self setleftTableCellSelected:NO withCell:cell];

}

#pragma mark---imageCollectionView--------------------------

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    
    return self.collectionDataSource.count;
    
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    NSDictionary *itemDic = self.collectionDataSource[section];
    NSArray * itemArray = [NSArray arrayWithArray:itemDic[@"value"]];
    return itemArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MultilevelCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kMultilevelCollectionViewCell forIndexPath:indexPath];

    NSDictionary *itemDic = self.collectionDataSource[indexPath.section];
    NSArray * itemArray = itemDic[@"value"];
    if (indexPath.section == 0) {
        cell.titile.text = itemArray[indexPath.row][@"brand_name"];

    }else{
        cell.titile.text = itemArray[indexPath.row][@"attr_value_name"];

    }
    cell.backgroundColor=[UIColor clearColor];
    /*
     !if you use image:
     //cell.imageView.backgroundColor=UIColorFromRGB(0xF8FCF8);
     //[cell.imageView sd_setImageWithURL:[NSURL URLWithString:meun.urlName] placeholderImage:[UIImage imageNamed:kImageDefaultName]];
     
     */
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *reuseIdentifier;
    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
        reuseIdentifier = @"footer";
        UICollectionReusableView *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
        view.backgroundColor = [UIColor lightGrayColor];
        return view;
    }else{
        if (indexPath.section == 0) {
            reuseIdentifier = kMultilevelCollectionHeaderWithBanner;
            CollectionHeaderWithBanner *header =  (CollectionHeaderWithBanner *)[collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
            
            
            if (self.collectionDataSource.count>0) {
                NSDictionary *itemDic  = self.collectionDataSource[indexPath.section];
                header.title.text      = itemDic[@"name"];
                NSString *imgName      = self.headerIconArray[0];
                header.headerImg.image = [UIImage imageNamed:imgName];
                if (_topImagesArray.count) {
                    NSString * topImageUrl = _topImagesArray[_selectedCategoryIndex];
                    NSLog(@"topImageUrl:%@",topImageUrl);
                    [header.bannerImg sd_setImageWithURL:[NSURL URLWithString:topImageUrl] placeholderImage:nil options:SDWebImageRefreshCached];
                }
               
            }
            else{
                header.title.text=@"暂无";
            }
            
            return header;
        }else{
            reuseIdentifier = kMultilevelCollectionHeader;
            CollectionHeader *header =  (CollectionHeader *)[collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
            
            int t = indexPath.section%5;
            
            if (self.collectionDataSource.count>0) {
                NSDictionary *itemDic  = self.collectionDataSource[indexPath.section];
                header.title.text      = itemDic[@"name"];
                NSString *imgName      = self.headerIconArray[t];
                header.headerImg.image = [UIImage imageNamed:imgName];
            }
            else{
                header.title.text=@"暂无";
            }
            return header;
        }
    }

    
    
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *itemDic   = self.collectionDataSource[indexPath.section];
    NSArray * itemArray     = [NSArray arrayWithArray:itemDic[@"value"]];
    NSString * itemStr      = nil;
    if (indexPath.section == 0) {
        itemStr = itemArray[indexPath.row][@"brand_id"];
    }else{
        itemStr = itemArray[indexPath.row][@"attr_value_id"];

    }
    
    void (^select)(NSString * _selectedCategoryId,NSIndexPath * right,id info) = self.block;

    select(self.selectedCategoryId,indexPath,itemStr);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(80, 40);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size = {kScreenWidth-kLeftWidth,44};
    if (section == 0) {
        size.height = 44+80;
        return size;
    }
    return size;
}


#pragma mark---记录滑动的坐标
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.rightCollection]) {

        
        self.isReturnLastOffset=YES;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.rightCollection]) {
        
    
        
    }

 }

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.rightCollection]) {
        

        
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.rightCollection] && self.isReturnLastOffset) {


        
    }
}



#pragma mark--Tools
-(void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end