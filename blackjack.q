\d .bj
system"S ",string `long$.z.p mod `long$.z.d;                                                      / set seed to psuedo-random number

//Card varuabkes
suits:`Hearts`Clubs`Diamonds`Spades;
names:`Ace`2`3`4`5`6`7`8`9`10`Jack`Queen`King;
initials:`A`2`3`4`5`6`7`8`9`10`J`Q`K;                                                             / What will appear on card graphic
getNumericValue:{((1+til 10),10) `Ace`2`3`4`5`6`7`8`9`10 ? x};                                    / Picture cards will index into the last 10 as not in list

//Game variables
startedGame:0b;
playerWon:0b;
gameOver:0b;
dealerCards:();
playerCards:();
dealerScore:0;
playerScore:0;
deck:();

//New Game
createDeck:{x cross y};                                                                           / All value/suit combinations 
shuffle:{x[-52?til 52]};                                                                          / Shuffle by randomising indexes
deck:shuffle[deck];

startNewGame:{
  dealerCards::();
  playerCards::();
  startedGame::1b;
  gameOver::0b;
  playerWon::0b;

  `deck set shuffle createDeck[names;suits];
  `dealerCards`playerCards set' {x,getNextCard[]}/[2;] each (dealerCards;playerCards);            / Deal two cards for each player initally
  showStatus[];
  nextAction[]
 };

nextAction:{
  -1"Hit (H) or Stick (S)";
  action:`$read0 0;
  (`H`S!(hit;stick))[action]`
 };

hit:{
  if[not gameOver;                                                                                / Don't do anything if game is over
    playerCards,:getNextCard[];
    isEndGame[];
    showStatus[];
    nextAction[]
  ];
 };

stick:{
  gameOver::1b;
  isEndGame[];
  showStatus[];
  nextAction[]
 };

//Helper Functions
stringCard:{string[x]," of ",string y};
getPoints:{
  points:{getNumericValue[y 0]+x}/[0;x];
  :(points;$[21>=points+10;points+10;points]) `Ace in x[;0];                                      / Make Ace worth 1 point if 11 makes bust
 };
getNextCard:{[] -1#deck::1 rotate deck};                                                          / Take next card and rotate deck
createDeckGraphic:{
  createCardGraphic:{
    (" _____ ";"|",(5$string[(names!initials) x 0]),"|";"|     |";"|     |";"|_____|"),'" "
  };
  :(,'/) . ((" "); createCardGraphic each x);
 };

showStatus:{
  updateScore[];
  -1 "Dealer's hand:";
  {-1 stringCard . x} each $[not gameOver;1#dealerCards;dealerCards];                             / Show only dealer's upfacing card until end of player's turn
  -1 createDeckGraphic $[not gameOver;1#dealerCards;dealerCards];
  -1 "Dealer Score: ",string[dealerScore],"\n";
  -1 "Players's hand:";
  {-1 stringCard . x} each playerCards;
  -1 createDeckGraphic playerCards;
  -1 "Player Score: ",string[playerScore],"\n";

  if[gameOver;
    $[playerWon;
      -1 "You Won!";
      -1 "You Lost!"
    ];
  -1 "Enter N to start a new game"
  ];
 };

updateScore:{
  dealerScore::getPoints $[not gameOver;1#dealerCards;dealerCards];                               / Calculate score only of dealer's upfacing card until end of player's turn
  playerScore::getPoints playerCards;
 };

isEndGame:{[]
  updateScore[];
  if[gameOver;
    dealerCards::{d:x,getNextCard[];showStatus[];d}/[{17>getPoints x};dealerCards]                / Dealer takes cards until score is 17 or more
  ];
  updateScore[];
  $[playerScore> 21;
    `gameOver`playerWon set' 10b;
    dealerScore > 21;
    `gameOver`playerWon set' 11b;
    gameOver;
    `playerWon set' playerScore>dealerScore;
  ];
 };

startNewGame[]
error:-1 "Please input either N (new game), H (hit), S (stick) \n";