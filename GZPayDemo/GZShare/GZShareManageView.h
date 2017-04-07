//
//  GZShareManage.h
//  GZPayDemo
//
//  Created by xinshijie on 2017/4/6.
//  Copyright © 2017年 Mr.quan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void (^RRBlock)(NSInteger index,UILabel *sheetLab,id ShareType);


@interface GZShareManageView : UIView


/*
 *  为actionsheet上小视图
 *  按照 高度120（90（按钮60*60）+30）来设计
 */

@property (nonatomic,strong) UIButton *sheetBtn;

@property (nonatomic,strong) UILabel *sheetLab;

///要分享到的平台
@property (nonatomic) id  shareType;



@property (nonatomic,copy) RRBlock block;


- (void)selectedIndex:(RRBlock)block;

@end
