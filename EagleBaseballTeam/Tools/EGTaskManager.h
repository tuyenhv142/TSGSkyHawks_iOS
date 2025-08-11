
#import <Foundation/Foundation.h>


typedef void (^StateArrayUpdateBlock)(NSArray *updatedArray, NSUInteger changedIndex);


@interface EGTaskManager : NSObject

@property (nonatomic, strong) NSString *taskID;
@property (nonatomic, strong) NSArray *taskArray;
@property (nonatomic, strong) NSArray *taskAllArray;

+ (instancetype)sharedManager;

- (NSArray *)currentArray;
- (void)updateState:(id)newState forIndex:(NSUInteger)index;
- (void)addUpdateListener:(StateArrayUpdateBlock)listener;
- (void)removeUpdateListener:(StateArrayUpdateBlock)listener;

@end
