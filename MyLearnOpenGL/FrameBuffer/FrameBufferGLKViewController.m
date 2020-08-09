//
//  FrameBufferGLKViewController.m
//  MyLearnOpenGL
//
//  Created by 萧锐杰 on 2020/8/9.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "FrameBufferGLKViewController.h"

@interface FrameBufferGLKViewController ()

@property (nonatomic , strong) EAGLContext* context;

@property (nonatomic , strong) GLKBaseEffect* effect;
@property (nonatomic , strong) GLKBaseEffect* showEffect;

@property (nonatomic , assign) GLint defaultFBO;

@property (nonatomic , assign) GLuint pictureFBO;
@property (nonatomic , assign) GLuint pictureFBOTexture;

@property (nonatomic , assign) GLuint filterFBO;
@property (nonatomic , assign) GLuint filterFBOTexture;




@end

@implementation FrameBufferGLKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupContext];
    [self setupVBO];
    [self setupFBO];
}

- (void)setupContext {
    
    //新建OpenGLES 上下文
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    GLKView* view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:self.context];
}

- (void)setupVBO {
    

    //顶点数据，前三个是顶点坐标， 中间三个是顶点颜色，    最后两个是纹理坐标
    GLfloat attrArr[] =
    {
        -1.0f, 1.0f, 0.0f,      0.0f, 0.0f, 1.0f,       0.0f, 1.0f,//左上
        1.0f, 1.0f, 0.0f,       0.0f, 1.0f, 0.0f,       1.0f, 1.0f,//右上
        -1.0f, -1.0f, 0.0f,     1.0f, 0.0f, 1.0f,       0.0f, 0.0f,//左下
        1.0f, -1.0f, 0.0f,      0.0f, 0.0f, 1.0f,       1.0f, 0.0f,//右下
    };
    //顶点索引
    GLuint indices[] =
    {
        0, 2, 3,
        0, 1, 3,
    };
    
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(attrArr), attrArr, GL_STATIC_DRAW);
    
    GLuint index;
    glGenBuffers(1, &index);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, index);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 8, (GLfloat *)NULL);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 4 * 8, (GLfloat *)NULL + 6);
    
    self.effect = [[GLKBaseEffect alloc] init];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"IMG_8154" ofType:@"JPG"];

    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];
    
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    self.effect.texture2d0.enabled = GL_TRUE;
    self.effect.texture2d0.name = textureInfo.name;
    
    self.showEffect = [[GLKBaseEffect alloc] init];
    self.effect.texture2d0.enabled = GL_TRUE;
}

- (void)setupFBO {
    
    int width, height;
    width = self.view.bounds.size.width * self.view.contentScaleFactor;
    height = self.view.bounds.size.height * self.view.contentScaleFactor;
    [self generateFBOWithFBO:&_pictureFBO texture:&_pictureFBOTexture width:width height:height];
    [self generateFBOWithFBO:&_filterFBO texture:&_filterFBOTexture width:width height:height];
}

- (void)generateFBOWithFBO:(GLuint*)fbo texture:(GLuint*)texture width:(GLuint)width height:(GLuint)height {
    
    
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &_defaultFBO);
    glGenTextures(1, texture);
    NSLog(@"render texture %d", *texture);
    glGenFramebuffers(1, fbo);
    glBindFramebuffer(GL_FRAMEBUFFER, *fbo);
    glBindTexture(GL_TEXTURE_2D, *texture);
    
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_RGBA,
                 width,
                 height,
                 0,
                 GL_RGBA,
                 GL_UNSIGNED_BYTE,
                 NULL);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    
    
    glFramebufferTexture2D(GL_FRAMEBUFFER,
                           GL_COLOR_ATTACHMENT0,
                           GL_TEXTURE_2D, *texture, 0);
    
    GLenum status;
    status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    switch(status) {
        case GL_FRAMEBUFFER_COMPLETE:
            NSLog(@"fbo complete width %d height %d", width, height);
            break;
            
        case GL_FRAMEBUFFER_UNSUPPORTED:
            NSLog(@"fbo unsupported");
            break;
            
        default:
            NSLog(@"Framebuffer Error");
            break;
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, self.defaultFBO);
    glBindTexture(GL_TEXTURE_2D, 0);
}


- (void)renderPicture {
    
    glBindTexture(GL_TEXTURE_2D, 0);
    glBindFramebuffer(GL_FRAMEBUFFER, self.pictureFBO);
    

    glClearColor(0.1f, 0.1f, 0.1f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.effect prepareToDraw];
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
    
    glBindFramebuffer(GL_FRAMEBUFFER, self.defaultFBO);
    
    self.showEffect.texture2d0.name = self.pictureFBOTexture;
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    [self renderPicture];
    
    [((GLKView *) self.view) bindDrawable];
    
    
    //    glViewport() 见上面
    glClearColor(0.3, 0.3, 0.3, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
//
    [self.showEffect prepareToDraw];
    glDrawElements(GL_TRIANGLES, 5, GL_UNSIGNED_INT, 0);
    
    
//    [_context presentRenderbuffer:GL_RENDERBUFFER];//方法
    

    
//    //    glViewport() 见上面
//    glClearColor(0.3, 0.3, 0.3, 1);
//    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//
//    glDrawElements(GL_TRIANGLES, self.mCount, GL_UNSIGNED_INT, 0);
}

@end
