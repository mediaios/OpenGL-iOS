//
//  ViewController.h
//  GLKit_03
//
//  Created by ethan on 2019/12/19.
//  Copyright © 2019 ucloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
@class AGLVertexAttribArrayBuffer;

@interface ViewController : GLKViewController

@property (nonatomic,strong) GLKBaseEffect *baseEffect;
@property (nonatomic,strong) AGLVertexAttribArrayBuffer *vertexBuffer;

@property (nonatomic) BOOL shouldUseLinearFilter;
@property (nonatomic) BOOL shouldAnimate;
@property (nonatomic) BOOL shouldRepeatTexture;
@property (nonatomic) GLfloat sCoordinateOffset;


- (IBAction)takeSCoordinateOffsetFrom:(UISlider *)sender;
- (IBAction)takeShouldRepeatTextureFrom:(UISwitch *)sender;
- (IBAction)takeShouldAnimateFrom:(UISwitch *)sender;
- (IBAction)takeShouldUseLinearFilterFrom:(UISwitch *)sender;

@end

