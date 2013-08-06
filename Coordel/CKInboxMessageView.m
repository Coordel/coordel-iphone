//
//  CKInboxMessageView.m
//  Coordel iPhone
//
//  Created by Jeffry Gorder on 8/3/13.
//  Copyright (c) 2013 Jeffry Gorder. All rights reserved.
//

#import "CKInboxMessageView.h"
#include <MailCore/MailCore.h>

@interface CKInboxMessageView () <MCOHTMLRendererIMAPDelegate>



@property UIWebView *webView;
@property id <MCOMessageViewDelegate> _delegate;

@end

@implementation CKInboxMessageView

static NSString * mainJavascript = @"\
var imageElements = function() {\
var imageNodes = document.getElementsByTagName('img');\
return [].slice.call(imageNodes);\
};\
\
var findCIDImageURL = function() {\
var images = imageElements();\
\
var imgLinks = [];\
for (var i = 0; i < images.length; i++) {\
var url = images[i].getAttribute('src');\
if (url.indexOf('cid:') == 0 || url.indexOf('x-mailcore-image:') == 0)\
imgLinks.push(url);\
}\
return JSON.stringify(imgLinks);\
};\
\
var replaceImageSrc = function(info) {\
var images = imageElements();\
\
for (var i = 0; i < images.length; i++) {\
var url = images[i].getAttribute('src');\
if (url.indexOf(info.URLKey) == 0) {\
images[i].setAttribute('src', info.LocalPathKey);\
break;\
}\
}\
};\
";

static NSString * mainStyle = @"\
body {\
font-family: Helvetica;\
font-size: 14px;\
word-wrap: break-word;\
-webkit-text-size-adjust:none;\
-webkit-nbsp-mode: space;\
}\
\
pre {\
white-space: pre-wrap;\
}\
";


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _webView = [[UIWebView alloc] initWithFrame:[self bounds]];
        [_webView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
        [_webView setDelegate:self];
        [self addSubview:_webView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void) refresh
{
    NSString * content;
    
    if (_message == nil) {
        content = nil;
    }
    else {
        if ([_message isKindOfClass:[MCOIMAPMessage class]]) {
            content = [(MCOIMAPMessage *) _message htmlRenderingWithFolder:_folder delegate:self];
        }
        else if ([_message isKindOfClass:[MCOMessageBuilder class]]) {
            content = [(MCOMessageBuilder *) _message htmlRenderingWithDelegate:self];
        }
        else if ([_message isKindOfClass:[MCOMessageParser class]]) {
            content = [(MCOMessageParser *) _message htmlRenderingWithDelegate:self];
        }
        else {
            content = nil;
            MCAssert(0);
        }
    }
	if (content == nil) {
		[_webView loadHTMLString:@"" baseURL:nil];
		return;
	}
	
	NSMutableString * html = [NSMutableString string];
    [html appendFormat:@"<html><head><script>%@</script><style>%@</style></head>"
     @"<body>%@</body><iframe src='x-mailcore-msgviewloaded:' style='width: 0px; height: 0px; border: none;'>"
     @"</iframe></html>", mainJavascript, mainStyle, content];
	[_webView loadHTMLString:html baseURL:nil];
}


@end
