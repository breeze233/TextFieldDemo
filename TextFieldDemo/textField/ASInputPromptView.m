//
//  Input prompt ASInputPromptView.m
//  TextFieldDemo
//
//  Created by sheng li on 2017/7/14.
//  Copyright © 2017年 yeeuu. All rights reserved.
//


#import "ASInputPromptView.h"
#import "ASTextField.h"

@implementation ASInputPromptView
/** ---------------------------单利模式--------------------------- */
#pragma mark - 单利模式
//全局变量
static id _instance = nil;
//单例方法
+(instancetype)shared{
    return [[self alloc] init];
}
////alloc会调用allocWithZone:
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    //只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (instancetype)initWithFrame:(CGRect)frame{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super initWithFrame:frame];
        [self initialize];
    });
    return _instance;
}

//初始化方法
- (instancetype)init{
    // 只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        [self initialize];
    });
    return _instance;
}
//copy在底层 会调用copyWithZone:
- (id)copyWithZone:(NSZone *)zone{
    return  _instance;
}
+ (id)copyWithZone:(struct _NSZone *)zone{
    return  _instance;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}

/** ------------------------------------------------------------------*/

- (void)initialize {
    
    self.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    
    self.textField = ({
        ASTextField * textField = [[ASTextField alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 50 , 30)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.userInteractionEnabled = false;
        textField.backgroundColor = [UIColor clearColor];
        textField.font = [UIFont systemFontOfSize:12];
        [self addSubview:textField];
        self.textField = textField;
    });
    
    self.achieveButton = ({
        UIButton * button =  [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, ScreenWidth - 10, 30);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.userInteractionEnabled = true;
        [button setTintColor:[UIColor blackColor]];
        button.titleLabel.text = @"完成";
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [self addSubview:button];
        self.achieveButton = button;
    });

}
@end
