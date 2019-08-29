//
//  ViewController.m
//  OpenGL_02
//
//  Created by mediaios on 2019/8/28.
//  Copyright © 2019 mediaios. All rights reserved.
//

#import "ViewController.h"
#import "GLView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet GLView *glViewLine;  // 绘制线条的
@property (weak, nonatomic) IBOutlet GLView *glViewTriangle;
@property (weak, nonatomic) IBOutlet GLView *glView;  // 绘制图形的

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark- 测试直线图元
- (IBAction)onPressedBtnPoints3:(id)sender {
    [self.glViewLine showLinesPoints3];
}

- (IBAction)onPressedBtnPoints4:(id)sender {
    [self.glViewLine showLinesPoints4];
}


- (IBAction)onPressedBtnPoints8:(id)sender {
    [self.glViewLine showLinesPoints8];
}

#pragma mark- 测试三角形图元
- (IBAction)onPressedBtnTrianglePoint3:(id)sender {
    [self.glViewTriangle drawWithPrimitiveTrianglePoints3];
}


- (IBAction)onPressedBtnTrianglePoint4:(id)sender {
    [self.glViewTriangle drawWithPrimitiveTrianglePoints4];
}

- (IBAction)onPressedBtnTrianglePoint8:(id)sender {
    [self.glViewTriangle drawWithPrimitiveTrianglePoints8];
}

#pragma mark- 利用 GL_TRIANGLES 图元绘图
- (IBAction)onPressedBtnTriangle:(id)sender {
    [self.glView showTriangle];
}


- (IBAction)onPressedBtnRectangle:(id)sender {
    [self.glView showRectangle];
}

- (IBAction)onPressedBtnOctagon:(id)sender {
    [self.glView showOctagon];
}






@end
