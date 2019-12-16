//
//  HomeViewController.m
//  FindKey
//
//  Created by chenshuang on 2019/11/25.
//  Copyright © 2019 chenshuang. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"

@interface HomeViewController ()
/** oriTextF */
@property(nonatomic, strong)NSTextField *oriTextF;
/** target */
@property(nonatomic, strong)NSTextField *targetTextF;
/** oriFilePath */
@property(nonatomic, strong)NSString *oriFilePath;
/** targetFilePath */
@property(nonatomic, strong)NSString *targetFilePath;
/** textView */
@property(nonatomic, strong)NSTextView *textView;
/** scrollView */
@property(nonatomic, strong)NSScrollView *scrollView;
@end

@implementation HomeViewController

- (void)loadView {
    NSRect frame = [[[NSApplication sharedApplication] mainWindow] frame];
    self.view = [[NSView alloc] initWithFrame:frame];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self drawUI];
}

- (void)drawUI {
    // 选择源文件
    NSButton *btn = [[NSButton alloc] initWithFrame:NSMakeRect(20, self.view.frame.size.height - 50, 100, 25)];
    [btn setTitle:@"选择源文件"];
    [btn setTarget:self];
    [btn setAction:@selector(choseOriFileBtn)];
    [self.view addSubview:btn];
    
    // 源文件名称
    NSTextField *textF = [[NSTextField alloc] initWithFrame:NSMakeRect(btn.frame.origin.x + btn.frame.size.width + 20, btn.frame.origin.y, 250, 25)];
    textF.editable = false;
    textF.placeholderString = @"源文件名称";
    [self.view addSubview:self.oriTextF = textF];
    
    // 找重复key值
    NSButton *oriRepeatKeyBtn = [[NSButton alloc] initWithFrame:NSMakeRect(textF.frame.origin.x + textF.frame.size.width + 20, textF.frame.origin.y, 100, 25)];
    [oriRepeatKeyBtn setTitle:@"查找重复key值"];
    [oriRepeatKeyBtn setTarget:self];
    [oriRepeatKeyBtn setAction:@selector(findOriRepeatKeyBtn)];
    [self.view addSubview:oriRepeatKeyBtn];
    
    // 选择目标文件
    NSButton *btn2 = [[NSButton alloc] initWithFrame:NSMakeRect(20, btn.frame.origin.y - btn.frame.size.height - 20, 100, 25)];
    [btn2 setTitle:@"选择目标文件"];
    [btn2 setTarget:self];
    [btn2 setAction:@selector(choseTargetFileBtn)];
    [self.view addSubview:btn2];
    
    // 目标文件名称
    NSTextField *textF2 = [[NSTextField alloc] initWithFrame:NSMakeRect(btn2.frame.origin.x + btn2.frame.size.width + 20, btn2.frame.origin.y, 250, 25)];
    textF2.editable = false;
    textF2.placeholderString = @"目标文件名称";
    [self.view addSubview:self.targetTextF = textF2];
    
    NSButton *targetRepeatKeyBtn = [[NSButton alloc] initWithFrame:NSMakeRect(textF2.frame.origin.x + textF2.frame.size.width + 20, textF2.frame.origin.y, 100, 25)];
    [targetRepeatKeyBtn setTitle:@"查找重复key值"];
    [targetRepeatKeyBtn setTarget:self];
    [targetRepeatKeyBtn setAction:@selector(findTargetRepeatKeyBtn)];
    [self.view addSubview:targetRepeatKeyBtn];
    
    // 开始比对 - 只显示重复的key值
    NSButton *startKeyBtn = [[NSButton alloc] initWithFrame:NSMakeRect(20, btn2.frame.origin.y - btn2.frame.size.height - 20, 100, 25)];
    [startKeyBtn setTitle:@"比对(key)值"];
    [startKeyBtn setTarget:self];
    [startKeyBtn setAction:@selector(startCompareKey)];
    [self.view addSubview:startKeyBtn];
    
    // 开始比对 - 只显示重复的value值
    NSButton *startValueBtn = [[NSButton alloc] initWithFrame:NSMakeRect(startKeyBtn.frame.origin.x + startKeyBtn.frame.size.width + 20, startKeyBtn.frame.origin.y, 100, 25)];
    [startValueBtn setTitle:@"比对(Value)值"];
    [startValueBtn setTarget:self];
    [startValueBtn setAction:@selector(startCompareValue)];
    [self.view addSubview:startValueBtn];
    
    // 开始比对 - 显示重复的 key + value值
    NSButton *startKeyValueBtn = [[NSButton alloc] initWithFrame:NSMakeRect(startValueBtn.frame.origin.x + startValueBtn.frame.size.width + 20, startValueBtn.frame.origin.y, 130, 25)];
    [startKeyValueBtn setTitle:@"比对(Key+Value)"];
    [startKeyValueBtn setTarget:self];
    [startKeyValueBtn setAction:@selector(startCompareKeyValue)];
    [self.view addSubview:startKeyValueBtn];
    
    // 输出比对文件
    NSButton *exportBtn = [[NSButton alloc] initWithFrame:NSMakeRect(startKeyValueBtn.frame.origin.x + startKeyValueBtn.frame.size.width + 20, startKeyValueBtn.frame.origin.y, 100, 25)];
    [exportBtn setTitle:@"导出文件"];
    [exportBtn setTarget:self];
    [exportBtn setAction:@selector(exportBtnClick)];
    [self.view addSubview:exportBtn];
    
    NSRect rect = NSMakeRect(20, 20, self.view.frame.size.width - 40, startKeyBtn.frame.origin.y - startKeyBtn.frame.size.height - 20);
    
    //NSTextView
    self.textView = [[NSTextView alloc] initWithFrame:rect];
    [self.view addSubview:self.textView];

    self.textView.backgroundColor = [NSColor whiteColor];
    self.textView.editable = NO;
    self.textView.textColor = [NSColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        
    CGFloat maxWidth = self.view.frame.size.width - 40;
    //NSScrollView
    self.scrollView = [[NSScrollView alloc] initWithFrame:rect];
    [self.scrollView setBorderType:NSNoBorder];
    [self.scrollView setHasVerticalScroller:YES];
    [self.scrollView setHasHorizontalScroller:NO];
    [self.scrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    [self.textView setMinSize:NSMakeSize(0.0, self.view.frame.size.height - 80)];
    [self.textView setMaxSize:NSMakeSize(maxWidth, FLT_MAX)];
    [self.textView setVerticallyResizable:YES];//垂直方向可以调整大小
    [self.textView setHorizontallyResizable:NO];//水平方向不可以调整大小
    [self.textView setAutoresizingMask:NSViewWidthSizable];
    [[self.textView textContainer] setContainerSize:NSMakeSize(maxWidth, FLT_MAX)];
    [[self.textView textContainer] setWidthTracksTextView:YES];
    [self.textView setFont:[NSFont fontWithName:@"PingFang-SC-Regular" size:14.0]];
    [self.textView setEditable:NO];
    
    [self.scrollView setDocumentView:self.textView];
    
    [self.view addSubview:self.scrollView];
}

#pragma mark - action

- (void)choseOriFileBtn {
    __weak typeof(self) weakSelf = self;
    [self choseFile:^(NSString *filePath) {
        weakSelf.oriFilePath = filePath;
        NSArray *files = [filePath componentsSeparatedByString:@"/"];
        weakSelf.oriTextF.stringValue = [files lastObject];
    }];
}

- (void)choseTargetFileBtn {
    __weak typeof(self) weakSelf = self;
    [self choseFile:^(NSString *filePath) {
        weakSelf.targetFilePath = filePath;
        NSArray *files = [filePath componentsSeparatedByString:@"/"];
        weakSelf.targetTextF.stringValue = [files lastObject];
    }];
}

- (void)findOriRepeatKeyBtn {
    // 第一步 校验是否选择了文件
    if (self.oriFilePath.length <= 0) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"错误提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"请选择源文件"];
        [alert runModal];
        return;
    }
    
    NSArray *repeatKeys = [self findRepeatKeys:self.oriFilePath];
    NSMutableString *duplicateKeysContent = [[NSMutableString alloc] initWithString:@""];
    for (NSString *key in repeatKeys) {
        [duplicateKeysContent appendFormat:@"%@\n",key];
    }
    self.textView.string = duplicateKeysContent;
}

- (void)findTargetRepeatKeyBtn {
    // 第一步 校验是否选择了文件
    if (self.targetFilePath.length <= 0) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"错误提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"请选择目标文件"];
        [alert runModal];
        return;
    }
    
    NSArray *repeatKeys = [self findRepeatKeys:self.targetFilePath];
    NSMutableString *duplicateKeysContent = [[NSMutableString alloc] initWithString:@""];
    for (NSString *key in repeatKeys) {
        [duplicateKeysContent appendFormat:@"%@\n",key];
    }
    self.textView.string = duplicateKeysContent;
}

