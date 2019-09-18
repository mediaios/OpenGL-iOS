//
//  ViewController.m
//  OpenGL_05
//
//  Created by mediaios on 2019/9/18.
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

- (IBAction)onPressedBtnRotate:(id)sender {
    [self.glView autoRotate];
    
    UIButton * button = (UIButton *)sender;
    NSString * text = button.titleLabel.text;
    if ([text isEqualToString:@"Rotate"]) {
        [button setTitle: @"Stop" forState: UIControlStateNormal];
    }
    else {
        [button setTitle: @"Rotate" forState: UIControlStateNormal];
    }
}

@end
