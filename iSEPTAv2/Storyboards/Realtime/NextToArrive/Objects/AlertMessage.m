//
//  AlertMessage.m
//  iSEPTA
//
//  Created by septa on 4/9/15.
//  Copyright (c) 2015 SEPTA. All rights reserved.
//

#import "AlertMessage.h"

@implementation AlertMessage

@synthesize attrText;
//@synthesize height;
@synthesize rect;
@synthesize text;

-(void) updateAttrText
{
    
    // Check if message was "RRD: Trains experencing", vs.  "Bus experiencing"
    NSRange endRange = [self.text rangeOfString:@":"];
    
    NSString *title = @"";
    NSString *message  = @"";
    
    if (endRange.location != NSNotFound && endRange.location < 5)
    {  // Highlight everything up to the ':' and hope the alert is never "Things not to bold: this message, things already bolded, your momma"
        title = [self.text substringToIndex:endRange.location+1];
        message = [self.text substringFromIndex:endRange.location+2];
    }
    else
    {
        message = self.text;
    }
    
    UIFont *boldFont    = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14.0];
    UIFont *defaultFont = [UIFont fontWithName:@"Trebuchet MS"      size:14.0];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    [paraStyle setLineSpacing:24.0f];
    //    [paraStyle setLineHeightMultiple:0.85f];
    
    //    NSDictionary *titleDict = [NSDictionary dictionaryWithObject: boldFont forKey:NSFontAttributeName];
    
    // Bold the title, if ony exists.
    NSDictionary *titleDict = [NSDictionary dictionaryWithObjectsAndKeys:boldFont, NSFontAttributeName, paraStyle, NSParagraphStyleAttributeName, nil];
    NSMutableAttributedString *titleAttrString = [[NSMutableAttributedString alloc] initWithString:title attributes: titleDict];
    
    //
    NSDictionary *textDict = [NSDictionary dictionaryWithObject:defaultFont forKey:NSFontAttributeName];
    NSMutableAttributedString *textAttrString = [[NSMutableAttributedString alloc]initWithString: message attributes:textDict];
    [textAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:(NSMakeRange(0, endRange.length))];
    
    [titleAttrString appendAttributedString:textAttrString];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;  // Take the same space off as the formatCell method
    CGRect thisRect = [titleAttrString boundingRectWithSize:CGSizeMake(width,9999) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  context:nil];
    
    
    // Now update the rect and attrText
    self.rect = NSStringFromCGRect(thisRect);
    self.attrText = titleAttrString;
    
}

-(NSString*) description
{
    return [NSString stringWithFormat:@"text: %@, rect: %@", self.text, self.rect];
}

@end
