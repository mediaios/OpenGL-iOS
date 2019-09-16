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

- (IBAction)rotateXSliderChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float currentValue = [slider value];
    self.glView.rotateX = currentValue;
}

- (IBAction)scaleZSliderChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    float currentValue = [slider value];
    self.glView.scaleZ = currentValue;
}

- (void)resetControlls
{
    [self.posXSlider setValue:self.glView.mX];
}

@end
