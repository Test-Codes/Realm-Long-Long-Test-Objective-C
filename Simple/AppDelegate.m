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
@property long long age;
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
    {
        // Set & read properties
        [realm beginWriteTransaction];
        for (long long i = 6473924485019126; i < 6473924485020369; i++) {
            Dog *mydog = [[Dog alloc] init];
            mydog.key = i;
            mydog.name = [NSString stringWithFormat:@"Rex %llu", i];
            mydog.age = i;
            [realm addObject:mydog];
        }
        [realm commitWriteTransaction];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"key >= %llu AND key <= %llu", 6473924485020126, 6473924485020369];
        RLMResults *dogs = [Dog objectsWithPredicate:pred];
        
        NSLog(@"Number of dogs: %li", (unsigned long)dogs.count);
        for (int i = 0; i < dogs.count; i++) {
            Dog *dog = [dogs objectAtIndex:i];
            NSLog(@"Name : %@, Age : %llu, Key : %llu", dog.name, dog.age, dog.key);
        }
    }
    
    {
        // Set & read properties
        [realm beginWriteTransaction];
        for (long long i = -100; i < 100; i++) {
            Dog *mydog = [[Dog alloc] init];
            mydog.key = i;
            mydog.name = [NSString stringWithFormat:@"Rex %llu", i];
            mydog.age = i;
            [realm addObject:mydog];
        }
        [realm commitWriteTransaction];
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"key <= %llu", 9];
        RLMResults *dogs = [Dog objectsWithPredicate:pred];
        
        NSLog(@"Number of dogs: %li", (unsigned long)dogs.count);
        for (int i = 0; i < dogs.count; i++) {
            Dog *dog = [dogs objectAtIndex:i];
            NSLog(@"Name : %@, Age : %llu, Key : %llu", dog.name, dog.age, dog.key);
        }
    }
}

@end
