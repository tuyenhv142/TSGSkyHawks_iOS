#import "EGCredentialManager.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonCrypto.h>
#import <LocalAuthentication/LocalAuthentication.h>
// 在文件开头声明静态变量


// 添加一个新的属性来保存加密密钥
@interface EGCredentialManager()
@property (nonatomic, copy) NSString *encryptionKey;
@end

@implementation EGCredentialManager


static NSString *const kServiceName = @"com.eaglebaseball.credentials";
static NSString *const kUsernameKey = @"com.eaglebaseball.username";
static NSString *const kPasswordKey = @"com.eaglebaseball.password";
static NSString *const kTokenKey = @"com.eaglebaseball.token";
static NSString *const kYouTubeKey = @"com.eaglebaseball.youTubeapikey";
static NSString *const kCRMApiKey = @"com.eaglebaseball.CRMApiKey";

static NSString *const kZjApiIdKey = @"com.eaglebaseball.ZjApiIdKey";
static NSString *const kZjApiSecretKey = @"com.eaglebaseball.ZjApiSecretKey";
static EGCredentialManager *manager = nil;
static dispatch_once_t onceToken;


+ (instancetype)sharedManager {

    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        // 生成并保存加密密钥
        manager.encryptionKey = [manager generateEncryptionKey];
        // 检查并保存静态凭证
        if (![manager getUsername] || ![manager getPassword] || ![manager getYouTubeAPIkey]|| ![manager getZjApiIdKey] || ![manager getZjApiSecretKey] || ![manager getCRMApiKey]) {
            [manager saveStaticCredentials];
        }
//        [manager saveStaticCredentials];
//        [manager saveToKeychain:@"gfHQ7RxS7KAacfCRZBYX" forKey:kCRMApiKey];
#ifdef showTestApi
        [manager saveToKeychain:@"gfHQ7RxS7KAacfCRZBYX"/*@"SKIrtVjAU7PY8JiiguYS"*/ forKey:kCRMApiKey];    //开发环境
#else
        [manager saveToKeychain:@"Zr9Nx2Af7jKd3LpQmQ8Vz6Tb" forKey:kCRMApiKey];    //正式环境
#endif
      
    });
    return manager;
}

//MARK: --save 数据
// 分离静态凭证和动态Token的存储
- (void)saveStaticCredentials {
    
    [self saveToKeychain:@"newsoftapp" forKey:kUsernameKey];
    [self saveToKeychain:@"Y21P 5Zsd EtAK dohZ 4WQo XA5L" forKey:kPasswordKey];
    //AIzaSyCce10Jdj3umtEeixlv9kKhhTFGfq8Dx9w mp
    //IzaSyAHtPSyko-zk2nz7iofQAzCz-KlA8enQ3c yumo
    [self saveToKeychain:@"AIzaSyCce10Jdj3umtEeixlv9kKhhTFGfq8Dx9w" forKey:kYouTubeKey];
    //中继 服务器
    [self saveToKeychain:@"157a0cfa1aac416fba17501ba1766a1c" forKey:kZjApiIdKey];
    [self saveToKeychain:@"676904ebe4df4e8dafa4722bb9f2857f" forKey:kZjApiSecretKey];
#ifdef showTestApi
    [self saveToKeychain:@"gfHQ7RxS7KAacfCRZBYX" forKey:kCRMApiKey];    //开发环境
#else
    [self saveToKeychain:@"Zr9Nx2Af7jKd3LpQmQ8Vz6Tb" forKey:kCRMApiKey];    //正式环境
#endif
}

// Token相关方法
- (void)saveToken:(NSString *)token {
    [self saveToKeychain:token forKey:kTokenKey];
}


//MARK: 加解密方法
// AES 加密
- (NSString *)encryptString:(NSString *)string withKey:(NSString *)key {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [self encryptData:data withKey:key];
    return [encryptedData base64EncodedStringWithOptions:0];
}

// AES 解密
- (NSString *)decryptString:(NSString *)string withKey:(NSString *)key {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    NSData *decryptedData = [self decryptData:data withKey:key];
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

// 生成加密密钥
- (NSString *)generateEncryptionKey {
    // 使用设备特定信息生成密钥
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return [self hashString:deviceID];
}


-(NSString *)hashString:(NSString *)input {
   const char *cStr = [input UTF8String];
   unsigned char digest[CC_SHA256_DIGEST_LENGTH];
   CC_SHA256(cStr, (CC_LONG)strlen(cStr), digest);
   
   NSMutableString *hash = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
   for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
       [hash appendFormat:@"%02x", digest[i]];
   }
   return hash;
}

