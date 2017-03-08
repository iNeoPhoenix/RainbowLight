//
//  MyView.m
//  Rainbow Light
//
//  Created by Stéphane Chrétien on 29/03/09.
//  Copyright 2009 NeoPhoenix. All rights reserved.
//

#import "MyView.h"
#import "Notification.h"

@implementation MyView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	m_ZoomInProgress = NO;
	
	NSSet* allTouches = [event allTouches];
	NSArray* allObjects = [allTouches allObjects];
	NSUInteger count = [allObjects count];
	
	if (count >= 2) {
		UITouch* firstFinger = [allObjects objectAtIndex:0];
		CGPoint firstFingerPosition = [firstFinger locationInView:self];
		UITouch* secondFinger = [allObjects objectAtIndex:1];
		CGPoint secondFingerPosition = [secondFinger locationInView:self];
		
		m_PreviousDistance = [self distanceBetweenFirstPoint:firstFingerPosition andSecondPoint:secondFingerPosition];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSSet* allTouches = [event allTouches];
	NSArray* allObjects = [allTouches allObjects];
	NSUInteger count = [allObjects count];
	
	if (count >= 2) {
		m_ZoomInProgress = YES;
		
		UITouch* firstFinger = [allObjects objectAtIndex:0];
		CGPoint firstFingerPosition = [firstFinger locationInView:self];
		UITouch* secondFinger = [allObjects objectAtIndex:1];
		CGPoint secondFingerPosition = [secondFinger locationInView:self];
		
		CGFloat distance = [self distanceBetweenFirstPoint:firstFingerPosition andSecondPoint:secondFingerPosition];
		if (distance > m_PreviousDistance)
			[[NSNotificationCenter defaultCenter] postNotificationName:moreLUXNotification object:nil];
		else
			[[NSNotificationCenter defaultCenter] postNotificationName:lessLUXNotification object:nil];
		
		m_PreviousDistance = distance;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSUInteger numTaps = [[touches anyObject] tapCount];
	if (numTaps == 1 && m_ZoomInProgress == NO)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:playPauseNotification object:nil];
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

- (CGFloat) distanceBetweenFirstPoint:(CGPoint)firstPoint andSecondPoint:(CGPoint) secondPoint {
	CGFloat distance;
	
	//Square difference in x
	CGFloat xDifferenceSquared = pow(firstPoint.x - secondPoint.x, 2);
	// NSLog(@"xDifferenceSquared: %f", xDifferenceSquared);
	
	// Square difference in y
	CGFloat yDifferenceSquared = pow(firstPoint.y - secondPoint.y, 2);
	// NSLog(@"yDifferenceSquared: %f", yDifferenceSquared);
	
	// Add and take Square root
	distance = sqrt(xDifferenceSquared + yDifferenceSquared);
	// NSLog(@"Distance: %f", distance);
	return distance;
	
}

- (void)dealloc {
    [super dealloc];
}


@end
