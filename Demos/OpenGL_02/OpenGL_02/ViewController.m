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
@property (weak, nonatomic) IBOutlet GLView *glView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


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
