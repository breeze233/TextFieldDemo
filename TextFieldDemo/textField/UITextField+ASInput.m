//
//  UITextField+ASInput.m
//  TextFieldDemo
//
//  Created by sheng li on 2017/7/17.
//  Copyright © 2017年 yeeuu. All rights reserved.
//
#define ScreenHeight [UIScreen  mainScreen].bounds.size.height
#define ScreenWidth [UIScreen  mainScreen].bounds.size.width

#import "UITextField+ASInput.h"
#import "ASInputPromptView.h"
#import <objc/message.h>

static const CGFloat inputViewHeight = 35.0f;

@implementation UITextField (ASInput)

+ (void)load {
    Method awakeFromNibMethod = class_getInstanceMethod([self class], @selector(awakeFromNib));
    Method ASawakeFromNibMethod = class_getInstanceMethod([self class], @selector(ASawakeFromNib));
    method_exchangeImplementations(awakeFromNibMethod, ASawakeFromNibMethod);
}

- (void)ASawakeFromNib {
    
    if ([NSStringFromClass([self class]) isEqualToString:@"UITextField"]) {
        
        [self ASawakeFromNib];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppearance) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
        [self addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
        
        if ([ASInputPromptView shared].currectViewStr.length == 0) {
            [ASInputPromptView shared].currectViewStr = NSStringFromClass([[self getCurrentViewController].view class]);
        }
        if (![NSStringFromClass([[self getCurrentViewController].view class]) isEqualToString:[ASInputPromptView shared].currectViewStr]) {
            [[ASInputPromptView shared].textFieldArr removeAllObjects];
        }
        
        
        [[ASInputPromptView shared].textFieldArr addObject:(UITextField *)self];
    }

}

-(void)textFieldTextChange:(UITextField *)textField{

    self.inputPromptView.textField.text = self.text;
    if (self.text.length == 0 ) {
        self.inputPromptView.textField.textColor = [UIColor lightGrayColor];
        self.inputPromptView.textField.text = self.placeholder;
    }else{
        self.inputPromptView.textField.textColor = [UIColor blackColor];
        self.inputPromptView.textField.text = self.text;
    }
}


static char *InputPromptViewNameKey = "InputPromptViewNameKey";

- (ASInputPromptView *)inputPromptView {
    
    ASInputPromptView * promptView = [[ASInputPromptView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, inputViewHeight)];
    if (!objc_getAssociatedObject(self, InputPromptViewNameKey)) {
        [promptView.achieveButton addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
        objc_setAssociatedObject(self, InputPromptViewNameKey, promptView, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:promptView];
    if (self.text.length == 0 ) {
        promptView.textField.textColor = [UIColor lightGrayColor];
        promptView.textField.text = self.placeholder;
    }else{
        promptView.textField.textColor = [UIColor blackColor];
        promptView.textField.text = self.text;
    }
    
    return objc_getAssociatedObject(self, InputPromptViewNameKey);
}

- (void)returnClick {
    [[self getCurrentViewController].view endEditing:true];
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

static CGFloat _offset;
static CGFloat _viewY;

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
            _offset = _offset + view.frame.origin.y;
        }else{
            [self findControllerViewWith:view.superview];
            _offset = _offset + view.frame.origin.y;
        }
        
    } @catch (NSException *exception) { } @finally { }
}

#pragma mark– 键盘
- (void)keyboardAppearance{
    if (!self.isFirstResponder) {
        return;
    }
  [ASInputPromptView shared].currectTextField = self;
}

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
    
    _offset = 0;
    [self findControllerViewWith:self];
    CGFloat flout  = ScreenHeight - _offset - self.frame.size.height - inputViewHeight - 5;

    //需要位移的大小
    CGFloat keyHeight = flout - keyboardRect.size.height;
    if(keyHeight<=0){
        
        if (keyHeight < -keyboardRect.size.height - inputViewHeight) {
            keyHeight = -keyboardRect.size.height - inputViewHeight;
            UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight,ScreenWidth, inputViewHeight)];
            buttomView.backgroundColor = [UIColor whiteColor];
            [[self getCurrentViewController].view addSubview:buttomView];
        }
        
        // 位移
        NSLog(@"%f",keyHeight);
        [UIView animateWithDuration:[animationTime doubleValue] animations:^{
            self.inputPromptView.frame = CGRectMake(0, ScreenHeight - keyboardRect.size.height - inputViewHeight, ScreenWidth, inputViewHeight);
            [self setViewY:[self getCurrentViewController].view.frame.origin.y];
            [self getCurrentViewController].view.frame =CGRectMake(0,keyHeight,ScreenWidth, ScreenHeight);
        }];
        
    }else{
        [UIView animateWithDuration:[animationTime doubleValue] animations:^{
            self.inputPromptView.frame = CGRectMake(0, ScreenHeight - keyboardRect.size.height - inputViewHeight, ScreenWidth, inputViewHeight);
            [self getCurrentViewController].view.frame =CGRectMake(0,_viewY,ScreenWidth, ScreenHeight);
        }];
    }

}
//键盘隐藏事件
- (void)keyBoardDidHide:(NSNotification *)notification{
    if (!self.isFirstResponder) {
        return;
    }
    
    NSDictionary *dict = notification.userInfo;
    NSNumber *animationTime = [dict objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"];
 
    [UIView animateWithDuration:[animationTime doubleValue] animations:^{
        [self getCurrentViewController].view.frame =CGRectMake(0, _viewY , ScreenWidth, ScreenHeight);
        self.inputPromptView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, inputViewHeight);
    } completion:^(BOOL finished) {
        [self louseFocusOnUs];
    }];
}
- (void)louseFocusOnUs{
    [self.inputPromptView removeFromSuperview];
    objc_setAssociatedObject(self, InputPromptViewNameKey, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
