+++
date = "2017-05-18T15:04:06-05:00"
title = "The Minesweeper Interview Problem"

+++

I have a friend who was asked, during a coding interview, to write their own version of minesweeper from scratch.  I found this anecdote amusing, as I have never encountered this problem during any interview I've ever taken.  Sure, I've gotten take home assignments that generally require real-world tasks, but never making a game from scratch.  And according to this friend, this was a _whiteboard_ interview.  Tall tale or not, it's still a pretty neat story.

You tell me to recreate minesweeper on a whiteboard, and my first thought is _"well, at least the fall from this floor will definitely kill me"_.  But hey - I thought about what it would entail and figured I'd give myself my own coding interview, using basic javascript to create a basic minesweeper implementation in, oh say, an hour.  This post describes how I did it - the good, the bad, and the ugly - and how you can do it too.

If you want to follow along, check out the [github repository](https://github.com/ndonolli/minesweeper-example) and the [live example](../../projects/minesweeper/).



## The "Whiteboard"

Yeah, right.  I did this problem on a _computer_, touching two files: `index.html` and `index.js`.  I gave myself a few restrictions to make it feel more like an interview:

1. Basic javascript only - no frameworks, no libraries
2. Do it within a time limit (60 minutes give or take)

My plan of action was to include all logic, from the board data to the creation of HTML elements, inside the `index.js` file, and give my `index.html` file simple container elements to which I could append my rendered minesweeper board.  I planned to organize the board as a `<table>` of "tiles", all of which would hold game data and be subscribed to event listeners to handle clicks.  This is but one of many ways to structure the game. I encourage you, dear reader, to determine a better way to do it than this idiot.

For reference, here is what my `index.html` looked like at this point:

### index.html
```html
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script>
  <script src="index.js"></script>
  <title>Minesweeper</title>
</head>
<body>
  <h1>MINESWEEPER!!</h1>
  <div id="table-container">
    <!--minesweeper goes here-->
  </div>
</body>
</html>
```
__"You're using jQuery?? That's cheating!!"__

I know, I know.  My reasoning here is that I'm using jQuery as a familiar way to query and create simple DOM elements, and not utilizing the full capabilities of the library.  An interviewer would be more concerned with application design and logic anyway.  Which brings us to -

## The Javascript

When writing a game, a common design pattern is to organize game objects as classes, in an OOP (Object-Oriented Programming) paradigm.  Given the time limit, and simplicity of the game, I deemed this method overkill for this specific case.  Instead, I took a more procedural approach, with a main function running sequential functions to initialize the game.  The structure of `index.js` would look something like this:

```javascript
function makeBoard() {
  // generate data for minesweeper board
}

function renderBoard() {
  // create HTML elements and append to #table-container element
}

function initGameRules() {
  // initialize game rules
}

function initGame() {
  // "main" function
  makeBoard();
  renderBoard();
  initGameRules();
}

$(document).ready(() => {
  initGame();
});
```

There will be some differences, but ultimately this is how I decided to organize the code.  In a sense, it still bears some resemblance to OOP style code in a language like Java, with everything falling under an abstract "`Board`" class and having a `main` method (in this case, `initGame`).

## Making the Board

The first thing I began working on was the `makeBoard` function, since I already had an idea of how I wanted the data structure of the minesweeper board to be organized.  I wanted to create a two-dimentional vector system using nested arrays, where accessing a tile piece at `(x, y)` could be done using the bracket notation - ex. `board[x][y]`. 

```javascript
function makeBoard(n, bombRate) {
  // creates n * n board of array vectors
  // @param {n} <int> Specify dimension
  // @param {bombRate} <float> Probability of bombs
  // @return <Array> "board" of <td> elements indexed at board[i][j]

  let board = [];

  return board;
}
```
At the atomic level, each element would be an object containing information about the the tile piece, such as whether the tile holds a bomb, how many bombs are in adjacent, etc.  This object I would eventually store in a `<td>` element's `data` attribute, which would later be mapped to a `<table>` element in `renderBoard`.  Initially I didn't think so far ahead, though.  The first step was to create the board data.

I put the initialization logic within an `init` function:

```javascript
function init() {
  // initializes board and randomizes bombs
  // @param none
  // @return void
  for (let i = 0; i < n; i++) {
    board.push([]);
    for (let j = 0; j < n; j++) {
      let isBomb = Math.random() > bombRate ? false : true;
      let $space = $('<td>').data({
        bomb: isBomb,
        clicked: false,
      });
      board[i].push($space);
    }
  }
}
```
This `init` function populates our array `board` with "bomb" and "no bomb" `<td>` elements randomized by the `bombRate` argument passed into our parent function.  Taking cues from the existing procedural design pattern, I decided to move the logic required to calculate the adjacent bombs to another function - named `calculateAdjacent`.

Get ready, this one is a bit of a doosey:

```javascript
function calculateAdjacent(i, j) {
  // called with coords of one piece and calculates adjacent bombs
  // used within initAdjacent
  // @param {i} <int> vertical coordinate
  // @param {j} <int> horizontal coordinate
  // @return void
  let adjacent = 0;

  // get the top and bottom rows first
  for (let x = j - 1; x < j + 2; x++) {
    // try blocks to bypass errors when board[i][j] is undefined.
    try {
      if (board[i-1][x].data().bomb) adjacent++; // top
    } catch(e) {} // no handler needed, using catch like a 'continue'
    try {
      if (board[i+1][x].data().bomb) adjacent++; // bottom
    } catch(e) {}
  }
    // left and right adjacent
  try {
    if (board[i][j-1].data().bomb) adjacent++;
  } catch(e) {} // again, no handler is needed

  try {
    if (board[i][j+1].data().bomb) adjacent++;
  } catch(e) {} // but a catch block is necessary
  
  return adjacent;
}
```
I'm not too proud of this code, primarily due to the abuse of the `try...catch` blocks.  The reason for them is this: if I'm checking for adjacent bombs for tile `(i, j)`, I'd need to check the perimeter of `i - 1` to `i + 1` as well as `j - 1` to `j + 1` for bombs.  If I'm checking a tile on, say, the top edge of the board, then `i - 1` is undefined, which throws a error that short-circuits the for loop.  By encapsulating the check within a `try...catch` block, we can disregard the errors and utilize the catch block as a "continue" for non-existing spaces.

Is this an elegant solution?  Far from it.  However, it solved this isolated problem and allowed me to continue on without much delay.  If you're following along, I challenge you to devise a better solution to this problem.

Anyway, now that this `calculateAdjacent` function works, I can use it in a `setAdjacent` function:

```javascript
function setAdjacent() {
  // traverses and calls calculateAdjacent() for each piece,
  // storing adjacent in piece object
  // @param none
  // @return void
  for (let i = 0; i < n; i++) {
    for (let j = 0; j < n; j++) {
      board[i][j].data().adjacent = calculateAdjacent(i, j);
    }
  }
}
```

With that, we can call `init` and `setAdjacent` before returning our `board` of tile objects at the end of our `makeBoard` function.

```javascript
  // start the initialization captain!
  init();
  setAdjacent();
  return board;
}
```

## Rendering the Board

The next step is to render our `board` of `<td>` elements to our HTML.  jQuery allows us to accomplish this with relatively little code.  Look:

```javascript
function renderBoard(board) {
  // renders board onto #tableContainer element
  // @param {board} <Array> board generated from makeBoard
  // @return void

  function generateGrid(board) {
    // appends board array (holding <td>) onto an html table element
    // @param {board} <Array> board generated from makeBoard
    // @return {$grid} <HTML Element> <table> elem with board <td> elems appended
    let $grid = $('<table>');

    board.forEach(elems => {
      let $row = $('<tr>');
      $row.append(elems);
      $grid.append($row);
    })

    return $grid;
  }

  const $grid = generateGrid(board);
  $("#table-container").empty().append($grid);
}
```

Within `renderBoard`, I declared a `generateGrid` function, which appends each element of `board` as a row in our minesweeper table.  The main process of `renderBoard` declares the table using `generateGrid` and appends it to the existing `#table-container` element within `index.html`.

It's almost time to take a deep breath and see where we stand.  Let's put in some styling in our HTML so that our new rendered table will look nice.

### index.html

```html
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script>
  <script src="index.js"></script>
  <style>
  h1 {
    text-align: center;
  }
  table {
    margin: 10px auto;
  }
  td {
    border: 1px solid;
    width: 50px;
    height: 50px;
    text-align: center;
  }
  #table-container {
    align-content: center;
  }
  </style>
  <title>Minesweeper</title>
</head>
```

## Setting the Game Rules

If you're following along, then running your `index.html` at this point will give you an empty table.  However, clicking on the tiles does nothing.  If you recall, we stored the tile information within the HTML "data" attribute, which is nice because it allows our tiles to be empty HTML elements on the surface.  What I need now is to devise the logic whenever a tile is clicked - either to show the adjacent bombs, or to display the bomb if a bomb gets clicked.  Let's do this withn the `initGameRules` function:

### index.js

```javascript
function initGameRules() {
  // sets click handlers for game logic
  // @param none
  // @return none
  function togglePiece(self) {
    // ...
  }

  function bombGoBoom() {
    // ...
  }

  $( "td" ).click(function() {
    togglePiece(this);
    if ($(this).data().bomb) bombGoBoom();
  });

}
```

Here's what's going on here - the main function of `initGameRules` is the click handler defined at the end.  This handler is assigned to all our `<td>` elements (tiles) and does two things:

1. Toggles the piece and displays whatever information is in its `data` attribute
2. If the tile is a bomb, then end the game with `bombGoBoom`

Let's build out these two functions then.

```javascript
function togglePiece(self) {
  let space = $(self).data(), txt;
  space.clicked = true;

  if (space.bomb) {
    $(self).addClass('bomb');
    txt = 'bomb';
  } else {
    txt = space.adjacent;
  }
  $(self).text(txt);
}
```

For the record, the `self` parameter refers to the clicked tile element, which is the `this` context within the click handler we defined.  `togglePiece` is not a method of the tile elements, so we can't use `this` within the function to refer to itself.

Other than that, all this function does is access the data attribute of the clicked tile, and renders the appropriate text - the number of adjacent bombs if the tile is clean, or the text "bomb" if the tile holds a bomb.  In the latter case, I also added a "bomb" class to that element, which can also help with some styling:

### index.html

```html
<style>
  h1 {
    text-align: center;
  }
  table {
    margin: 10px auto;
  }
  td {
    border: 1px solid;
    width: 50px;
    height: 50px;
    text-align: center;
  }
  <!--add a bomb class-->
  .bomb {
      background-color: indianred;
  }
  #table-container {
    align-content: center;
  }
</style>
```

Now all bomb tiles will have a red background to differenciate them from other tiles.  And what better color for bombs than an offensive name like `indianred`!

We have one more piece of logic for our game rules - what happens when a bomb is clicked?  Well, the game should end. And at this point I was really running out of time.  What resulted was a hack:

```javascript
function bombGoBoom() {
  // bomb go boom 
  $('td').each((i, space) => togglePiece(space));
}
```

Again, not too proud of this one.  My "game over" logic was to just toggle all the tiles so you can see where the rest of the bombs were.  On one hand this works, on the other hand, we can no longer set appropriate conditions for winning or losing the game, as well as extending the game with different rules, etc.  

I left this dirty code in here because, as developers, we need to embrace our shame and mistakes.  The world is not perfect, and sometimes code has got to ship.  As I showered myself clean of my disgrace (literally), I thought of several other ways I could have done this, but my time was up.  *Now it is your time.*  If you are still following along with your own minesweeper project - please, please utilize a better solution.

## Putting it All Together

Wrapping it up from here is trivial:

```javascript
function initGame(n, bombRate) {
  // call makeBoard
  const board = makeBoard(n, bombRate);
  // call the function that appends board to #table-container
  renderBoard(board);
  // initialize gameRules
  initGameRules();
}

$(document).ready(() => {
  initGame(5, .25)
})
```

`initGame` will be called after the document loads with the hardcoded parameters `(5, .25)`, which is `5` for the board dimension and `.25` for the probability of bombs.  Since I ran out of time, I did not implement a way for the end user to customize their minesweeper game.  I leave this to you, along with the rest of the features of this incomplete project.  Here are some challenges you can take on yourself:

- Implement a way for the player to set the board size and bomb probability themselves, and render a new game based on their input.
- Change the game win/lose logic, where the game is lost when a bomb is clicked, and the game is won when all non-bomb tiles have been clicked.
- In real minesweeper, players can "flag" a tile they believe holds a bomb. Add this feature in.
- Last but not least, a time limit!

## Final Thoughts

What I learned from this little self-test was that a seemingly big problem can be approached easily with a solid design.  Even if the design has some pitfalls and code smells, it can allow you to follow through and finish a task in a timely manner.  That is an important skill for any software developer or engineer.  I hope you've learned something as well, if not at the very least how to make a simple game like minesweeper with vanilla javascript.  And who knows, maybe some day an interviewer will ask you to create minesweeper on a whiteboard.  My hope is that you will panic a little less.

