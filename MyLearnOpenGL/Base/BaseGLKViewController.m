//
//  BaseGLKViewController.m
//  MyLearnOpenGL
//
//  Created by 萧锐杰 on 2020/8/1.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "BaseGLKViewController.h"

@interface BaseGLKViewController ()

@property (nonatomic, strong) UIButton *closeBtn;


@end

@implementation BaseGLKViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.closeBtn = [[UIButton alloc] init];
    [self.closeBtn setTitle:@"Close" forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside
     ];
    
    self.closeBtn.frame = CGRectMake(40, 40, 50, 30);
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.closeBtn];
}

- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)compileShaderWithPath:(NSString *)path shader:(GLuint *)shader{
    
    *shader = glCreateShader(GL_FRAGMENT_SHADER);
    
    NSString* frameFile = path;
    NSString* content2 = [NSString stringWithContentsOfFile:frameFile encoding:NSUTF8StringEncoding error:nil];
    const GLchar* frameShaderSource = (GLchar *)[content2 UTF8String];
    
    glShaderSource(*shader, 1, &frameShaderSource, NULL);
    glCompileShader(*shader);
    
    GLint success;
    GLchar infoLog[512];
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &success);
    if(!success)
    {
        glGetShaderInfoLog(*shader, 512, NULL, infoLog);
        NSLog(@"ERROR::SHADER::VERTEX::COMPILATION_FAILED = %s", infoLog);
    }
}
@end
