//
//  ViewController.h
//  GLKit_02
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
@end

