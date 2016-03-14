//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by 王敏超 on 16/3/10.
//  Copyright © 2016年 Chao's Awesome App House. All rights reserved.
//
// 用于声明卡牌匹配游戏的各种方法
#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck*)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card*)cardAtIndex:(NSUInteger)index;

- (void)setMode:(NSInteger)mode;


@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSInteger scoreChange;
@property (nonatomic, strong) NSMutableArray *cardsForMatch; //of Card
@property (nonatomic, strong) Card *currentCard;
@property (nonatomic, strong) NSMutableArray *historyNotes; // Of NSString, record history notes

@end
