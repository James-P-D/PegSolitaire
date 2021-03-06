(********************************************************************************)

(* Our custom exception which will be thrown if we attempt to apply a move in which either
   A) The start cell is not a marble
   B) The cell we are jumping over is not a marble
   C) The target cell of our jump is not empty *)

exception SolitaireException of string;;

(********************************************************************************)
    
let void = 0;;
let empty = 1;;
let marble = 2;;

(********************************************************************************)

(* English board dimensions *)

let english_board_width = 7;;
let english_board_height = 7;;

(* English board layout *)

let english_board = [[void;   void;   marble; marble; marble; void;   void];
                     [void;   void;   marble; marble; marble; void;   void];
                     [marble; marble; marble; marble; marble; marble; marble];
                     [marble; marble; marble; empty;  marble; marble; marble];
                     [marble; marble; marble; marble; marble; marble; marble];
                     [void;   void;   marble; marble; marble; void;   void];
                     [void;   void;   marble; marble; marble; void;   void]];;

(********************************************************************************)

(* Convert an integer to a string. Marbles are '0', empty spaces are '-', and
   cells which are not on the board are ' ' *)

let int_to_string i =
  if (i == marble) then  " O " else (
    if (i == empty) then " - " else "   "
  );;
  
(********************************************************************************)

(* Get row y *)

let get_row board y =
  List.nth board y;;  
  
(********************************************************************************)

(* Get item at cell (x, y) *)

let get_item board x y = 
  List.nth (get_row board y) x;;

(********************************************************************************)

(* Display the board *)

let draw_board board width height = 
  Printf.printf "  ";
  for x = 0 to (width - 1) do
    Printf.printf " %d " x
  done;
  Printf.printf "\n";
    
  for y = 0 to (height - 1) do 
    Printf.printf "%d " y;
    for x = 0 to (width - 1)  do
      Printf.printf "%s" (int_to_string(get_item board x y))
    done;
    Printf.printf "\n"
  done;
  Printf.printf "\n";
  flush stdout;;  

(********************************************************************************)

(* Check if pieces at (x, y) is a marble or not *)

let is_marble board x y =
  if ((get_item board x y) == marble) then true else false;;

(********************************************************************************)

(* Returns 1 if item at (x, y) is a marble. (Used for counting marbles on board
   to check if we have reached a terminal state.) *)

let one_if_marble board x y =
  if (is_marble board x y) then 1 else 0;;

(********************************************************************************)

(* Check if board is complete. If number of marbles left is greater than 1 then
   return false, otherwise return true. (x, y) is current cell, whilst n is
   our counter which we increment recursively. *)
                                                                                 
let rec is_complete board width height x y n =
  if (n > 1) then (
    false;
  ) else (
    if ((x + 1) == width) then (
      if ((y + 1) == height) then (
        (((n + (one_if_marble board x y)) == 1) && (is_marble board 3 3))
      ) else (
        is_complete board width height 0 (y + 1) (n + (one_if_marble board x y))
      )
    ) else (
      is_complete board width height (x + 1) y (n + (one_if_marble board x y))
    )
  )

(********************************************************************************)
                                               
(* Check if board is complete. Start at cell (0, 0) with counter also set to zero *)
                                               
let is_complete board width height =
  is_complete board width height 0 0 0;;
  
(********************************************************************************)

(* Apply a move. Take the piece located at cell (x1, y1) and move it to (x2, y2)
   and then mark the cell ((x1+x2)/2, (y1+y2)/2) as empty since we will have
   jumped over it. *)

let apply_move board width height x1 y1 x2 y2 =
  let new_board = ref [] in
  let new_row = ref [] in
  let middle_x = ((x1 + x2) / 2) in
  let middle_y = ((y1 + y2) / 2) in
  
  let move_piece = get_item board x1 y1 in
  let middle_piece = get_item board middle_x middle_y in
  let target_pos = get_item board x2 y2 in
  (* TODO: Can we remove these checks? *)
  if (move_piece != marble) then (raise (SolitaireException ("(" ^ string_of_int(x1) ^ ", " ^ string_of_int(y1) ^ ") is not a marble (start)" ))) else (
    if (middle_piece != marble) then (raise (SolitaireException ("(" ^ string_of_int(middle_x) ^ ", " ^ string_of_int(middle_y) ^ ") is not marble (jump)" ))) else (
      if (target_pos != empty) then (raise (SolitaireException ("(" ^ string_of_int(x2) ^ ", " ^ string_of_int(y2) ^ ") is not empty" ))) else (
        for y = (height - 1) downto 0 do 
          for x = (width - 1) downto 0 do
            if ((x == x1) && (y == y1)) then 
              new_row := empty :: (!new_row)
            else (
              if ((x == middle_x) && (y == middle_y)) then (
                new_row := empty :: (!new_row)
              ) else (
                if ((x == x2) && (y == y2)) then (
                  new_row := marble :: (!new_row)
                ) else (
                  new_row := (get_item board x y) :: (!new_row)
                )
              )
            )
          done;
          new_board := (!new_row)::(!new_board);
          new_row := [];
        done;
        new_board;
      );
    );
  );;
  
