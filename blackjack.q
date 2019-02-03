\d .bj
system"S ",string `long$.z.p mod `long$.z.d;                                                      / set seed to psuedo-random number

//Card varuabkes
suits:`Hearts`Clubs`Diamonds`Spades;
names:`Ace`2`3`4`5`6`7`8`9`10`Jack`Queen`King;
initials:`A`2`3`4`5`6`7`8`9`10`J`Q`K;                                                             / What will appear on card graphic
GetNumericValue:{((1+til 10),10) `Ace`2`3`4`5`6`7`8`9`10 ? x};                                    / Picture cards will index into the last 10 as not in list

//Game variables
gameOver:0b;
deck:();

StartNewGame:{
  .bj.deck:Shuffle CreateDeck[names;suits];
  `dealerCards`playerCards set' {x,GetNextCard[]}/[2;] each (();());            / Deal two cards for each player initally
  ShowStatus[0b];
  NextAction[0b]
 };

CreateDeck:{x cross y};                                                                           / All value/suit combinations 
Shuffle:{0N?x};                                                                                   / Shuffle by randomising indexes
deck:Shuffle[deck];

NextAction:{[endGame]
  -1"Do you want to ",("Hit (H) or Stick (S)";"Start a New Game (N)") endGame;
  action:`$read0 0;
  if[not action in (`H`S;`N) endGame;-1 "Invalid input";.z.s[];(::)]
  (`H`S`N!(Hit;Stick;StartNewGame))[action]`
 };

Hit:{                                                                                             / Don't do anything if game is over
  playerCards,:GetNextCard[];
  .bj.playerScore:GetPoints playerCards;
  if[IsTurnEnd[];:EndGame[]];
  ShowStatus[0b];
  NextAction[0b]
 };

Stick:{
  EndGame[];
 };

StringCard:{string[x]," of ",string y};

GetPoints:{
  points:{GetNumericValue[y 0]+x}/[0;x];
  :(points;$[21>=points+10;+[10];::]points)`Ace in x[;0];                                         / Make Ace worth 1 point if 11 makes bust
 };

GetNextCard:{-1#.bj.deck:1 rotate deck};                                                          / Take next card and rotate deck

CreateDeckGraphic:{
  :(,'/) . (" "; CreateCardGraphic each x);
 };

CreateCardGraphic:{
    i:5$string (names!initials) x 0;
    ( " _____  ";
      "|",i,"| ";
      "|     | ";
      "|     | ";
      "|_____| ")
  };

ShowStatus:{[gameOver]
  UpdateScore[gameOver];
  -1 "Dealer's hand:";
  {-1 StringCard . x} each $[not gameOver;1#;::] dealerCards;                                     / Show only dealer's upfacing card until end of player's turn
  -1 CreateDeckGraphic $[not gameOver;1#dealerCards;dealerCards];
  -1 "Dealer Score: ",string[dealerScore],"\n";
  -1 "Players's hand:";
  {-1 StringCard . x} each playerCards;
  -1 CreateDeckGraphic playerCards;
  -1 "Player Score: ",string[playerScore],"\n";
 };

UpdateScore:{[gameOver]
  .bj.dealerScore:GetPoints $[not gameOver;1#;::] dealerCards;                                    / Calculate score only of dealer's upfacing card until end of player's turn
  .bj.playerScore:GetPoints playerCards;
 };

IsTurnEnd:{
  playerScore > 21
 };

EndGame:{
  ShowStatus[1b];
  {dealerCards,:GetNextCard[];ShowStatus[1b]}/[{17>GetPoints dealerCards}];                         / Dealer takes cards until score is 17 or more
  ShowResult[];
  NextAction[1b]
 };

ShowResult:{
  if[dealerScore > 21;
    $[playerScore > 21;
      -1 "You Lost!";
      -1 "You Won!"
     ];:(::)];

  $[playerScore > 21;
    -1 "You Lost!";
    playerScore > dealerScore;
    -1 "You Won!";
    -1 "You Lost!"];
 };

StartNewGame[]