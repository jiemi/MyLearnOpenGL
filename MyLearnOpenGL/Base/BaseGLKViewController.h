//
//  BaseGLKViewController.h
//  MyLearnOpenGL
//
//  Created by 萧锐杰 on 2020/8/1.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseGLKViewController : GLKViewController

- (void)compileShaderWithPath:(NSString *)path shader:(GLuint *)shader;

@end

NS_ASSUME_NONNULL_END
