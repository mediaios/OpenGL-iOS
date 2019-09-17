//
//  ViewController.m
//  OpenGL_03
//
//  Created by mediaios on 2019/9/11.
//  Copyright © 2019 mediaios. All rights reserved.
//

#import "ViewController.h"
#import "GLView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *posXSlider;
@property (weak, nonatomic) IBOutlet UISlider *posYSlider;
@property (weak, nonatomic) IBOutlet UISlider *posZSlider;

@property (weak, nonatomic) IBOutlet UISlider *rotateXSlider;
@property (weak, nonatomic) IBOutlet UISlider *rotateYSlider;
@property (weak, nonatomic) IBOutlet UISlider *rotateZSlider;

@property (weak, nonatomic) IBOutlet UISlider *scaleXSlider;
@property (weak, nonatomic) IBOutlet UISlider *scaleYSlider;
@property (weak, nonatomic) IBOutlet UISlider *scaleZSlider;

@property (weak, nonatomic) IBOutlet GLView *glView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self resetControlls];
}

- (IBAction)posXSliderChange:(id)sender {
    UISlider * slider = (UISlider *)sender;
    float currentValue = [slider value];
    self.glView.mX = currentValue;
}

- (IBAction)posYSliderChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float currentValue = [slider value];
    self.glView.mY = currentValue;
}

- (IBAction)posZSliderChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float currentValue = [slider value];
    self.glView.mZ = currentValue;
}


#pragma mark- 旋转
- (IBAction)rotateXSliderChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float currentValue = [slider value];
    self.glView.rotateX = currentValue;
}

- (IBAction)rotateYSliderChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float currentValue = [slider value];
    self.glView.rotateY = currentValue;
}

- (IBAction)rotateZSliderChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float currentValue = [slider value];
    self.glView.rotateZ = currentValue;
}

#pragma mark- 缩放
- (IBAction)scaleXSliderChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float currentValue = [slider value];
    self.glView.scaleX = currentValue;
}

- (IBAction)scaleYSliderChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float currentValue = [slider value];
    self.glView.scaleY = currentValue;
}

- (IBAction)scaleZSliderChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float currentValue = [slider value];
    self.glView.scaleZ = currentValue;
}

- (IBAction)onPressedBtnAuto:(id)sender {
    [self.glView triggerDisplayLink];
    UIButton * button = (UIButton *)sender;
    NSString * text = button.titleLabel.text;
    if ([text isEqualToString:@"Auto"]) {
        [button setTitle: @"Stop" forState: UIControlStateNormal];
    }
    else {
        [button setTitle: @"Auto" forState: UIControlStateNormal];
    }
}


- (IBAction)onPressedBtnReset:(id)sender {
    [self.glView resetTransform];
    [self.glView render];
    [self resetControlls];
}

- (void)resetControlls
{
    [self.posXSlider setValue:self.glView.mX];
    [self.posYSlider setValue:self.glView.mY];
    [self.posZSlider setValue:self.glView.mZ];
    
    [self.rotateXSlider setValue:self.glView.rotateX];
    [self.rotateXSlider setValue:self.glView.rotateY];
    [self.rotateXSlider setValue:self.glView.rotateZ];
    
    [self.scaleXSlider setValue:self.glView.scaleX];
    [self.scaleXSlider setValue:self.glView.scaleY];
    [self.scaleXSlider setValue:self.glView.scaleZ];
}

@end
