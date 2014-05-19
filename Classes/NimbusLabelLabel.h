/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2014 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiUIView.h"
#import "NimbusAttributedLabel.h"
#import "NSMutableAttributedString+NimbusAttributedLabel.h"

@interface NimbusLabelLabel : TiUIView <NIAttributedLabelDelegate, LayoutAutosizing> {
@private
	NIAttributedLabel *label;
    CGRect initialLabelFrame;
    float _contentHeight;
}

-(void)createView;
-(float)currentContentHeight:(CGFloat) width;

@end
