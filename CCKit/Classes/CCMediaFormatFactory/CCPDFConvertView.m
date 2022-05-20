//
//  CCPDFConvertView.m
//
//  Created by lucc on 2022/5/18.
//

#import "CCPDFConvertView.h"
#import "CCFormatWebView.h"

@interface CCPDFConvertView ()<WKNavigationDelegate>
@property (nonatomic, strong) CCFormatWebView *webView;
@property (strong, nonatomic) UIActivityIndicatorView *indictorView;
@end

@implementation CCPDFConvertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.webView];
        [self addSubview:self.indictorView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame fileUrl:(NSURL *)fileUrl {
    self = [super initWithFrame:frame];
    if (self) {
        _fileUrl = fileUrl;
        [self addSubview:self.webView];
        [self.webView loadRequest:[NSURLRequest requestWithURL:fileUrl]];
        [self addSubview:self.indictorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.webView.frame = self.bounds;
    self.indictorView.center = self.center;
}

- (BOOL)convertToPdf:(NSString *)outputPath {
    NSData *data = [self.webView convert2PDFData];
    BOOL ret = [data writeToFile:outputPath atomically:YES];
    return ret;
}

- (BOOL)convertToImage:(NSString *)outputPath {
    UIImage *img = [self.webView convert2Image];
    NSData *imgData = UIImagePNGRepresentation(img);
    BOOL ret = [imgData writeToFile:outputPath atomically:YES];
    return ret;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [self.indictorView startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self.indictorView stopAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.indictorView stopAnimating];
    if (error) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"加载文件失败";
        label.frame = CGRectMake(0, 0, 320, 20);
        label.center = self.center;
        [self addSubview:label];
    }
}

#pragma mark - Setter

- (void)setFileUrl:(NSURL *)fileUrl {
    _fileUrl = fileUrl;
    [self.webView loadRequest:[NSURLRequest requestWithURL:fileUrl]];
}

#pragma mark - Getter

- (CCFormatWebView *)webView {
    if (!_webView) {
        _webView = [[CCFormatWebView alloc] initWithFrame:CGRectZero];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (UIActivityIndicatorView *)indictorView{
    if (!_indictorView) {
        _indictorView = [[UIActivityIndicatorView alloc] init];
        _indictorView.center = self.center;
        _indictorView.bounds = CGRectMake(0, 0, 50, 50);
        _indictorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }return _indictorView;
}

@end
