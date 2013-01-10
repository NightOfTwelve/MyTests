//
//  KPLabel.m
//  AABabyTing3
//
//  Created by Zero on 11/6/12.
//
//

#import "KPLabel.h"

@implementation KPLabel

+ (TTTAttributedLabel *)labelWithFrame:(CGRect)frame text:(NSString *)text keyword:(NSString *)keyword {
	UIFont *font = [UIFont boldSystemFontOfSize:17];
	TTTAttributedLabel *label = [self labelWithFrame:frame andText:text font:font color:[UIColor brownColor] andKeyword:keyword font:font color:[UIColor redColor]];
	return label;
}

+ (TTTAttributedLabel *)categoryLabelWithFrame:(CGRect)frame text:(NSString *)text keyword:(NSString *)keyword {
	UIFont *font = [UIFont boldSystemFontOfSize:12];
	TTTAttributedLabel *label = [self labelWithFrame:frame andText:text font:font color:[UIColor brownColor] andKeyword:keyword font:font color:[UIColor redColor]];
	return label;
}

+ (TTTAttributedLabel *)labelWithFrame:(CGRect)frame andText:(NSString *)text font:(UIFont *)textFont color:(UIColor *)textColor andKeyword:(NSString *)keyword font:(UIFont *)keyFont color:(UIColor *)keyColor {
	CDLog(BTDFLAG_KPLABEL,@"keyword:%@",keyword);
	TTTAttributedLabel *label = [[[TTTAttributedLabel alloc] initWithFrame:frame] autorelease];
	label.font = textFont;
	label.textColor = textColor;
	if (keyword==nil || keyword.length==0) {
		CELog(BTDFLAG_KPLABEL,@"return a no-keyword-label");
		[label setText:text];
		return label;
	}
	[label setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
		for (int i=0; i<text.length; i++) {
			NSString *oneChar = [text substringWithRange:NSMakeRange(i, 1)];
			CVLog(BTDFLAG_KPLABEL,@"text[%d]:%@",i,oneChar);
			//			NSRange keyRange = [[mutableAttributedString string] rangeOfString:key];
			NSRange keyRange = [keyword rangeOfString:oneChar];
			CVLog(BTDFLAG_KPLABEL,@"keyRange:%@",NSStringFromRange(keyRange));
			if (keyword.length>0 && keyRange.location != NSNotFound) {
				CVLog(BTDFLAG_KPLABEL,@"++");
				CTFontRef font = CTFontCreateWithName((CFStringRef)keyFont.fontName, keyFont.pointSize, NULL);
				if (font) {
					[mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[keyColor CGColor] range:NSMakeRange(i, 1)];
					CFRelease(font);
				}
			}
		}
//        CDLog(BTDFLAG_ALWAYS_PRINT,@"%p",mutableAttributedString);
		return mutableAttributedString;
	}];
	return label;
}

@end
