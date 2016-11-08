//
//  KVAnnotationView.m
//  KVAnnotationView
//
//  Created by Vladimir Kalinichenko on 11/4/16.
//  Copyright © 2016 Vladimir Kalinichenko. All rights reserved.
//

#import "KVAnnotationView.h"


@implementation KVAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
                   reuseIdentifier:(NSString *)reuseIdentifier
                           pinView:(UIView *)pinView
                       calloutView:(UIView *)calloutView {

    
    self = [super initWithAnnotation:annotation
                     reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.clipsToBounds = NO;
        self.canShowCallout = NO;
        
        _pinView = pinView;
        self.pinView.userInteractionEnabled = YES;
        _calloutView = calloutView;
        self.calloutView.hidden = YES;
        
        [self addSubview:self.pinView];
        [self addSubview:self.calloutView];
        self.frame = [self calculateFrame];
        [self positionSubviews];
    }
    return self;
}

- (CGRect)calculateFrame {
    return self.pinView.bounds;
}

- (void)setCalloutOffset:(CGPoint)calloutOffset {
    [super setCalloutOffset:calloutOffset];
    [self positionSubviews];
}

- (void)positionSubviews {
    
    self.pinView.center = self.center;
    if (_calloutView) {
        CGRect frame = self.calloutView.frame;
        frame.origin.x = (self.frame.size.width - frame.size.width) / 2.0 + self.calloutOffset.x;
        frame.origin.y = -frame.size.height + self.calloutOffset.y;
        self.calloutView.frame = frame;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_calloutView) {
        if([self.delegate respondsToSelector:@selector(annotationView:asksToHideCalloutView:)]) {
            [self.delegate annotationView:self asksToHideCalloutView:self.calloutView];
        }
    }
}

- (void)hideCalloutView {
    
    // you can just keep those two lines to hide callout view withour animation
    //
    // [self.calloutView setHidden:YES];
    // self.layer.zPosition = -1;
    
    self.calloutView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1, 1), 0, 0);
    CGFloat calloutHeight = self.calloutView.bounds.size.height;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.calloutView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(0.1, 0.1), 0, - calloutHeight * 5);
    } completion:^(BOOL finished) {
        [self.calloutView setHidden:YES];
        self.layer.zPosition = -1;
    }];
}

- (void)showCalloutView {
    
    // you can just keep those two lines to hide callout view withour animation
    //
    // [self.calloutView setHidden:NO];
    // self.layer.zPosition = 0;
    
    CGFloat calloutHeight = self.calloutView.bounds.size.height;
    self.calloutView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(0.1, 0.1), 0, - calloutHeight * 5);
    
    
    [self.calloutView setHidden:NO];
    [UIView animateWithDuration:0.2f animations:^{
        self.calloutView.transform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1, 1), 0, 0);
    }completion:^(BOOL finished) {
        self.layer.zPosition = 0;
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self)
        return nil;
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL isCallout = (CGRectContainsPoint(self.calloutView.frame, point));
    BOOL isPin = (CGRectContainsPoint(self.pinView.frame, point));
    return isCallout || isPin;
}

@end
