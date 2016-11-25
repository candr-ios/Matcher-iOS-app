//
//  AppDelegate.m
//  Fifa_competitions
//
//  Created by Andy Chikalo on 11/11/16.
//  Copyright © 2016 ios.dev. All rights reserved.
//

#import "AppDelegate.h"
@import Realm;
#import "Club.h"
#import "Player.h"
#import "Tournament.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self incrementLaunchCounter];
    
    [self setupClubsIfNeeded];
    
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    [self configureNavBarAppearance];
    NSLog(@"FILEPATH%@", [RLMRealmConfiguration defaultConfiguration].fileURL);

    [self testTournament];
    return YES;
}


-(void) testTournament {
    
    Player *player1 = [[Player alloc] initWithName:@"Adam"];
    Player *player2 = [[Player alloc] initWithName:@"Andy"];
    Player *player3 = [[Player alloc] initWithName:@"Tom"];
    Player *player4 = [[Player alloc] initWithName:@"Sara"];
    Player *player5 = [[Player alloc] initWithName:@"Steve"];
    Player *player6 = [[Player alloc] initWithName:@"Jane"];
    Player *player7 = [[Player alloc] initWithName:@"Lily"];
    Player *player8 = [[Player alloc] initWithName:@"Donald"];
    Player *player9 = [[Player alloc] initWithName:@"Boris"];
    Player *player10 = [[Player alloc] initWithName:@"Alex"];
    Player *player11 = [[Player alloc] initWithName:@"Sandy"];
    Player *player12 = [[Player alloc] initWithName:@"Bob"];
    Player *player13 = [[Player alloc] initWithName:@"Jack"];
    Player *player14 = [[Player alloc] initWithName:@"Ace"];
    Player *player15 = [[Player alloc] initWithName:@"Billy"];
    Player *player16 = [[Player alloc] initWithName:@"Clare"];

    
    Tournament *tournament = [[Tournament alloc] initWithPlayers:@[player1,player2,player3,player4,player5,player6,player7,player8,player9,player10,player11,player12,player13,player14,player15,player16]];
    
   
    NSLog(@"%@", tournament);
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:tournament];
    // suppose all matched played
    tournament.isGroupStageCompleted = YES;
    [realm commitWriteTransaction];
    
    
    
    if (tournament.isGroupStageCompleted) {
        
        [tournament generateKnockoutStagesFromGroups];
        
        [tournament.currentStage setRandomGoalsForMatches];
        [tournament generateNextKnockoutStage];
        [tournament.currentStage setRandomGoalsForMatches];
        [tournament generateNextKnockoutStage];
        [tournament.currentStage setRandomGoalsForMatches];
        [tournament generateNextKnockoutStage];

    }

}

- (void) setupClubsIfNeeded {
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    NSInteger count = [ud integerForKey:@"launch_counter"];
    
    if (count != 1) {
        return;
    }
    
    NSArray<NSString *> * clubNames = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"clubs" ofType:@"plist"]];
    NSMutableArray<Club *> * clubs = [[NSMutableArray alloc] initWithCapacity:clubNames.count];
    
    for (NSString * clubName in clubNames) {
        Club * club = [Club new];
        club.title = clubName;
        club.logoImageName = clubName;
        [clubs addObject:club];
    }
    
    RLMRealm * realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObjects:clubs];
    [realm commitWriteTransaction];
}

- (void) incrementLaunchCounter {
    NSUserDefaults * ud = [NSUserDefaults standardUserDefaults];
    
    NSInteger count = [ud integerForKey:@"launch_counter"];
    
    if (count == NSNotFound) {
        count = 0;
    }
    
    [ud setInteger:count + 1 forKey:@"launch_counter"];
    
    [ud synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void) configureNavBarAppearance {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.00]];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}

@end
