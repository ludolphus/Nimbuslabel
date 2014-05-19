/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2014 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "NimbusLabelLabelProxy.h"
#import "TiUtils.h"

@implementation NimbusLabelLabelProxy

-(void)_initWithProperties:(NSDictionary *)properties
{
    [super _initWithProperties:properties];
}

-(void)viewDidAttach
{
    [(NimbusLabelLabel*)[self view] createView];
}

// The following is to support the new layout in TiSDK
-(CGFloat)contentHeightForWidth:(CGFloat)value
{
    float height = [((NimbusLabelLabel*)[self view]) currentContentHeight:value];
    if (height > 1) {
        return height;
    }
	return 1;
}

// The following is to support the old layout in prior versions of TiSDK
-(CGFloat)autoHeightForWidth:(CGFloat)suggestedWidth
{
    return [self contentHeightForWidth:suggestedWidth];
}

@end
