/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2014 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "NimbusLabelLabel.h"
#import "TiUtils.h"
#import "TiViewProxy.h"

@implementation NimbusLabelLabel

-(id)init
{
    if (self = [super init]) {
        initialLabelFrame = CGRectZero;
    }
    return self;
}

-(void)dealloc
{
// using ARC for this module, so RELEASE_TO_NIL doesn't fly
//    RELEASE_TO_NIL(label);
}

-(void)initializeState
{
    [self label];
}

-(NIAttributedLabel*)label
{
	if (label==nil)
	{
        label = [[NIAttributedLabel alloc] initWithFrame:CGRectZero];
//        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.autoDetectLinks = NO;
        label.userInteractionEnabled = YES; // is automatic for labels that have links, but we want labels to always be tapable and send an event back

        [self addSubview:label];
        label.delegate = self;
	}
	return label;
}

-(void)createView
{
    [self label];
}

-(CGFloat)contentWidthForWidth:(CGFloat)suggestedWidth
{
    /*
     Why both? sizeThatFits returns the width with line break mode tail truncation and we like to
     have atleast enough space to display one word. On the otherhand font measurement is unsuitable for
     attributed strings till we move to the new measurement API. Hence take both and return MAX.
     */
    CGFloat sizeThatFitsResult = [[self label] sizeThatFits:CGSizeMake(suggestedWidth, 0)].width;
	return sizeThatFitsResult;
}

-(CGFloat)contentHeightForWidth:(CGFloat)width
{
	return [[self label] sizeThatFits:CGSizeMake(width, 0)].height;
}

//-(CGRect)padLabel
-(void)padLabel
{
    CGSize textSize = [[self label] sizeThatFits:CGSizeMake(initialLabelFrame.size.width, CGFLOAT_MAX)];
    _contentHeight = textSize.height;
    CGRect labelRect = CGRectMake(0, 0, initialLabelFrame.size.width, textSize.height);
    [label setFrame:CGRectIntegral(labelRect)];

//	return labelRect;
}


-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    initialLabelFrame = bounds;

    if (label!=nil)
    {
		[TiUtils setView:[self label] positionRect:bounds];
        [self padLabel];
    }
	[super frameSizeChanged:frame bounds:bounds];
}

-(CGFloat)autoHeightForWidth:(CGFloat)value
{
	return _contentHeight;
}

-(CGFloat)autoWidthForWidth:(CGFloat)value
{
	return value;
}

-(float)currentContentHeight:(CGFloat) width
{
//	if (_contentHeight == 0) {
//		_contentHeight = [[self label] sizeThatFits:CGSizeMake(width, 0)].height;
//	}
//	return _contentHeight;
	return [[self label] sizeThatFits:CGSizeMake(width, 0)].height;
}

-(void)setAttributedText_:(id)object
{
    NSDictionary *attributes = [object objectForKey:@"attributes"];

    NSMutableAttributedString* textString = [[NSMutableAttributedString alloc] initWithString:[TiUtils stringValue:[object objectForKey:@"text"]]];
	
	[self label].numberOfLines = [TiUtils intValue:[object objectForKey:@"numberOfLines"]];
	label.numberOfLines = [TiUtils intValue:[object objectForKey:@"numberOfLines"]];

    for (NSDictionary * object in attributes) {
        NSString* type = [TiUtils stringValue:[object objectForKey:@"type"]];
        if ([type isEqualToString:@"font"])
        {

//            UIFont * font = [[TiUtils fontValue:[object objectForKey:@"value"]] font]; // slow as you know what...

			NSDictionary *fontDict = [object objectForKey:@"value"];
			id familyObject = [fontDict objectForKey:@"fontFamily"];
			id sizeObject = [fontDict objectForKey:@"fontSize"];
			if([sizeObject isKindOfClass:[NSString class]]){
				sizeObject = [sizeObject lowercaseString];
				if([sizeObject hasSuffix:@"px"]){
					sizeObject = [sizeObject substringToIndex:[sizeObject length]-2];
				}
			}
			UIFont *font = [UIFont fontWithName: familyObject size: [sizeObject floatValue]];
            int start = [TiUtils intValue:[object objectForKey:@"start"]] ;
            int length = [TiUtils intValue:[object objectForKey:@"length"]] ;
            [textString setFont:font range:NSMakeRange(start,length)];
        }else if ([type isEqualToString:@"color"])
        {
            UIColor *color = [[TiUtils colorValue:[object objectForKey:@"value"]] color];
            int start = [TiUtils intValue:[object objectForKey:@"start"]] ;
            int length = [TiUtils intValue:[object objectForKey:@"length"]] ;
            [textString setTextColor:color range:NSMakeRange(start,length)];
        }else if ([type isEqualToString:@"link"])
        {
            NSString* url = [TiUtils stringValue:[object objectForKey:@"value"]];
            int start = [TiUtils intValue:[object objectForKey:@"start"]] ;
            int length = [TiUtils intValue:[object objectForKey:@"length"]] ;
            NSRange range = NSMakeRange(start,length);
			NSURL *theUrl = [[NSURL alloc] initWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSTextCheckingResult* result = [NSTextCheckingResult linkCheckingResultWithRange:range URL:theUrl];
//            NSTextCheckingResult* result = [NSTextCheckingResult linkCheckingResultWithRange:range URL:[NSURL URLWithString:url]];
            [textString addAttribute:NIAttributedLabelLinkAttributeName value:result range:range];
        }
    }
    [[self label] setAttributedText: textString];
	[[self label] sizeToFit];

    [self padLabel];
    [(TiViewProxy *)[self proxy] contentsWillChange];
}

-(void)setNumberOfLines_:(id)lines
{
	[self label].numberOfLines = [TiUtils intValue: lines];
}

-(void)setTextAlignment_:(id)alignment
{
	[[self label] setTextAlignment:[TiUtils intValue:alignment]];
}

-(void)setTextColor_:(id)color
{
    [[self label] setTextColor:[[TiUtils colorValue: color] color]];
}

-(void)setLinkColor_:(id)color
{
    [[self label] setLinkColor:[[TiUtils colorValue: color] color]];
}

-(void)setHighlightedLinkBackgroundColor_:(id)color
{
    [[self label] setHighlightedLinkBackgroundColor: [[TiUtils colorValue: color] color]];
}

// this is a user tap on a link, fireEvent 'click' back to appcelerator
- (void)attributedLabel:(NIAttributedLabel*)attributedLabel didSelectTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point {
    [self.proxy fireEvent:@"singletouch" withObject:@{
        @"url": result != nil && [result.URL absoluteString] != nil ? [[result.URL absoluteString] stringByRemovingPercentEncoding] : @"",
        @"x": [NSNumber numberWithFloat:point.x],
        @"y": [NSNumber numberWithFloat:point.y],
    } propagate:NO];
}

// this is esentially a long press on a link, fireEvent 'longpress' back to appcelerator
- (BOOL)attributedLabel:(NIAttributedLabel *)attributedLabel shouldPresentActionSheet:(UIActionSheet *)actionSheet withTextCheckingResult:(NSTextCheckingResult *)result atPoint:(CGPoint)point {
    [self.proxy fireEvent:@"tapandhold" withObject:@{
        @"url": result != nil && [result.URL absoluteString] != nil ? [[result.URL absoluteString] stringByRemovingPercentEncoding] : @"",
        @"x": [NSNumber numberWithFloat:point.x],
        @"y": [NSNumber numberWithFloat:point.y],
    } propagate:YES];
    return NO;
}
@end
