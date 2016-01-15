//
//  ImageViewController.m
//  DecoCamera
//
//  Created by tgaiacontentsdev on 2016/01/14.
//  Copyright © 2016年 tgaiacontentsdev. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@property(weak,nonatomic) IBOutlet UIImageView *imageView;

@property(weak,nonatomic) IBOutlet UIButton *grayButton;
@property(assign,nonatomic) BOOL isGray;

-(IBAction)saveButtonAction:(id)sender;
-(IBAction)grayButtonAction:(id)sender;
-(IBAction)backButtonaction:(id)sender;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView.image = self.editImage;
    self.isGray = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveButtonAction:(id)sender{
    
    SEL selector = @selector(onCompleteCapture:didFinishSavingWithError:contextInfo:);
    
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, selector, NULL);
    
}

-(void)onCompleteCapture:(UIImage *)screenImage didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"保存終了" message:@"画像を保存しました" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(IBAction)grayButtonAction:(id)sender{
    self.isGray = !self.isGray;
    
    if (self.isGray) {
        [self.grayButton setTitle:@"Reset" forState:UIControlStateNormal];
        
        UIImage *image = self.editImage;
        CGRect imageRect = (CGRect){0.0,0.0,image.size.width,image.size.height};
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        
        CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
        
        CGContextDrawImage(context, imageRect, [image CGImage]);
        
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        
        UIImage *grayScaleImage = [UIImage imageWithCGImage:imageRef];
        
        //メモリ解放
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
        CFRelease(imageRef);
        
        self.imageView.image = grayScaleImage;
        
    }else{
        
        self.grayButton.titleLabel.text = @"Gray";
        [self.grayButton setTitle:@"Gray" forState:UIControlStateNormal];
        
        self.imageView.image = self.editImage;
    }
    
}

-(IBAction)backButtonaction:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
