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

- (BOOL)convertToPdf:(NSString *)outputPath pageRect:(CGRect)pageRect pageInset:(UIEdgeInsets)pageInset {
    NSData *data = [self.webView convert2PDFData:pageRect pageInset:pageInset];
    BOOL ret = [data writeToFile:outputPath atomically:YES];
    return ret;
}

- (void)convertToPdf:(NSString *)outputPath pageRect:(CGRect)pageRect pageInset:(UIEdgeInsets)pageInset completion:(void(^)(BOOL finished))completion {
    [self.webView convert2PDFData:CGRectMake(0, 0, 420, 594) pageInset:UIEdgeInsetsMake(10, 10, 10, 10) completion:^(NSData * _Nonnull data) {
        [data writeToFile:outputPath atomically:YES];
        !completion ?: completion(YES);
    }];
}

/// 获取内容
- (CGSize)getContentSize {
    return self.webView.scrollView.contentSize;
}

/// 获取偏移
- (CGPoint)getContentOffset {
    return self.webView.scrollView.contentOffset;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [self.indictorView startAnimating];
    if (self.delegate && [self.delegate respondsToSelector:@selector(startLoadFile:)]) {
        [self.delegate startLoadFile:self];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self.indictorView stopAnimating];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCompleteLoadFile:error:)]) {
        [self.delegate didCompleteLoadFile:self error:nil];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.indictorView stopAnimating];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCompleteLoadFile:error:)]) {
        [self.delegate didCompleteLoadFile:self error:error];
    }
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
