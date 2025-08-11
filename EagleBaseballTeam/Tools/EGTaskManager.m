#import "EGTaskManager.h"


@interface EGTaskManager ()
@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *dataArray;
@property (nonatomic, strong) NSMutableArray<StateArrayUpdateBlock> *listeners;
@end

@implementation EGTaskManager

+ (instancetype)sharedManager {
    static EGTaskManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[EGTaskManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dataArray = [NSMutableArray array];
        _listeners = [NSMutableArray array];
    }
    return self;
}


- (NSArray *)currentArray {
    return [self.dataArray copy];
}

- (void)updateState:(id)newState forIndex:(NSUInteger)index {
    if (index < self.dataArray.count) {
        NSMutableDictionary *dict = self.dataArray[index];
        dict[@"status"] = newState;
        
        // 通知所有监听者
        NSArray *listeners = [self.listeners copy];
        for (StateArrayUpdateBlock block in listeners) {
            block([self.dataArray copy], index);
        }
    }
}

- (void)addUpdateListener:(StateArrayUpdateBlock)listener {
    if (listener && ![self.listeners containsObject:listener]) {
        [self.listeners addObject:[listener copy]];
    }
}

- (void)removeUpdateListener:(StateArrayUpdateBlock)listener {
    [self.listeners removeObject:listener];
}

@end
