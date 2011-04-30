//
//  UnderlineLabel.m
//  ExchangeSynchronizer
//
//  Created by Илья on 29.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UnderlineLabel.h"


@implementation UnderlineLabel
-(void)setComplete:(BOOL)animated
{
	complete = animated;
}
- (void)drawRect:(CGRect)rect 
{
	if(complete)
	{
		// Get the Render Context
		CGContextRef ctx = UIGraphicsGetCurrentContext();
	
		// Measure the font size, so the line fits the text.
		// Could be that "titleLabel" is something else in other classes like UILable, dont know.
		// So make sure you fix it here if you are enhancing UILabel or something else..
		CGSize fontSize =[self.text sizeWithFont:self.font 
											   forWidth:self.bounds.size.width
										  lineBreakMode:UILineBreakModeTailTruncation];

		// Sets the color to draw the line
		CGContextSetRGBStrokeColor(ctx, 0.0f, 0.0f, 0.0f, 1.0f);// Format : RGBA
	
		// Line Width : make thinner or bigger if you want
		CGContextSetLineWidth(ctx, 2.0f);
	
		// Calculate the starting point (left) and target (right)	
		float fontLeft = rect.origin.x;
		float fontRight =  + fontSize.width;
	
		// Add Move Command to point the draw cursor to the starting point
		CGContextMoveToPoint(ctx, fontLeft, self.bounds.size.height/2.0);
		
		// Add Command to draw a Line
		CGContextAddLineToPoint(ctx, fontRight, self.bounds.size.height/2.0);
	
		// Actually draw the line.
		CGContextStrokePath(ctx);
	}
	// should be nothing, but who knows...
	[super drawRect:rect];   
}@end
