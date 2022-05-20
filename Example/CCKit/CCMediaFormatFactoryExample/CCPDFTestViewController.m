//
//  CCPDFTestViewController.m
//  CCKit_Example
//
//  Created by lucc on 2022/5/19.
//  Copyright © 2022 Lucyfa. All rights reserved.
//

#import "CCPDFTestViewController.h"
#import "CCPDFConvertView.h"
#import "CCMediaFormatFactory.h"

@interface CCPDFTestViewController ()<UIDocumentInteractionControllerDelegate>
@property (nonatomic, copy) NSArray *files;
@property (nonatomic, copy) NSArray *type;
@property (nonatomic, strong) CCPDFConvertView *pdfConvertView;
@property (strong, nonatomic) UIDocumentInteractionController *docVC;

@end

@implementation CCPDFTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.pdfConvertView];
    self.pdfConvertView.frame = self.view.bounds;
    _files = @[@"华为推荐书目",@"iOS",@"excel操作大全"];
    _type = @[@"xls",@"ppt",@"doc"];
    self.view.backgroundColor = UIColor.whiteColor;
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@[@"excel",@"ppt",@"doc"][i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        btn.tag = 100+i;
        btn.backgroundColor = UIColor.redColor;
        btn.frame = CGRectMake(20, 60+i*40, 45, 30);
        [btn addTarget:self action:@selector(selectDocument:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    [self selectDocumentWithIndex:0];
    
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@[@"转pdf",@"转图片"][i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        btn.backgroundColor = UIColor.blueColor;
        btn.tag = 200+i;
        btn.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width - 80, 60+i*40, 50, 30);
        [btn addTarget:self action:@selector(startConvert:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
   
}

- (void)startConvert:(UIButton *)sender {
    NSError *error = nil;
    if (sender.tag == 200) {
        NSString *filePath = [CCMediaFormatFactory convertOfficeDocument:self.pdfConvertView toPdf:nil error:&error];
        if (!error && filePath.length) {
            self.docVC.URL = [NSURL fileURLWithPath:filePath];
            [self.docVC presentPreviewAnimated:YES];
        }
    } else if (sender.tag == 201) {
        NSString *filePath = [CCMediaFormatFactory convertOfficeDocument:self.pdfConvertView toImage:nil error:&error];
        if (!error && filePath.length) {
            self.docVC.URL = [NSURL fileURLWithPath:filePath];
            [self.docVC presentPreviewAnimated:YES];
        }
    }
}

- (void)selectDocument:(UIButton *)sender {
    [self selectDocumentWithIndex:sender.tag-100];
    
}

- (void)selectDocumentWithIndex:(NSInteger)index {
    if (index < 0 || index > 3) {
        return;
    }
    NSString *filePath = [[NSBundle mainBundle] pathForResource:_files[index] ofType:_type[index]];
    self.pdfConvertView.fileUrl = [NSURL fileURLWithPath:filePath];
}

#pragma mark - UIDocumentInteractionControllerDelegate Methods
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}

#pragma mark - Getter

- (CCPDFConvertView *)pdfConvertView {
    if (!_pdfConvertView) {
        _pdfConvertView = [[CCPDFConvertView alloc] init];
    }
    return _pdfConvertView;
}

- (UIDocumentInteractionController *)docVC{
    if (!_docVC) {
        _docVC = [[UIDocumentInteractionController alloc] init];
        _docVC.delegate = self;
    }return _docVC;
}


@end
