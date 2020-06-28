exception SolitaireException of string;;
    
let void = 0;;
let empty = 1;;
let marble = 2;;

(********************************************************************************)

let large_board_width = 7;;
let large_board_height = 7;;
let large_board = [[void;   void;   marble; marble; marble; void;   void];
                   [void;   void;   marble; marble; marble; void;   void];
                   [marble; marble; marble; marble; marble; marble; marble];
                   [marble; marble; marble; empty;  marble; marble; marble];
                   [marble; marble; marble; marble; marble; marble; marble];
                   [void;   void;   marble; marble; marble; void;   void];
                   [void;   void;   marble; marble; marble; void;   void]];;

(********************************************************************************)

let medium_board_width = 5;;
let medium_board_height = 5;;
let medium_board = [[void;   marble; marble; marble; void];
                    [marble; marble; marble; marble; marble];
                    [marble; marble; empty;  marble; marble];
                    [marble; marble; marble; marble; marble];
                    [void;   marble; marble; marble; void]];;

(********************************************************************************)

let int_to_string i =
  if (i == marble) then  " O " else (
    if (i == empty) then " - " else "   ";
  );;
  
(********************************************************************************)

let get_row board y =
  List.nth board y;;  
  
(********************************************************************************)

let get_item board x y = 
  List.nth (get_row board y) x;;

(********************************************************************************)

let draw_board board width height = 
  Printf.printf "  ";
  for x = 0 to (width - 1) do
    Printf.printf " %d " x;
  done;
  Printf.printf "\n";
    
  for y = 0 to (height - 1) do 
    Printf.printf "%d " y;
    for x = 0 to (width - 1)  do
      Printf.printf "%s" (int_to_string(get_item board x y));
    done;
    Printf.printf "\n";
  done;
  Printf.printf "\n";
  flush stdout;;  

(********************************************************************************)

let is_complete board width height = 
  let total_marbles = ref 0 in
  for y = 0 to (height - 1) do 
    for x = 0 to (width - 1)  do
      if ((get_item board x y) == marble) then (
        total_marbles := (!total_marbles) + 1;
      )
    done;
  done;
  (!total_marbles) == 1;;

(********************************************************************************)

let apply_move board width height x1 y1 x2 y2 =
  (* Printf.printf "(%d, %d) -> (%d, %d)\n" x1 y1 x2 y2; *)
  let new_board = ref [] in
  let new_row = ref [] in
  let middle_x = ((x1 + x2) / 2) in
  let middle_y = ((y1 + y2) / 2) in
  for y = 0 to (height - 1) do 
    for x = 0 to (width - 1) do
      if ((x == x1) && (y == y1)) then 
        new_row := empty :: (!new_row)
      else (
        if ((x == middle_x) && (y == middle_y)) then
          (
            new_row := empty :: (!new_row)
          ) else (
          if ((x == x2) && (y == y2)) then (
            new_row := marble :: (!new_row)
          ) else (
            new_row := (get_item board x y) :: (!new_row);
          )
        )
      )
    done;
    new_board := (!new_row) :: (!new_board);
    new_row := [];
  done;
  new_board;;
  
(********************************************************************************)

let get_moves board width height x y =
  let moves = ref [] in
  let move_piece = get_item board x y in
  if (move_piece == marble) then (
    if ((x - 2) >= 0) then (
      let jump_over = get_item board (x - 1) y in
      let target = get_item board (x - 2) y in
      if ((jump_over == marble) && (target == empty)) then (
        moves := (x - 2, y) :: (!moves);
      )
    );
    if ((x + 2) < width) then (
      let jump_over = get_item board (x + 1) y in
      let target = get_item board (x + 2) y in
      if ((jump_over == marble) && (target == empty)) then (
        moves := (x + 2, y) :: (!moves);
      )
    );
    if ((y - 2) >= 0) then (
      let jump_over = get_item board x (y - 1) in
      let target = get_item board x (y - 2) in
      if ((jump_over == marble) && (target == empty)) then (
        moves := (x, y - 2) :: (!moves);
      )
    );
    if ((y + 2) < height) then (
      let jump_over = get_item board x (y + 1) in
      let target = get_item board x (y + 2) in
      if ((jump_over == marble) && (target == empty)) then (
        moves := (x, y + 2) :: (!moves);
      )
    );
  );
  moves;;
  
(********************************************************************************)

let rec solve board width height =
  (*let str = input_line stdin in*)
  if (is_complete board width height) then (
    draw_board board width height;
    raise (SolitaireException ("It worked"));
  ) else (
    for y = 0 to (height - 1) do 
      for x = 0 to (width - 1) do
        let possible_moves = get_moves board width height x y in
        for i = 0 to ((List.length (!possible_moves)) - 1) do
          let (x2, y2) = List.nth (!possible_moves) i in
          let new_board = apply_move board width height x y x2 y2 in
          solve (!new_board) width height;
        done;
      done;
    done;
    false;
  );;
  
(********************************************************************************)

let do_stuff =
  draw_board medium_board medium_board_width medium_board_height;
  solve medium_board medium_board_width medium_board_height;;