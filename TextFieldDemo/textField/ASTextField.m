//
//  ASTextField.m
//  TextFieldDemo
//
//  Created by 王宝宝的Macbook Pro on 2017/7/7.
//  Copyright © 2017年 yeeuu. All rights reserved.
//

#import "ASTextField.h"
#import <UIKit/UIKit.h>
#import "ASInputPromptView.h"

@interface ASTextField ()<UITextFieldDelegate>

@property (strong, nonatomic) NSString * restrictionType;
@property (assign, nonatomic) NSInteger intervalLength;

@property (assign, nonatomic) CGFloat offset;
@property (assign, nonatomic) CGFloat viewY;

@property (strong, nonatomic) ASInputPromptView *inputPromptView;

@end

@implementation ASTextField
// StoryBoard 添加
- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];

}
// 代码创建
- (instancetype)init{
    
    self = [super init];
    if (self) {
        self.delegate = self;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
        [self addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return self;
}

- (void)setViewY:(CGFloat)viewY{
    if (viewY == 64 || _viewY == 64) {
        _viewY = 64;
    }else{
        _viewY = 0;
    }
}

- (void)findControllerViewWith:(UIView *)view {
    @try {
        
        if ([view.superview isEqual:[self getCurrentViewController].view]) {
            NSLog(@"findControllerViewWith \\\%@",view.superview);
            self.offset = self.offset + view.frame.origin.y;
        }else{
            [self findControllerViewWith:view.superview];
            self.offset = self.offset + view.frame.origin.y;
        }
        
    } @catch (NSException *exception) { } @finally { }
}

- (ASInputPromptView *)inputPromptView {
    if (!_inputPromptView) {
        _inputPromptView = [[ASInputPromptView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 30)];
        [_inputPromptView.achieveButton addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:_inputPromptView];
    }
    
    if (self.text.length == 0 ) {
        _inputPromptView.textField.textColor = [UIColor lightGrayColor];
        _inputPromptView.textField.text = self.placeholder;
    }else{
        _inputPromptView.textField.textColor = [UIColor blackColor];
        _inputPromptView.textField.text = self.text;
    }
    
    return _inputPromptView;
}

-(void)textFieldTextChange:(UITextField *)textField{
    _inputPromptView.textField.text = self.text;
    if (self.text.length == 0 ) {
        _inputPromptView.textField.textColor = [UIColor lightGrayColor];
        _inputPromptView.textField.text = self.placeholder;
    }else{
        _inputPromptView.textField.textColor = [UIColor blackColor];
        _inputPromptView.textField.text = self.text;
    }
}

- (void)returnClick {
    [[self getCurrentViewController].view endEditing:true];
}

- (void)louseFocusOnUs{
    
    [_inputPromptView removeFromSuperview];
    _inputPromptView = nil;
    
}

#pragma mark– 键盘
//键盘改变事件的触发
- (void)keyBoardChange:(NSNotification *)notification{
    
    if (!self.isFirstResponder) {
        return;
    }
    
    
    
    NSDictionary *dict = notification.userInfo;
    NSValue *aValue = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber *animationTime = [dict objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"];
    //键盘的高度
    CGRect keyboardRect = [aValue CGRectValue];
    //想要显示的高度
    self.offset = 0;
    [self findControllerViewWith:self];
    CGFloat flout  = ScreenHeight - self.offset - self.frame.size.height - 35;
    
    //需要位移的大小
    CGFloat keyHeight = flout - keyboardRect.size.height;
    if(keyHeight<=0){
        // 位移
        NSLog(@"%f",keyHeight);
        [UIView animateWithDuration:[animationTime doubleValue] animations:^{
            self.inputPromptView.frame = CGRectMake(0, ScreenHeight - keyboardRect.size.height - 30, ScreenWidth, 30);
            self.viewY = [self getCurrentViewController].view.frame.origin.y;
            [self getCurrentViewController].view.frame =CGRectMake(0,keyHeight, [self getCurrentViewController].view.frame.size.width, [self getCurrentViewController].view.frame.size.height);
        }];
        
    }else{
        [UIView animateWithDuration:[animationTime doubleValue] animations:^{
            self.inputPromptView.frame = CGRectMake(0, ScreenHeight - keyboardRect.size.height - 30, ScreenWidth, 30);
        }];
    }
    
}
//键盘隐藏事件
- (void)keyBoardDidHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.5 animations:^{
         _inputPromptView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 30);
        [self getCurrentViewController].view.frame =CGRectMake(0, self.viewY , [self getCurrentViewController].view.frame.size.width, [self getCurrentViewController].view.frame.size.height);
    } completion:^(BOOL finished) {
        [self louseFocusOnUs];
    }];
}

/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController{
    
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
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

#pragma mark - 修改占位文案颜色
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    id textColor = [self valueForKeyPath:@"_placeholderLabel.textColor"];
    if (textColor) {
        [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
}

#pragma mark - 修改占位文字大小
- (void)setPlaceholderFont:(NSInteger)placeholderFont {
    id textFont = [self valueForKeyPath:@"_placeholderLabel.font"];
    if (textFont) {
        [self setValue:[UIFont systemFontOfSize:placeholderFont] forKeyPath:@"_placeholderLabel.font"];
    }
}


#pragma mark -控制placeHolder的位置
- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    return bounds;
}

#pragma mark - textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return [self shouldChangeWithString:string];
}

- (BOOL)shouldChangeWithString:(NSString *)string {
    
    if (self.restrictionType.length == 0) {// 默认无类型键盘都不是
        return true;
    }
    
    if ([string isEqualToString:@""]) {
        return true;
    }
    

    
    NSString *text = [self text];
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:self.restrictionType];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return false;
    }
    
    NSString *newString = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (newString.length > 0 && newString.length % self.intervalLength == 0) {
        text = [text stringByAppendingString:@" "];
    }

    text = [text stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    [self setText:text];
    return true;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
