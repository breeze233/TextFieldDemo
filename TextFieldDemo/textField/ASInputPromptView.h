//
//  Input prompt ASInputPromptView.h
//  TextFieldDemo
//
//  Created by sheng li on 2017/7/14.
//  Copyright © 2017年 yeeuu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ASInputPromptView: UIView
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton * achieveButton;

@property (strong, nonatomic) NSString * currectViewStr;

@property (assign, nonatomic) NSInteger focusIndex;

@property (strong, nonatomic) UITextField * currectTextField;

@property(strong, nonatomic) NSMutableArray <UITextField *> * textFieldArr;

+(instancetype)shared;

@end