- (void)startCompareKey {
    NSArray *loseKeys = [self findAllLoseKeys];

    NSMutableString *loseKeysContent = [[NSMutableString alloc] initWithString:@""];
    for (NSString *key in loseKeys) {
        [loseKeysContent appendFormat:@"%@\n",key];
    }
    self.textView.string = loseKeysContent;
}

- (void)startCompareValue {
    NSArray *loseKeys = [self findAllLoseKeys];
    __weak typeof(self) weakSelf = self;
    // 找出所有丢失的 key 和 value值
    [self findAllLoseKeysAndValues:self.oriFilePath loseKeys:loseKeys completion:^(NSArray *loseValues, NSArray *loseKeyValues) {
        NSMutableString *loseKeysContent = [[NSMutableString alloc] initWithString:@""];
        for (NSString *key in loseValues) {
            [loseKeysContent appendFormat:@"%@\n",key];
        }
        weakSelf.textView.string = loseKeysContent;
    }];
}

- (void)startCompareKeyValue {
    NSArray *loseKeys = [self findAllLoseKeys];
    __weak typeof(self) weakSelf = self;
    // 找出所有丢失的 key 和 value值
    [self findAllLoseKeysAndValues:self.oriFilePath loseKeys:loseKeys completion:^(NSArray *loseValues, NSArray *loseKeyValues) {
        NSMutableString *loseKeysContent = [[NSMutableString alloc] initWithString:@""];
        for (NSString *key in loseKeyValues) {
            [loseKeysContent appendFormat:@"%@\n",key];
        }
        weakSelf.textView.string = loseKeysContent;
    }];
}

