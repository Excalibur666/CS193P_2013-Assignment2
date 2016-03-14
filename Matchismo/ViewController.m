//
//  ViewController.m
//  Matchismo
//
//  Created by 王敏超 on 16/3/9.
//  Copyright © 2016年 Chao's Awesome App House. All rights reserved.
//

#import "ViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "PlayingCard.h"

@interface ViewController ()
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;


- (IBAction)resetButton:(UIButton *)sender;
- (IBAction)representHistorySlider:(UISlider *)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cardModeControl;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UISlider *historySlider;




@end
@implementation ViewController{
    BOOL _isGameStarted;
    NSUInteger _count; // count every changes at the detailLabel
    NSUInteger _currentSliderIndex; // index of the slider
}


- (void)viewDidLoad{
    [self resetGame];
}


- (void)resetGame{
    self.game = nil;
    _isGameStarted = NO;
    // init the first note
    [self.game.historyNotes addObject:@"Let the game begin!!!"];
    _currentSliderIndex = 0; // index begin with 0
    _count = 1; // count begin with 1
    [self.historySlider setValue:_currentSliderIndex animated:YES];
    self.cardModeControl.enabled = YES;
    [self updateUI];
}


- (CardMatchingGame*)game{
    
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    }
    return _game;
}




- (Deck*)createDeck{
    return [[PlayingCardDeck alloc] init];
}


- (void)updateHistorySlider{
    
    [self.historySlider setValue:_currentSliderIndex animated:YES];
}

- (void)updateDetailLabel{
    
    self.detailLabel.text = self.game.historyNotes[_currentSliderIndex];
    
}

- (void)updateUI{
    
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    }
    [self updateHistorySlider];
    [self updateDetailLabel];
}




- (IBAction)touchCardButton:(UIButton *)sender {
    NSUInteger chooseButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chooseButtonIndex];    // lazy instantiation, instead of init method
    
    _count++;
    _currentSliderIndex++; // count and index increase when tap a card
    [self updateUI];
    if (!_isGameStarted) {
        _isGameStarted = YES;
        self.cardModeControl.enabled = NO;
        [self.game setMode:self.cardModeControl.selectedSegmentIndex]; // index begin with 0, 0 for 2-match-mode, 1 for 3-match-mode
    }
    
}

- (NSString*)titleForCard:(Card*)card{
    
    return card.isChosen ? card.contents : @"";
}

- (UIImage*)backgroundImageForCard:(Card*)card{
    
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}


- (IBAction)resetButton:(UIButton *)sender {
    
    [self resetGame];
}

- (IBAction)representHistorySlider:(UISlider *)sender {
    
    self.detailLabel.alpha = 1;
    _currentSliderIndex = self.historySlider.value;
    NSString *history = @""; // when value is bigger than count
    if (_currentSliderIndex < _count && _count > 1) { // that is history not current index
        history = self.game.historyNotes[_currentSliderIndex];
        self.detailLabel.alpha = 0.5f;
    }
    self.detailLabel.text = history;
    _currentSliderIndex = _count - 1;
}
@end
