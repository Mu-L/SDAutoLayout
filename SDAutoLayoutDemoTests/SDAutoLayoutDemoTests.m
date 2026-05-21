//
//  SDAutoLayoutDemoTests.m
//  SDAutoLayoutDemoTests
//

#import <XCTest/XCTest.h>
#import <AFNetworking/AFNetworking.h>
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>

#import "ThreeModel.h"
#import "ThreeBaseCell.h"
#import "XYString.h"

@interface SDAutoLayoutDemoTests : XCTestCase
@end

@implementation SDAutoLayoutDemoTests

#pragma mark - CocoaPods / AFNetworking 4

- (void)testAFHTTPSessionManagerFactoryExists {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    XCTAssertNotNil(manager);
    XCTAssertTrue([manager isKindOfClass:[AFHTTPSessionManager class]]);
}

- (void)testAFNetworkingPodsDoNotImportPrivateIn6Header {
    NSString *podsRoot = [[NSProcessInfo processInfo].environment objectForKey:@"PODS_ROOT"];
    if (podsRoot.length == 0) {
        podsRoot = [[[NSBundle bundleForClass:[self class]] bundlePath]
                    stringByDeletingLastPathComponent];
        podsRoot = [podsRoot stringByAppendingPathComponent:@"../../Pods"];
    }
    NSArray<NSString *> *files = @[
        @"AFNetworking/AFNetworking/AFHTTPSessionManager.m",
        @"AFNetworking/AFNetworking/AFNetworkReachabilityManager.m",
    ];
    for (NSString *rel in files) {
        NSString *path = [podsRoot stringByAppendingPathComponent:rel];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            continue;
        }
        NSString *source = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        XCTAssertNotNil(source, @"应能读取 %@", rel);
        XCTAssertFalse([source containsString:@"netinet6/in6.h"],
                       @"%@ 不应再 import 私有头 netinet6/in6.h", rel);
    }
}

- (void)testMJRefreshConfigUsesDefaultFactory {
    MJRefreshConfig *config = MJRefreshConfig.defaultConfig;
    XCTAssertNotNil(config);
}

#pragma mark - DemoVC10 数据链路

- (void)testDemoVC10ArticleURLFormat {
    NSInteger page = 10;
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/%ld-20.html",
                     @"headline/T1348647853363", (long)page];
    XCTAssertEqualObjects(url,
                          @"http://c.m.163.com/nc/article/headline/T1348647853363/10-20.html");
}

- (void)testXYStringParsesJSONDictionary {
    NSString *json = @"{\"headline/T1348647853363\":[{\"title\":\"t\"}]}";
    NSDictionary *dict = [XYString getObjectFromJsonString:json];
    XCTAssertTrue([dict isKindOfClass:[NSDictionary class]]);
    XCTAssertNotNil(dict[@"headline/T1348647853363"]);
}

- (void)testThreeModelParsesFromFixture {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *url = [bundle URLForResource:@"news_sample" withExtension:@"json"];
    XCTAssertNotNil(url);
    NSData *data = [NSData dataWithContentsOfURL:url];
    XCTAssertNotNil(data);
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    XCTAssertNotNil(dict);
    NSString *key = dict.allKeys.firstObject;
    NSArray *items = dict[key];
    NSArray<ThreeModel *> *models = [ThreeModel mj_objectArrayWithKeyValuesArray:items];
    XCTAssertEqual(models.count, 2U);
    XCTAssertEqualObjects(models.firstObject.title, @"测试新闻标题");
    XCTAssertEqualObjects(models.firstObject.docid, @"TEST001");
}

- (void)testThreeBaseCellIdentifierMapping {
    ThreeModel *plain = [ThreeModel new];
    plain.hasHead = @(NO);
    plain.imgType = nil;
    plain.imgextra = nil;
    XCTAssertEqualObjects([ThreeBaseCell cellIdentifierForRow:plain], @"ThreeFirstCell");

    ThreeModel *multi = [ThreeModel new];
    multi.imgextra = @[@{}];
    XCTAssertEqualObjects([ThreeBaseCell cellIdentifierForRow:multi], @"ThreeSecondCell");

    ThreeModel *big = [ThreeModel new];
    big.imgType = @1;
    XCTAssertEqualObjects([ThreeBaseCell cellIdentifierForRow:big], @"ThreeThirdCell");

    ThreeModel *head = [ThreeModel new];
    head.hasHead = @(YES);
    XCTAssertEqualObjects([ThreeBaseCell cellIdentifierForRow:head], @"ThreeFourthCell");
}

@end
