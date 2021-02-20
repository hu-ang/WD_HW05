defmodule Bulls.Game do
    def new do
      %{
        secret: random_secret(),
        guesses: MapSet.new(),
      }
    end

    #return a new state with the given guess
    #(state, new guess) -> new State
    def guess(st, num) do
        cond do 
            num |>String.graphemes |>Enum.uniq|>length() != 4 -> st
            num |> String.graphemes |> Enum.any?(&(&1 < "0" || &1 > "9")) -> st
            true -> %{st | guesses: MapSet.put(st.guesses, num)}
        end
    end
    

    def view(st) do
        #update table
        #whether win/lose
        #{listGuesses, listResults, gameStatus}
        #{ILoInt, ILoString, String}
        results = st.guesses
        |> Enum.to_list() #list of numbers
        |> Enum.map(fn guess-> #list of strings
            secret_as_list = st.secret |>String.graphemes()
            guess
                |> String.graphemes()
                |> Enum.zip(secret_as_list)
                |> List.foldr(%{bulls: 0, cows: 0}, fn {g, s}, acc ->
                    cond do 
                        g == s -> %{bulls: acc.bulls + 1, cows: acc.cows}
                        Enum.member?(secret_as_list, g) -> %{bulls: acc.bulls, cows: acc.cows + 1}
                        true -> acc
                    end
                end)
                |> map_to_string()
            end)
        guesses= MapSet.to_list(st.guesses)
        cond do
            (Enum.member?(results, "Bulls: 4, Cows: 0")) -> %{guesses: guesses, results: results, status: "win"}
            (st.guesses |> MapSet.size() > 8) -> %{guesses: guesses, results: results, status: "lose"}
            true -> %{guesses: guesses, results: results, status: "continue"}
        end
    end     

    #converts the given map to a string
    def map_to_string(map) do
        "Bulls: " <> Integer.to_string(map.bulls) <> " Cows: " <> Integer.to_string(map.cows)
    end 
    #generates a random sequence of 4 unique digits 
    def random_secret do
        Enum.join(generate_number([]))
    end

    #generate a random list length 4 of non-repeating digits
    def generate_number(list) do
        num = Enum.random(0..9)
        cond do
            length(list) === 4 -> list
            Enum.member?(list, num) -> generate_number(list)
            true -> generate_number([num | list])
        end
    end
end 