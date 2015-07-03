//
//  ViewController.m
//  GaussianBlur
//
//  Created by lidehua on 15/7/2.
//  Copyright (c) 2015年 李德华. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self imagePixels];
}
- (void)imagePixels {
    CGImageRef imageRef = _image.image.CGImage;
    CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    UInt8 * pixelBuffer = (UInt8 *)CFDataGetBytePtr(data);
    
    int length = (int)CFDataGetLength(data);
    
    /**
     *    马赛克
     */
    int width = (int)CGImageGetBytesPerRow(imageRef);
    int height = length / width;
    int offset = 10;
    for (int yPosition = 0; yPosition <= height - offset; yPosition += offset) {
        for (int xPosition = 0; xPosition < width - offset*4; xPosition += offset*4) {
            int red = pixelBuffer[width * yPosition + xPosition];
            int green = pixelBuffer[width * yPosition + xPosition + 1];
            int blue = pixelBuffer[width * yPosition + xPosition + 2];
            for (int y = 0; y < offset; y ++) {
                for (int x = 0; x < offset * 4; x += 4) {
                    pixelBuffer[width * (y + yPosition) + x + xPosition] = red;
                    pixelBuffer[width * (y + yPosition) + x + xPosition + 1] = green;
                    pixelBuffer[width * (y + yPosition) + x + xPosition + 2] = blue;
                }
            }
        }
    }
    
    /**
     *    色调/饱和度调整 将RGB转换成HSI
     */
//    int hue = -10;
//    int saturation = -50;
//    int ilumination = -60;
//    for (int i = 0; i < length; i += 4) {
//        int red = pixelBuffer[i] + hue;
//        int green = pixelBuffer[i + 1] + saturation;
//        int blue = pixelBuffer[i + 2] + ilumination;
//        
//        if (red < 0) {
//            red = 0;
//        } else if (red > 180) {
//            red = 180;
//        }
//        if (green < 0) {
//            green = 0;
//        } else if (green > 255) {
//            green = 255;
//        }
//        if (blue < 0) {
//            blue = 0;
//        } else if (blue > 255) {
//            blue = 255;
//        }
//        pixelBuffer[i] = red;
//        pixelBuffer[i + 1] = green;
//        pixelBuffer[i + 2] = blue;
//    }
    
    /**
     *    对比度调整
     */
//    CGFloat contrast = 0.9 * 0.9;
//    for (int i = 0; i < length; i += 4) {
//        int red = ((pixelBuffer[i] / 255.0 - 0.5) * contrast + 0.5) * 255;
//        int green = ((pixelBuffer[i + 1] / 255.0 - 0.5) * contrast + 0.5) * 255;
//        int blue = ((pixelBuffer[i + 2] / 255.0 - 0.5) * contrast + 0.5) * 255;
//        
//        if (red < 0) {
//            red = 0;
//        } else if (red > 255) {
//            red = 255;
//        }
//        if (green < 0) {
//            green = 0;
//        } else if (green > 255) {
//            green = 255;
//        }
//        if (blue < 0) {
//            blue = 0;
//        } else if (blue > 255) {
//            blue = 255;
//        }
//        
//        pixelBuffer[i] = red;
//        pixelBuffer[i + 1] =green;
//        pixelBuffer[i + 2] = blue;
//    }
    
    /**
     *    浮雕处理
     */
//    for (int i = 0; i < length; i += 4) {
//        int red = pixelBuffer[i] - pixelBuffer[i + 4] +128;
//        int green = pixelBuffer[i + 1] - pixelBuffer[i + 5] +128;
//        int blue = pixelBuffer[i + 2] - pixelBuffer[i + 6] +128;
//        
//        int new = red * 0.3 + green * 0.59 + blue * 0.11;
//        
//        pixelBuffer[i] = new;
//        pixelBuffer[i + 1] = new;
//        pixelBuffer[i + 2] = new;
//    }
    
    /**
     *    底片处理
     */
//    for (int i = 0; i < length; i += 4) {
//        int r = i;
//        int g = i + 1;
//        int b = i + 2;
//        
//        pixelBuffer[r] = 255 - pixelBuffer[r];
//        pixelBuffer[g] = 255 - pixelBuffer[g];
//        pixelBuffer[b] = 255 - pixelBuffer[b];
//    }
    
    /**
     *    灰度处理
     */
//    for(int i = 0; i<length;i+=4) {
//        int red = pixelBuffer[i];
//        int green = pixelBuffer[i + 1];
//        int blue = pixelBuffer[i + 2];
//        
//        int new = red * 0.3 + green * 0.59 + blue * 0.11;
//        pixelBuffer[i] = pixelBuffer[i + 1] = pixelBuffer[i + 2] = new;
//    }
    /**
     *    高斯模糊
     */
//    int width = (int)CGImageGetBytesPerRow(imageRef);
//    int height = length / width;
//    CGFloat radius = 5;
//    
//    CGFloat sigma = radius / 3.0;
//    CGFloat sigma2 = 2.0 * sigma * sigma;
//    CGFloat sigmap = sigma2 * M_PI;
//    
//    for (int yPosition = 0 , pixel = 0; yPosition < height; yPosition++) {
//        for (int xPosition = 0; xPosition < width; xPosition += 4 , pixel += 4) {
//            CGFloat red = 0.0 , green = 0.0 , blue = 0.0;
//            for (int  yRadius = - radius; yRadius <= radius; yRadius++) {
//                int yRadius_check = edge(yRadius, yPosition, height);
//                for (int xRadius = - radius * 4; xRadius <= radius * 4; xRadius += 4) {
//                    int xRadius_check = edge(xRadius, xPosition, width);
//                    int pixelPosition = pixel + width * yRadius_check + xRadius_check;
//                    
//                    int i = xRadius / 4;
//                    int j = yRadius;
//                    
//                    CGFloat average = exp(- (i * i + j * j) / sigma2) / sigmap;
//                    
//                    red += pixelBuffer[pixelPosition] * average;
//                    green += pixelBuffer[pixelPosition + 1] * average;
//                    blue += pixelBuffer[pixelPosition + 2] * average;
//                }
//            }
//            pixelBuffer[pixel] = red > 255 ? 255 : red;
//            pixelBuffer[pixel + 1] = green > 255 ? 255 : green;
//            pixelBuffer[pixel + 2] = blue > 255 ? 255 : blue;
//        }
//    }
    
    CGContextRef ctx = CGBitmapContextCreate(pixelBuffer, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef), CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), CGImageGetColorSpace(imageRef), (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGImageRef outImage = CGBitmapContextCreateImage(ctx);
    CFRelease(ctx);
    UIImage * image = [UIImage imageWithCGImage:outImage];
    _image.image = image;
    CFRelease(imageRef);
    CFRelease(data);
}
int edge(int i , int x , int w) {
    int i_k = x + i;
    if (i_k < 0) {
        i_k = -i_k;
    } else if(i_k >= w) {
        i_k = w - 1 - x;
    } else {
        i_k = i;
    }
    return i_k;
}
- (int)getAverangeData:(UInt8 *)data index:(int)index length:(CFIndex)length size:(size_t)size {
    int totalRed = 0;
    int redCount = 0;
    if (index - 4 > 0) {
        totalRed += data[index - 4];
        redCount ++ ;
    }
    if (index - size - 4 > 0) {
        totalRed += data[index - size - 4];
        redCount ++;
    }
    if (index - size > 0) {
        totalRed += data[index - size];
        redCount ++;
    }
    if (index - size + 4 > 0 && index - size + 4 < size) {
        totalRed += data[index - size + 4];
        redCount ++;
    }
    if (index + 4 < size) {
        totalRed += data[index + 4];
        redCount ++;
    }
    if (index + size - 4 > 0 && index + size - 4 < length) {
        totalRed += data[index + size - 4];
        redCount ++;
    }
    if (index + size < length) {
        totalRed += data[index + size];
        redCount ++;
    }
    if (index + size + 4 < length) {
        totalRed += data[index + size + 4];
        redCount ++;
    }
    return totalRed / redCount;
}
@end