- (void)exportBtnClick {
    // 第一步 校验是否选择了文件
    if (self.textView.string.length <= 0) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"错误提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"文件内容不能为空"];
        [alert runModal];
        return;
    }
    
    NSSavePanel *panel = [NSSavePanel savePanel];
    panel.title = @"保存校对文件";
    [panel setMessage:@"选择地址保存校对文件"];   //提示文字
    
    [panel setDirectoryURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"]]];//设置默认打开路径
    
    [panel setNameFieldStringValue:@"comparison"];
    [panel setAllowsOtherFileTypes:YES];
    [panel setAllowedFileTypes:@[@"txt",@"text"]];
    [panel setExtensionHidden:NO];
    [panel setCanCreateDirectories:YES];

    AppDelegate *delegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    [panel beginSheetModalForWindow:delegate.window completionHandler:^(NSInteger result){
        if (result == NSModalResponseOK) {
            NSError *error;
            [self.textView.string writeToFile:[[panel URL] path] atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (!error) {
                NSAlert *alert = [NSAlert alertWithMessageText:@"提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"写入文件成功"];
                [alert runModal];
            }
        }
    }];
}

#pragma mark - private

/// 选择文件
- (void)choseFile:(void(^)(NSString *filePath))completion {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];  // 是否可以选择文件file
    [panel setCanChooseDirectories:YES];    // 是否能打开文件夹
    [panel setAllowsMultipleSelection:NO]; // 是否允许多选file
    NSInteger finded = [panel runModal];    // 获取panel的响应
    
    NSString *filePath;
    if (finded == NSModalResponseOK) {
        for (NSURL *url in [panel URLs]) {
            NSLog(@"-->%@",url);    // 这个url是文件的路径，同时可以在这处理你要做的事情
            filePath = [url absoluteString];
            break;
        }
    }
    
    if (completion) {
        completion(filePath);
    }
}

- (NSArray *)findAllKeys:(NSString *)filePath {
    if (filePath.length <= 0) {
        return nil;
    }
    
    // 获取文件内容
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:[NSURL URLWithString:filePath] error:nil];
    NSString *fileContext = [[NSString alloc] initWithData:fileHandle.readDataToEndOfFile encoding:NSUTF8StringEncoding];
    
    fileContext = [fileContext stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    // 根据换行符对内容进行截取
    NSArray *keys = [fileContext componentsSeparatedByString:@"\n"];
    NSMutableArray *keyM = [NSMutableArray array];
    
    // 先找出有效的key值
    for (NSString *key in keys) {
        if ([key hasPrefix:@"//"] || ([key hasPrefix:@"/*"] && [key hasSuffix:@"*/"])) {
            NSLog(@"invalid %@",key);
            continue;
        }
        if ([key hasPrefix:@"\""] && [key containsString:@"="] && [key hasSuffix:@"\";"]) {
            NSDictionary *dict = [self getValidKeyAndValue:key];
            if (dict) {
                [keyM addObject:[dict valueForKey:@"key"]];
            }
        } else if (![key containsString:@"\""] && ![key containsString:@"="]) {    // 表示就直接是key值
            [keyM addObject:key];
        }
    }
    
    return keyM.copy;
}

/// 找出重复的key值
- (NSArray *)findRepeatKeys:(NSString *)filePath {
    NSArray *keyM = [self findAllKeys:filePath];
    
    // 去除重复的key值
    NSMutableArray *duplicateKeys = @[].mutableCopy;
    NSMutableArray *allKeys = @[].mutableCopy;
    for (NSString *key in keyM) {
        if ([allKeys containsObject:key] == NO) {
            [allKeys addObject:key];
        } else {
            //重复的key
            [duplicateKeys addObject:key];
        }
    }
    
    return duplicateKeys;
}

/// 找出所有有效的key值
- (NSArray *)findAllValueKeys:(NSString *)filePath {
    NSArray *keyM = [self findAllKeys:filePath];
    
    // 去除重复的key值
    NSMutableArray *allKeys = @[].mutableCopy;
    for (NSString *key in keyM) {
        if ([allKeys containsObject:key] == NO) {
            [allKeys addObject:key];
        }
    }
    
    return allKeys;
}

/// 找出所有丢失的key值
- (NSArray *)findAllLoseKeys {
    // 第一步 校验是否选择了文件
    if (self.oriFilePath.length <= 0) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"错误提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"请选择源文件"];
        [alert runModal];
        return nil;
    }
    if (self.targetFilePath.length <= 0) {
        NSAlert *alert = [NSAlert alertWithMessageText:@"错误提示" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"请选择目标文件"];
        [alert runModal];
        return nil;
    }
    
    // 第二步 对所选择的文件进行截取处理
    NSArray<NSString *> *oriKeys = [self findAllValueKeys:self.oriFilePath];
    NSArray<NSString *> *targetKeys = [self findAllValueKeys:self.targetFilePath];
    NSMutableArray<NSString *> *loseKeys = @[].mutableCopy;
    
    for (NSString *baseKey in oriKeys) {
        if (![targetKeys containsObject:baseKey]) {
            [loseKeys addObject:baseKey];
        }
    }
    
    return loseKeys;
}

