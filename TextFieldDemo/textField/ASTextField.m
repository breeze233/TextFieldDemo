//
//  ASTextField.m
//  TextFieldDemo
//
//  Created by 王宝宝的Macbook Pro on 2017/7/7.
//  Copyright © 2017年 yeeuu. All rights reserved.
//

#import "ASTextField.h"

@interface ASTextField ()<UITextFieldDelegate>

@property (strong, nonatomic) NSString * restrictionType;
@property (assign, nonatomic) NSInteger intervalLength;

@end

@implementation ASTextField
// StoryBoard 添加
- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.delegate = self;
}
// 代码创建
- (instancetype)init{
    
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}


#pragma mark - 关于键盘只能输入特定类型的内容
- (void)setASKeyboardType:(NSString *)ASKeyboardType {// 分为 输入卡号的键盘 和 16进制键盘 默认无类型
    
    if ([ASKeyboardType isEqualToString:@"Bank"]) {
        self.restrictionType = @"0123456789\b";
        self.intervalLength = 4;
    }else if([ASKeyboardType isEqualToString:@"Hex"]){
        self.restrictionType = @"0123456789ABCDEFabcdef\b";
        self.intervalLength = 2;
    }
}


- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    
//   id LS = [self valueForKey:_placeholderLabel.textColor];
//    NSLog(@"%@",LS);
    
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setPlaceholderFont:(NSInteger)placeholderFont {

    [self setValue:[UIFont systemFontOfSize:placeholderFont] forKeyPath:@"_placeholderLabel.font"];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return [self textField:textField shouldChangeWithString:string];
}

- (BOOL)textField:(UITextField *)textField shouldChangeWithString:(NSString *)string {
    
    if (self.restrictionType.length == 0) {// 默认无类型键盘都不是
        return true;
    }
    
    if ([string isEqualToString:@""]) {
        return true;
    }
    
    NSString *text = [textField text];
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:self.restrictionType];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return false;
    }
    
    NSString *newString = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (newString.length > 0 && newString.length % self.intervalLength == 0) {
        text = [text stringByAppendingString:@" "];
    }

    text = [text stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    [textField setText:text];
    return true;
}

@end