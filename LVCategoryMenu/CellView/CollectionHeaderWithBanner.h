//
//  CollectionHeaderWithBanner.h
//  WMALL
//
//  Created by HanLiu on 16/4/7.
//  Copyright © 2016年 wjhg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionHeaderWithBanner : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImg;

@end
