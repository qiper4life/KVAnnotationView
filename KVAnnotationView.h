//
//  KVAnnotationView.h
//  KVAnnotationView
//
//  Created by Vladimir Kalinichenko on 11/4/16.
//  Copyright © 2016 Vladimir Kalinichenko. All rights reserved.
//

#import <MapKit/MapKit.h>

@protocol KVAnnotationViewDelegate;

@interface KVAnnotationView : MKAnnotationView

@property (nonatomic, weak) id<KVAnnotationViewDelegate> delegate;
@property (nonatomic, strong, readonly) UIView *pinView;
@property (nonatomic, strong, readonly) UIView *calloutView;

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
                   reuseIdentifier:(NSString *)reuseIdentifier
                           pinView:(UIView *)pinView
                       calloutView:(UIView *)calloutView;

- (void)hideCalloutView;
- (void)showCalloutView;

@end

@protocol KVAnnotationViewDelegate <NSObject>

- (void)annotationView:(KVAnnotationView *)annotationView asksToHideCalloutView:(UIView *)calloutView;

@end
