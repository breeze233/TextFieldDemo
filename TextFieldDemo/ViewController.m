//
//  ViewController.m
//  TextFieldDemo
//
//  Created by 王宝宝的Macbook Pro on 2017/7/7.
//  Copyright © 2017年 yeeuu. All rights reserved.
//

#import "ViewController.h"
#import "ASTextField.h"

@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textfield1;
@property (weak, nonatomic) IBOutlet UITextField *textfield2;
@property (weak, nonatomic) IBOutlet UITextField *textfield3;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.textfield1.delegate = self;
    self.textfield2.delegate = self;
    self.textfield3.delegate = self;
    
    [self.textfield2 addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
}


-(void)textFieldTextChange:(UITextField *)textField{
   
    if (self.textfield2.text.length == 9) {
        self.textLabel.text = @"可以点击";
    }else {
        self.textLabel.text = @"不能点击 ";
        NSLog(@"%ld",self.textfield2.text.length);
    }
}

- (BOOL)textField:(ASTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return [textField shouldChangeWithString:string];
}

@end
