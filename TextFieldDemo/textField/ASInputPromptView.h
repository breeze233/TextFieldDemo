//
//  Input prompt ASInputPromptView.h
//  TextFieldDemo
//
//  Created by sheng li on 2017/7/14.
//  Copyright © 2017年 yeeuu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASTextField;
@interface ASInputPromptView: UIView
@property (strong, nonatomic) ASTextField *textField;
@property (strong, nonatomic) UIButton * achieveButton;

+(instancetype)shared;
@end
