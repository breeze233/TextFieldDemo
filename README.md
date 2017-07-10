# TextFieldDemo

以前项目中，有需要输入银行卡号的需求（每4位空格）所以 做了个小Demo记录下 

# ASTextField 实现以下功能 
  1. 卡号输入框 （每4位空格，限制只能输入数字）
  ![image](https://github.com/breeze233/TextFieldDemo/blob/master/picture/bank.png)
  2. 16禁止输入框 （每2位空格，限制只能输入数字和A-F）
  ![image](https://github.com/breeze233/TextFieldDemo/blob/master/picture/hex.png)
  3. 可以 修改输入框的PlaceHold 文字颜色 和 大小 及所在位置
   ![image](https://github.com/breeze233/TextFieldDemo/blob/master/picture/hold.png)
# 使用 （可在Storyboard 中用 kayPath 设置）
  StoryBoard 继承 ASTextField
  kayPath 设置
  
    ASKeyBoardType  
      Bank ： 银行卡号输入框
      Hex ： 16进制输入框
      
    placeholderColor  占位文案颜色
    
    placeholderFont   占位字体大小
    
  ![image](https://github.com/breeze233/TextFieldDemo/blob/master/picture/resort.png)

# 实现
  本Demo 通过TextField代理实现
  
  如果需要在控制器 用代理方法的 添加如下代码
```objc  
- (BOOL)textField:(ASTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [textField textField:textField shouldChangeWithString:string];
}
```
