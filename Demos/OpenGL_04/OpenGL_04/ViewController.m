//
//  ViewController.m
//  OpenGL_04
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

- (IBAction)shoulderChange:(id)sender {
    UISlider * slider = (UISlider *)sender;
    float currentValue = [slider value];
    
    NSLog(@" >> current shoulder is %f", currentValue);
    
    self.glView.rotateShoulder = currentValue;
}

- (IBAction)elbowChange:(id)sender {
    UISlider * slider = (UISlider *)sender;
    float currentValue = [slider value];
    
    NSLog(@" >> current elbow is %f", currentValue);
    
    self.glView.rotateElbow = currentValue;
}

@end
