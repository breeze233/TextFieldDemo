//
//  ASTextField.h
//  TextFieldDemo
//
//  Created by 王宝宝的Macbook Pro on 2017/7/7.
//  Copyright © 2017年 yeeuu. All rights reserved.
//
#define ScreenHeight [UIScreen  mainScreen].bounds.size.height
#define ScreenWidth [UIScreen  mainScreen].bounds.size.width

#import <UIKit/UIKit.h>

@interface ASTextField : UITextField

@property (strong, nonatomic) NSString * ASKeyboardType;
@property (strong, nonatomic) UIColor * placeholderColor;
@property (assign, nonatomic) NSInteger placeholderFont;

- (BOOL)shouldChangeWithString:(NSString *)string;

@end
