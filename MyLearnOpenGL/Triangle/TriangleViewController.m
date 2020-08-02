//
//  TriangleViewController.m
//  MyLearnOpenGL
//
//  Created by 萧锐杰 on 2020/8/1.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "TriangleViewController.h"

@interface TriangleViewController ()

@property (nonatomic , strong) EAGLContext* mContext;

@end

@implementation TriangleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConfig];
    [self uploadVertexArray];
}

- (void)setupConfig {
    //新建OpenGLES 上下文
    self.mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]; //2.0，还有1.0和3.0
    GLKView* view = (GLKView *)self.view; //storyboard记得添加
    view.context = self.mContext;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;  //颜色缓冲区格式
    [EAGLContext setCurrentContext:self.mContext];
}

- (void)uploadVertexArray {
    
    GLfloat vertices[] = {
        -0.5f, -0.5f, 0.0f,//（一行对应顶点着色器的顶点属性，glVertexAttribPointer告诉opengl如何解析一行顶点数据）
        0.5f, -0.5f, 0.0f,
        0.0f,  0.5f, 0.0f
    };
    
    //创建顶点缓冲对象
    GLuint VBO;
    glGenBuffers(1, &VBO);
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO);

    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    //编译定点着色器
    GLuint vertexShader;
    vertexShader = glCreateShader(GL_VERTEX_SHADER);
    
    NSString* vertFile = [[NSBundle mainBundle] pathForResource:@"TriangleShader" ofType:@"vsh"];
    NSString* content = [NSString stringWithContentsOfFile:vertFile encoding:NSUTF8StringEncoding error:nil];
    const GLchar* vertexShaderSource = (GLchar *)[content UTF8String];
    
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);
    
    GLint success;
    GLchar infoLog[512];
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
    if(!success)
    {
        glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
        NSLog(@"ERROR::SHADER::VERTEX::COMPILATION_FAILED = %s", infoLog);
    }
    
    //编片段着色器
    GLuint fragmentShader;
    fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    
    NSString* frameFile = [[NSBundle mainBundle] pathForResource:@"TriangleShader" ofType:@"fsh"];
    NSString* content2 = [NSString stringWithContentsOfFile:frameFile encoding:NSUTF8StringEncoding error:nil];
    const GLchar* frameShaderSource = (GLchar *)[content2 UTF8String];
    
    glShaderSource(fragmentShader, 1, &frameShaderSource, NULL);
    glCompileShader(fragmentShader);
    
    
    glGetShaderiv(fragmentShader, GL_COMPILE_STATUS, &success);
    if(!success)
    {
        glGetShaderInfoLog(fragmentShader, 512, NULL, infoLog);
        NSLog(@"ERROR::SHADER::VERTEX::COMPILATION_FAILED = %s", infoLog);
    }
    

    
    //着色器程序
    GLuint shaderProgram;
    shaderProgram = glCreateProgram();
    
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    glLinkProgram(shaderProgram);
    
    glGetProgramiv(shaderProgram, GL_LINK_STATUS, &success);
    if(!success) {
        glGetProgramInfoLog(shaderProgram, 512, NULL, infoLog);
        NSLog(@"ERROR::SHADER::VERTEX::COMPILATION_FAILED = %s", infoLog);
    }
    
    glUseProgram(shaderProgram);
    
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    

    
}

#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
    /*
     * glEnableVertexAttribArray(GLuint index)
     * 启动某项缓存的渲染操作（GLKVertexAttribPosition | GLKVertexAttribNormal | GLKVertexAttribTexCoord0 | GLKVertexAttribTexCoord1）
     * GLKVertexAttribPosition 用于顶点数据
     * GLKVertexAttribNormal 用于法线
     * GLKVertexAttribTexCoord0 与 GLKVertexAttribTexCoord1 均为纹理
     */
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //glEnableVertexAttribArray(0);

    //链接顶点属性
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), (GLvoid*)0);
    
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
}


@end