(********************************************************************************)

(* Get the possible moves for piece at (x, y) *)

let get_moves board width height x y =
  let moves = ref [] in
  let move_piece = get_item board x y in
  if (move_piece == marble) then (
    if ((x - 2) >= 0) then (
      let jump_over = get_item board (x - 1) y in
      let target = get_item board (x - 2) y in
      if ((jump_over == marble) && (target == empty)) then (
        moves := (x - 2, y) :: (!moves)
      )
    );
    if ((x + 2) < width) then (
      let jump_over = get_item board (x + 1) y in
      let target = get_item board (x + 2) y in
      if ((jump_over == marble) && (target == empty)) then (
        moves := (x + 2, y) :: (!moves)
      )
    );
    if ((y - 2) >= 0) then (
      let jump_over = get_item board x (y - 1) in
      let target = get_item board x (y - 2) in
      if ((jump_over == marble) && (target == empty)) then (
        moves := (x, y - 2) :: (!moves)
      )
    );
    if ((y + 2) < height) then (
      let jump_over = get_item board x (y + 1) in
      let target = get_item board x (y + 2) in
      if ((jump_over == marble) && (target == empty)) then (
        moves := (x, y + 2) :: (!moves)
      )
    );
  );
  moves;;

(********************************************************************************) 

(* Recursively apply the moves from solution_list to board *)

let rec apply_move_list board width height solution_list =
  match solution_list with
  | [] ->
      draw_board board width height;
      is_complete board width height;
  | head::tail -> 
      draw_board board width height;
      let _ = input_line stdin in
      let (x1, y1, x2, y2) = head in
      Printf.printf "(%d, %d) -> (%d, %d)\n" x1 y1 x2 y2;  
      let new_board = apply_move board width height x1 y1 x2 y2 in
      apply_move_list (!new_board) width height tail;;
  
(********************************************************************************)

(* Get the positions of all marbles on the board *)

let rec get_all_marble_positions board width height x y =
  if ((x + 1) == width) then (
    if ((y + 1) == height) then (
      if (is_marble board x y) then (
        [(x, y)];
      ) else (
        [];
      )
    ) else (
      let remaining_positions = get_all_marble_positions board width height 0 (y + 1) in
      if (is_marble board x y) then (
        (x, y) :: remaining_positions;
      ) else (
        remaining_positions;
      )
    )
  ) else (
    let remaining_positions = get_all_marble_positions board width height (x + 1) y in
    if (is_marble board x y) then (
      (x, y) :: remaining_positions;
    ) else (
      remaining_positions;
    )
  );;

(********************************************************************************)

(* Get the positions of all marbles on the board, starting at (0, 0) *)

let get_all_marble_positions board width height =
  get_all_marble_positions board width height 0 0;;

(********************************************************************************)

(* Test possible marble positions *)

let rec test_marbles board width height all_marble_positions =
  match all_marble_positions with
  | [] -> (false, []);
  | head::tail -> let (x, y) = head in
      let possible_moves = get_moves board width height x y in
      let (success, moves) = test_move board width height x y !possible_moves in 
      if(success) then (true, moves)
      else test_marbles board width height tail

(********************************************************************************)

(* Test possible moves *)

and test_move board width height x1 y1 possible_moves = 
  match possible_moves with
  | [] -> (false, []);
  | head::tail -> let (x2, y2) = head in
      let new_board = apply_move board width height x1 y1 x2 y2 in
      let (success, moves) = (solve (!new_board) width height) in
      if (success) then (true, (x1, y1, x2, y2)::moves)
      else (
        let (rec_success, rec_moves) = test_move board width height x1 y1 tail in
        if (rec_success) then (true, (x1, y1, x2, y2)::rec_moves)
        else (false, [])
      )
   
(********************************************************************************)

(* Check if board is solved, and if not, attempt to solve it *)

and solve board width height =
  if (is_complete board width height) then (
    draw_board board width height;
    (true, [])
  ) else (
    let all_marble_positions = get_all_marble_positions board width height in
    test_marbles board width height all_marble_positions;
  )

(********************************************************************************)

(* Solve the English Peg Solitaire board *)

let solve_english =
  draw_board english_board english_board_width english_board_height;
  let (success, moves) = solve english_board english_board_width english_board_height in  (
    if (success) then (
      Printf.printf "Success!\n";
      Printf.printf "Press ENTER to step through moves to complete puzzle\n\n";
      apply_move_list english_board english_board_width english_board_height moves;
    ) else (
      Printf.printf "No solution found!\n";
      apply_move_list english_board english_board_width english_board_height moves;
    )
  )