/// 找出所有key对应的value值
- (void)findAllLoseKeysAndValues:(NSString *)filePath loseKeys:(NSArray *)loseKeys completion:(void(^)(NSArray * loseValues, NSArray *loseKeyValues))completion {
    if (filePath.length <= 0 || loseKeys.count <= 0) {
        if (completion) {
            completion(nil, nil);
        }
        return;
    }
    
    // 获取文件内容
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:[NSURL URLWithString:filePath] error:nil];
    NSString *fileContext = [[NSString alloc] initWithData:fileHandle.readDataToEndOfFile encoding:NSUTF8StringEncoding];
    
    // 根据换行符对内容进行截取
    NSArray *keys = [fileContext componentsSeparatedByString:@"\n"];
    
    // 找出需要查找的key和value值
    NSMutableDictionary *valueDict = [NSMutableDictionary dictionary];
    for (NSString *key in keys) {
        NSDictionary *dict = [self getValidKeyAndValue:key];
        if (dict) {
            [valueDict setValue:[dict valueForKey:@"value"] forKey:[dict valueForKey:@"key"]];
        }
    }
    
    // 找出所有需要比对的key和value值
    NSMutableArray *keyValueM = [NSMutableArray array];
    NSMutableArray *valueM = [NSMutableArray array];
    
    for (NSString *loseKey in loseKeys) {
        if (loseKey.length > 0) {
            NSString *value = [valueDict valueForKey:loseKey];
            if (value.length > 0) {
                [keyValueM addObject:[NSString stringWithFormat:@"\"%@\" = \"%@\";",loseKey, value]];
                [valueM addObject:value];
            }
        }
    }
    
    if (completion) {
        completion(valueM, keyValueM);
    }
}

/// "ac_quick_time"  =  "速冷时间"; -> 变成合法的字典
- (NSDictionary *)getValidKeyAndValue:(NSString *)str {
    if (str.length <= 0) {
        return nil;
    }
    NSArray *keyValues = [str componentsSeparatedByString:@"="];
    if (keyValues.count != 2) {
        return nil;
    }
    NSString *key = keyValues[0];
    NSString *value = keyValues[1];
    
    // 去除非法字符
    key = [key stringByReplacingOccurrencesOfString:@" " withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSString *firstStr = [value substringWithRange:NSMakeRange(0, 1)];
    if ([firstStr isEqualToString:@" "]) {    // 第一个是空格
        value = [value stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    value = [value stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    value = [value stringByReplacingOccurrencesOfString:@";" withString:@""];
    
    return @{@"key":key, @"value":value};
}

@end
