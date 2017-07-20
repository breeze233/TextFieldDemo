//
//  Input prompt ASInputPromptView.m
//  TextFieldDemo
//
//  Created by sheng li on 2017/7/14.
//  Copyright © 2017年 yeeuu. All rights reserved.
//


#import "ASInputPromptView.h"
#import "ASTextField.h"

static const CGFloat inputViewHeight = 35.0f;

@interface ASInputPromptView ()

@property (assign, nonatomic) CGFloat textY;

@property (strong, nonatomic) UIButton * frontButton;
@property (strong, nonatomic) UIButton * nextButton;
@end


@implementation ASInputPromptView
/** ---------------------------单利模式--------------------------- */
#pragma mark - 单利模式
//全局变量
static id _instance = nil;
//单例方法
+(instancetype)shared{
    return [[self alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, inputViewHeight)];
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

- (NSMutableArray *)textFieldArr{
    if (!_textFieldArr) {
        _textFieldArr = [NSMutableArray array];
    }
    if (_textFieldArr.count < 2 ) {
        return  _textFieldArr;
    }
    
    NSArray *tempArr =[_textFieldArr sortedArrayUsingComparator:^NSComparisonResult(UITextField * textField1, UITextField * textField2) {
    
        if([self findControllerViewWith:textField1] < [self findControllerViewWith:textField2]){
            // 升序
            return NSOrderedAscending;
        }
        
        if([self findControllerViewWith:textField1] > [self findControllerViewWith:textField2]){
            // 降序
            return NSOrderedDescending;
        }
        // 相同不变
        return NSOrderedSame;  
    }];
    
    _textFieldArr = [NSMutableArray arrayWithArray:tempArr];
    
    return _textFieldArr;
}

- (CGFloat )findControllerViewWith:(UIView *)view {
    self.textY = 0;
    [self findControllerView:view];
    return self.textY;
}

- (void)setCurrectTextField:(UITextField *)currectTextField{
    
    _currectTextField = currectTextField;
    
    for (NSInteger index = 0; index < self.textFieldArr.count; index++) {
        if ([self.textFieldArr[index] isEqual:currectTextField]) {
            self.focusIndex = index;
        }
    }    
}

- (void)findControllerView:(UIView *)view {
    @try {
        if ([view.superview isEqual:[self getCurrentViewControllerFromView:view].view]) {
            NSLog(@"findControllerViewWith \\\%@",view.superview);
            self.textY = self.textY + view.frame.origin.y;
        }else{
            [self findControllerView:view.superview];
            self.textY = self.textY + view.frame.origin.y;
        }
        
    } @catch (NSException *exception) { } @finally { }
}
/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewControllerFromView:(UIView *)view{
    
    UIResponder *next = [view nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (void)initialize {
    
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , inputViewHeight)];
    [self addSubview:bar];
    
    self.textField = ({
        ASTextField * textField = [[ASTextField alloc] initWithFrame:CGRectMake(90, 0, ScreenWidth - 130 , inputViewHeight)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.userInteractionEnabled = false;
        textField.backgroundColor = [UIColor clearColor];
        textField.font = [UIFont systemFontOfSize:12];
        [self addSubview:textField];
        self.textField = textField;
    });
    
    self.achieveButton = ({
        UIButton * button =  [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(100, 0, ScreenWidth - 110, inputViewHeight);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        button.userInteractionEnabled = true;
        [button setTintColor:[UIColor blackColor]];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        button.titleLabel.text = @"完成";
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [self addSubview:button];
        self.achieveButton = button;
    });
    
    self.frontButton = ({
        UIButton * button =  [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(5, 0, 25, inputViewHeight);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.userInteractionEnabled = true;
        [button setTintColor:[UIColor blackColor]];
        [button setImage:[UIImage imageNamed:@"front"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(frontClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.frontButton = button;
    });
    
    
    self.nextButton = ({
        UIButton * button =  [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(40, 0, 25, inputViewHeight);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.userInteractionEnabled = true;
        [button setTintColor:[UIColor blackColor]];
        [button setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.nextButton = button;
    });
    self.focusIndex = 0;
    
}

- (void)setFocusIndex:(NSInteger)focusIndex{
    
    self.frontButton.enabled = true;
    self.nextButton.enabled = true;
    
    _focusIndex = focusIndex;
    if (_focusIndex == 0) {
        self.frontButton.enabled = false;
    }else
    if (_focusIndex == self.textFieldArr.count - 1) {
        self.nextButton.enabled = false;
    }
}

- (void)frontClick {
    for (NSInteger index = 0; index < self.textFieldArr.count - 1 ; index++) {
        if (self.textFieldArr[index].isFirstResponder && index != 0 ) {
            self.focusIndex = index;
        }
    }
    
    if ( self.focusIndex > 0) {
        [self.textFieldArr[self.focusIndex - 1] becomeFirstResponder];
    }
}

- (void)nextClick {
    for (NSInteger index = 0;index < self.textFieldArr.count - 1; index++) {
        if (self.textFieldArr[index].isFirstResponder && index != self.textFieldArr.count - 1 ) {
            self.focusIndex = index;
        }
    }
    if (self.focusIndex  < self.textFieldArr.count - 1 ) {
        [self.textFieldArr[self.focusIndex + 1] becomeFirstResponder];
    }
    
}

@end
