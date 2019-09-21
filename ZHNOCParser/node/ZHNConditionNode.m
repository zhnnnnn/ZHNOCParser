//
//  ZHNConditionNode.m
//  ZHNOCParser
//
//  Created by zhn on 2019/9/19.
//  Copyright © 2019 zhn. All rights reserved.
//

#import "ZHNConditionNode.h"
#import "ZHNOCIfElseCondition.h"

NS_INLINE BOOL isNum(id value) {
    return [value isKindOfClass:NSNumber.class];
}

NS_INLINE BOOL isCondition(id value) {
    return [value isKindOfClass:ZHNOCIfElseCondition.class];
}

NS_INLINE BOOL isConditionNode(id value) {
    return [value isKindOfClass:ZHNConditionNode.class];
}

@implementation ZHNConditionNode
- (id)nodePerform {
    switch (self.conditionType) {
        case ZHNConditionNodeType_equal: //  ==
        {
            if (isNum(self.value1) && isNum(self.value2)) {
                if ([self.value1 doubleValue] == [self.value2 doubleValue]) {
                    return [self trueCondition];
                }
            }

            // ‘TODO’ 判断指针和nil
            
        }
            break;
        case ZHNConditionNodeType_greater: // >
        {
            if (isNum(self.value1) && isNum(self.value2)) {
                if ([self.value1 doubleValue] > [self.value2 doubleValue]) {
                    return [self trueCondition];
                }
            }
        }
            break;
        case ZHNConditionNodeType_less: // <
        {
            if (isNum(self.value1) && isNum(self.value2)) {
                if ([self.value1 doubleValue] > [self.value2 doubleValue]) {
                    return [self trueCondition];
                }
            }
        }
            break;
        case ZHNConditionNodeType_greaterOrEqual: // >=
        {
            if (isNum(self.value1) && isNum(self.value2)) {
                if ([self.value1 doubleValue] >= [self.value2 doubleValue]) {
                    return [self trueCondition];
                }
            }
        }
            break;
        case ZHNConditionNodeType_lessOrEqual: // <=
        {
            if (isNum(self.value1) && isNum(self.value2)) {
                if ([self.value1 doubleValue] <= [self.value2 doubleValue]) {
                    return [self trueCondition];
                }
            }
        }
            break;
        case ZHNConditionNodeType_or: {
            BOOL true1 = YES;
            if (isCondition(self.value1)) {
                true1 = [(ZHNOCIfElseCondition *)self.value1 success];
            }
            if (isConditionNode(self.value1)) {
                id res = [(ZHNConditionNode *)self.value1 nodePerform];
                if (isCondition(res)) {
                    true1 = [(ZHNOCIfElseCondition *)res success];
                }
            }

            BOOL true2 = YES;
            if (isCondition(self.value2)) {
                true2 = [(ZHNOCIfElseCondition *)self.value2 success];
            }
            if (isConditionNode(self.value2)) {
                id res = [(ZHNConditionNode *)self.value2 nodePerform];
                if (isCondition(res)) {
                    true2 = [(ZHNOCIfElseCondition *)res success];
                }
            }
            
            if (!true1 && !true2) {
                return [self falseCondition];
            }
            
            return [self trueCondition];
        }
            break;
        case ZHNConditionNodeType_and:
        {
            BOOL true1 = YES;
            if (isCondition(self.value1)) {
                true1 = [(ZHNOCIfElseCondition *)self.value1 success];
            }
            if (isConditionNode(self.value1)) {
                id res = [(ZHNConditionNode *)self.value1 nodePerform];
                if (isCondition(res)) {
                    true1 = [(ZHNOCIfElseCondition *)res success];
                }
            }
            
            BOOL true2 = YES;
            if (isCondition(self.value2)) {
                true2 = [(ZHNOCIfElseCondition *)self.value2 success];
            }
            if (isConditionNode(self.value2)) {
                id res = [(ZHNConditionNode *)self.value2 nodePerform];
                if (isCondition(res)) {
                    true2 = [(ZHNOCIfElseCondition *)res success];
                }
            }
            
            if (!true1 || !true2) {
                return [self falseCondition];
            }
            
            return [self trueCondition];
        }
            break;
    }

    return [self falseCondition];
}

- (ZHNOCIfElseCondition *)trueCondition {
    ZHNOCIfElseCondition *c = [ZHNOCIfElseCondition instance];
    c.success = YES;
    return c;
}

- (ZHNOCIfElseCondition *)falseCondition {
    ZHNOCIfElseCondition *c = [ZHNOCIfElseCondition instance];
    c.success = NO;
    return c;
}
@end
