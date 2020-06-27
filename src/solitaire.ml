exception SolitaireException of string;;
    
let __VOID__ = 0;;
let _EMPTY__ = 1;;
let _MARBLE_ = 2;;

let int_to_string i =
  if (i = _MARBLE_) then  " O " else "   ";;

let start_board = [[__VOID__;__VOID__;_MARBLE_;_MARBLE_;_MARBLE_;__VOID__;__VOID__];
                   [__VOID__;__VOID__;_MARBLE_;_MARBLE_;_MARBLE_;__VOID__;__VOID__];
                   [_MARBLE_;_MARBLE_;_MARBLE_;_MARBLE_;_MARBLE_;_MARBLE_;_MARBLE_];
                   [_MARBLE_;_MARBLE_;_MARBLE_;_EMPTY__;_MARBLE_;_MARBLE_;_MARBLE_];
                   [_MARBLE_;_MARBLE_;_MARBLE_;_MARBLE_;_MARBLE_;_MARBLE_;_MARBLE_];
                   [__VOID__;__VOID__;_MARBLE_;_MARBLE_;_MARBLE_;__VOID__;__VOID__];
                   [__VOID__;__VOID__;_MARBLE_;_MARBLE_;_MARBLE_;__VOID__;__VOID__]];;
  
let get_row b y = List.nth b y;;  
let get_item b x y = List.nth (get_row b y) x;;

let draw_board board = 
  Printf.printf "    0  1  2  3  4  5  6\n";
  Printf.printf "        +---------+\n";
  Printf.printf "0       |%s%s%s|\n"       (int_to_string(get_item board 2 0)) (int_to_string(get_item board 3 0)) (int_to_string(get_item board 4 0));
  Printf.printf "1 +-----+%s%s%s+-----+\n" (int_to_string(get_item board 2 1)) (int_to_string(get_item board 3 1)) (int_to_string(get_item board 4 1));
  Printf.printf "2 |%s%s%s%s%s%s%s|\n"     (int_to_string(get_item board 0 2)) (int_to_string(get_item board 1 2)) (int_to_string(get_item board 2 2)) (int_to_string(get_item board 3 2)) (int_to_string(get_item board 4 2)) (int_to_string(get_item board 5 2)) (int_to_string(get_item board 6 2));
  Printf.printf "3 |%s%s%s%s%s%s%s|\n"     (int_to_string(get_item board 0 3)) (int_to_string(get_item board 1 3)) (int_to_string(get_item board 2 3)) (int_to_string(get_item board 3 3)) (int_to_string(get_item board 4 3)) (int_to_string(get_item board 5 3)) (int_to_string(get_item board 6 3));
  Printf.printf "4 |%s%s%s%s%s%s%s|\n"     (int_to_string(get_item board 0 4)) (int_to_string(get_item board 1 4)) (int_to_string(get_item board 2 4)) (int_to_string(get_item board 3 4)) (int_to_string(get_item board 4 4)) (int_to_string(get_item board 5 4)) (int_to_string(get_item board 6 4));
  Printf.printf "5 +-----+%s%s%s+-----+\n" (int_to_string(get_item board 2 5)) (int_to_string(get_item board 3 5)) (int_to_string(get_item board 4 5));
  Printf.printf "6       |%s%s%s|\n"       (int_to_string(get_item board 2 6)) (int_to_string(get_item board 3 6)) (int_to_string(get_item board 4 6));
  Printf.printf "        +---------+\n";    
  flush stdout;;

let is_complete board = 
  let total_marbles = ref 0 in
  for y = 6 downto 0 do 
    for x = 6 downto 0 do
      if ((get_item board x y) == _MARBLE_) then 
        total_marbles := (!total_marbles) + 1;
    done;
  done;
  (!total_marbles) == 1;;

let apply_move board x1 y1 x2 y2 =
  Printf.printf "(%d, %d) -> (%d, %d)\n" x1 y1 x2 y2;
  let new_board = ref [] in
  let new_row = ref [] in
  for y = 6 downto 0 do 
    for x = 6 downto 0 do
      if ((x == x1) && (y == y1)) then 
        new_row := _EMPTY__ :: (!new_row)
      else (
        if ((x == x2) && (y == y2)) then (
          new_row := _MARBLE_ :: (!new_row)
        ) else (
          new_row := (get_item board x y) :: (!new_row);
        )
      )
    done;
    new_board := (!new_row) :: (!new_board);
    new_row := [];
  done;
  new_board;;
  
(* Do we still need this function? *)
let make_move board x1 y1 x2 y2 = 
  let move_piece = get_item board x1 y1 in
  let target_pos = get_item board x2 y2 in
  if (move_piece != _MARBLE_) then (raise (SolitaireException ("(" ^ string_of_int(x1) ^ ", " ^ string_of_int(y1) ^ ") is not a marble" ))) else (
    if (target_pos != _EMPTY__) then (raise (SolitaireException ("(" ^ string_of_int(x2) ^ ", " ^ string_of_int(y2) ^ ") is not empty" ))) else (
      apply_move board x1 y1 x2 y2;
    );
  );;

let get_moves board x y =
  let moves = ref [] in
  let move_piece = get_item board x y in
  if (move_piece == _MARBLE_) then (
    if ((x - 2) >= 0) then (
      let jump_over = get_item board (x - 1) y in
      let target = get_item board (x - 2) y in
      if ((jump_over == _MARBLE_) && (target == _EMPTY__)) then (
        moves := (x - 2, y) :: (!moves);
      )
    );
    if ((x + 2) <= 6) then (
      let jump_over = get_item board (x + 1) y in
      let target = get_item board (x + 2) y in
      if ((jump_over == _MARBLE_) && (target == _EMPTY__)) then (
        moves := (x + 2, y) :: (!moves);
      )
    );
    if ((y - 2) >= 0) then (
      let jump_over = get_item board x (y - 1) in
      let target = get_item board x (y - 2) in
      if ((jump_over == _MARBLE_) && (target == _EMPTY__)) then (
        moves := (x, y - 2) :: (!moves);
      )
    );
    if ((y + 2) <= 6) then (
      let jump_over = get_item board x (y + 1) in
      let target = get_item board x (y + 2) in
      if ((jump_over == _MARBLE_) && (target == _EMPTY__)) then (
        moves := (x, y + 2) :: (!moves);
      )
    );
  );
  moves;;
  
let rec solve board = 
  draw_board board;
  if (is_complete board) then (
    true;
  ) else (
    for y = 0 to 6 do 
      for x = 0 to 6 do
        let possible_moves = get_moves board x y in
        for i = 0 to ((List.length (!possible_moves)) - 1) do
          let (x2, y2) = List.nth (!possible_moves) i in
          let new_board = make_move board x y x2 y2 in
          solve (!new_board);
        done;
      done;
    done;
    false;
  );;

(* get_moves start_board 6 0;; *)

solve start_board;;