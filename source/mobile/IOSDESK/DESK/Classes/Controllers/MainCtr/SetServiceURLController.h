//
//  SetServiceURLController.h
//  DESK
//
//  Created by 51desk on 15/6/5.
//  Copyright (c) 2015年 FX. All rights reserved.
//

#import "BaseViewController.h"


@interface UITextFieldEx : UITextField


@end

@interface SetServiceURLController : BaseViewController

@property (nonatomic,strong) UIButton *SaveBtn;
@property (nonatomic,strong) UITextFieldEx *  ServiceField ;
@property (nonatomic,strong) UIImageView *  HeadImage ;
@property (nonatomic,strong) UILabel * ExplanationLable ;
@property (nonatomic,strong) UILabel * EmailLable ;


@end