// 修改加密密钥长度处理
- (NSData *)encryptData:(NSData *)data withKey:(NSString *)key {
    // 确保密钥长度为32字节(256位)
    NSMutableData *keyData = [[key dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    [keyData setLength:kCCKeySizeAES256];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                       kCCAlgorithmAES,
                                       kCCOptionPKCS7Padding,
                                       keyData.bytes,
                                       keyData.length,
                                       NULL,
                                       [data bytes],
                                       dataLength,
                                       buffer,
                                       bufferSize,
                                       &numBytesEncrypted);
   
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

// 同样修改解密方法
- (NSData *)decryptData:(NSData *)data withKey:(NSString *)key {
    // 确保密钥长度为32字节(256位)
    NSMutableData *keyData = [[key dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    [keyData setLength:kCCKeySizeAES256];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                       kCCAlgorithmAES,
                                       kCCOptionPKCS7Padding,
                                       keyData.bytes,
                                       keyData.length,
                                       NULL,
                                       [data bytes],
                                       dataLength,
                                       buffer,
                                       bufferSize,
                                       &numBytesDecrypted);
   
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

//MARK: --save load keychian
- (void)saveToKeychain:(NSString *)value forKey:(NSString *)key {

    ELog(@"value:%@  key:%@",value,key);
    NSString *encryptString = [self encryptString:value withKey:self.encryptionKey];
    
    NSData *data = [encryptString dataUsingEncoding:NSUTF8StringEncoding];

    // 先用简化的查询字典删除旧数据
    NSDictionary *deleteQuery = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: kServiceName,
        (__bridge id)kSecAttrAccount: key
    };
    
    OSStatus deleteStatus = SecItemDelete((__bridge CFDictionaryRef)deleteQuery);
    if (deleteStatus != errSecSuccess && deleteStatus != errSecItemNotFound) {
        ELog(@"删除失败: %d", (int)deleteStatus);
    }
    // 使用完整查询字典添加新数据
    NSDictionary *addQuery;
    if (![self isDevicePasscodeSet]) {
        addQuery = @{
            (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
            (__bridge id)kSecAttrService: kServiceName,
            (__bridge id)kSecAttrAccount: key,
            (__bridge id)kSecValueData: data,
            (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleAfterFirstUnlock
        };
    }else{
        addQuery = @{
            (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
            (__bridge id)kSecAttrService: kServiceName,
            (__bridge id)kSecAttrAccount: key,
            (__bridge id)kSecValueData: data,
            (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly //删除app时 删除chainkey？
    //        (__bridge id)kSecAttrSynchronizable: @NO,
    //        (__bridge id)kSecAttrAccessControl: [self createAccessControl]
        };
    }
    OSStatus addStatus = SecItemAdd((__bridge CFDictionaryRef)addQuery, NULL);
    if (addStatus != errSecSuccess) {
        ELog(@"添加失败: %d", (int)addStatus);
    }
}

- (id)createAccessControl {
    CFErrorRef error = NULL;
    SecAccessControlRef access = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                               kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
                                                               kSecAccessControlUserPresence | kSecAccessControlPrivateKeyUsage,
                                                               &error);
    return (__bridge_transfer id)access;
}

- (NSString *)loadFromKeychainForKey:(NSString *)key {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: kServiceName,
        (__bridge id)kSecAttrAccount: key,
        (__bridge id)kSecReturnData: @YES
    };
    
    CFTypeRef result = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    
    if (result != NULL) {
        NSData *data = (__bridge_transfer NSData *)result;
        
        NSString *encryptedValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return [self decryptString:encryptedValue withKey:self.encryptionKey];
    }
    return nil;
}

//MARK:  get key的value
- (NSString *)getUsername {
    return [self loadFromKeychainForKey:kUsernameKey];
}

- (NSString *)getPassword {
    return [self loadFromKeychainForKey:kPasswordKey];
}

- (NSString *)getYouTubeAPIkey {
    NSString *ddd = [self loadFromKeychainForKey:kYouTubeKey];
//    ELog(@"%@",ddd);
    return ddd;
}

- (NSString *)getZjApiIdKey {
    return [self loadFromKeychainForKey:kZjApiIdKey];
}

- (NSString *)getZjApiSecretKey {
    return [self loadFromKeychainForKey:kZjApiSecretKey];
}

- (NSString *)getCRMApiKey{
    return [self loadFromKeychainForKey:kCRMApiKey];
}

- (NSString *)getToken {
    return [self loadFromKeychainForKey:kTokenKey];
}

- (void)clearToken {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: kServiceName,
        (__bridge id)kSecAttrAccount: kTokenKey
    };
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    if (status != errSecSuccess && status != errSecItemNotFound) {
        ELog(@"清除失败: %d", (int)status);
    }
}

// 添加销毁方法
+ (void)destroyManager {
    @synchronized(self) {
        manager = nil;
        onceToken = 0; // 重置 dispatch_once_t
    }
}

- (void)clearCredentials {

    // 只删除当前应用的 Keychain 数据
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: kServiceName
    };
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    if (status != errSecSuccess && status != errSecItemNotFound) {
        ELog(@"清除失败: %d", (int)status);
    }
    
    // 清除后调用销毁方法
    [EGCredentialManager destroyManager];
}



#pragma mark --- 在尝试存储 Keychain 数据前，可以先检查设备是否设置了密码：
- (BOOL)isDevicePasscodeSet {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    // 检查设备是否支持密码/生物识别（Touch ID/Face ID）
    BOOL isPasscodeSet = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error];
    return isPasscodeSet;
}
@end
