////////////////////////////////////////////////////////////////////////////
//
// Copyright 2014 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#import "AppDelegate.h"
#import <Realm/Realm.h>

@interface Dog : RLMObject
@property long long key;
@property NSString *name;
@end

@implementation Dog
// No need for implementation
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UIViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    [[NSFileManager defaultManager] removeItemAtPath:[RLMRealm defaultRealmPath] error:nil];
    
    // Realms are used to group data together
    RLMRealm *realm = [RLMRealm defaultRealm]; // Create realm pointing to default file
    
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
    
    [self realmTestWith:realm];
    return YES;
}

- (void)realmTestWith:(RLMRealm *)realm
{
    // Query #1
    {
        [realm beginWriteTransaction];
        for (long long i = 6473924485020270; i < 6473924485020370; i++) {
            Dog *mydog = [[Dog alloc] init];
            mydog.key = i;
            mydog.name = @"Rex";
            [realm addObject:mydog];
        }
        [realm commitWriteTransaction];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"key >= %lld AND key < %lld", 6473924485020340, 6473924485020370];
        RLMResults *dogs = [Dog objectsWithPredicate:pred];

        
        NSLog(@"Query #1-------------------------------------------------");
        NSLog(@"Number of dogs: %li", dogs.count);
        for (int i = 0; i < dogs.count; i++) {
            Dog *dog = [dogs objectAtIndex:i];
            NSLog(@"Dog Name : %@, Key : %lld", dog.name, dog.key);
        }
        NSLog(@"---------------------------------------------------------");
    }
    
    NSLog(@"\n\n");
    
    // Query #2
    {
        [realm beginWriteTransaction];
        for (long long i = -50; i < 50; i++) {
            Dog *mydog = [[Dog alloc] init];
            mydog.key = i;
            mydog.name = @"Rex";
            [realm addObject:mydog];
        }
        [realm commitWriteTransaction];

//        Test #1: All Dogs (Total 200 Dogs) => PASS
//        RLMResults *dogs = [Dog allObjects];
        
//        Test #2: Dogs under 10 (Should be 60 Dogs) => FAIL
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"key < %lld", 10];
        RLMResults *dogs = [Dog objectsWithPredicate:pred];

//        Test #3: Dogs over 9 (Should be 140 Dogs) => PASS
//        NSPredicate *pred = [NSPredicate predicateWithFormat:@"key > %lld", 9ULL];
//        RLMResults *dogs = [Dog objectsWithPredicate:pred];
        
//        Test #4: Dogs under -10 (Should be 40 Dogs) => FAIL
//        RLMResults *dogs = [Dog objectsWhere:@"key < -10"];
        
        NSLog(@"Query #2-------------------------------------------------");
        NSLog(@"Number of dogs: %li", dogs.count);
        for (int i = 0; i < dogs.count; i++) {
            Dog *dog = [dogs objectAtIndex:i];
            NSLog(@"Dog Name : %@, Key : %lld", dog.name, dog.key);
        }
        NSLog(@"---------------------------------------------------------");
    }
}

@end
