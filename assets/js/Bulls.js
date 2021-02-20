import React, { useEffect, useState } from 'react';
import './App.css';
import {ch_join, ch_push, ch_reset} from "./socket";
//the bulk of this code except for the results variable and randomNumber(), resetGame(), and other couple-line
//and minor changes were borrowed from the lecture notes! Same with game.js.
function App() {
  const [state, setState] = useState({guesses: [], results: [], status: ""});
  const [guess, setGuess] = useState("");
  useEffect(() => {ch_join(setState);
  });

  function updateGuess(ev) {
    let text = ev.target.value;
    if (text.length > 4) {
      text = text.substring(0, 4);
    }
    setGuess(text);
  }

  function resetGame() {
    ch_reset();
  }

  function makeGuess() {
    ch_push(guess);
    setGuess("");
  }

  function keypress(ev) {
    if (ev.key == "Enter") {
      makeGuess();
    }
  }

  if (state.status === "lose") {
    return (
      <div className="App">
        <h1>Game Over</h1>
        <p>
          <button onClick={() => resetGame()}>
            Reset
          </button>
        </p>
      </div>
    );
  }

  if (state.status === "win") {
    return (
      <div className="App">
        <h1>You Won!</h1>
        <p>
          <button onClick={() => resetGame()}>
            Reset
          </button>
        </p>
      </div>
    );
  }

  return (
    <div className="App">
      <h1>Bulls and Cows</h1>
      <h2>Lives: {8 - state.guesses.length}</h2>
      <p>
        <table class="center">
          <tr>
            <th>Guesses</th>
            <th>Results</th>
          </tr> 
          {state.guesses.map((value, index) => {
            return <tr><td>{value}</td><td>{state.results[index]}</td></tr>
          })}
        </table>
      </p>
      <p>
        <input type="number"
               value={guess}
               onChange={updateGuess}
               onKeyPress={keypress} />
        <button onClick={makeGuess}>
          Guess
        </button>
      </p>
      <h6><i>Only input numbers with 4 unique digits</i></h6>
      <p>
        <button onClick={() => resetGame()}>
          Reset
        </button>
      </p>
    </div>
  );
}

export default App;
