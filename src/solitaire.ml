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
  Printf.printf "      +---------+\n";
  Printf.printf "      |%s%s%s|\n"       (int_to_string(get_item board 2 0)) (int_to_string(get_item board 3 0)) (int_to_string(get_item board 4 0));
  Printf.printf "+-----+%s%s%s+-----+\n" (int_to_string(get_item board 2 1)) (int_to_string(get_item board 3 1)) (int_to_string(get_item board 4 1));
  Printf.printf "|%s%s%s%s%s%s%s|\n"     (int_to_string(get_item board 0 2)) (int_to_string(get_item board 1 2)) (int_to_string(get_item board 2 2)) (int_to_string(get_item board 3 2)) (int_to_string(get_item board 4 2)) (int_to_string(get_item board 5 2)) (int_to_string(get_item board 6 2));
  Printf.printf "|%s%s%s%s%s%s%s|\n"     (int_to_string(get_item board 0 3)) (int_to_string(get_item board 1 3)) (int_to_string(get_item board 2 3)) (int_to_string(get_item board 3 3)) (int_to_string(get_item board 4 3)) (int_to_string(get_item board 5 3)) (int_to_string(get_item board 6 3));
  Printf.printf "|%s%s%s%s%s%s%s|\n"     (int_to_string(get_item board 0 4)) (int_to_string(get_item board 1 4)) (int_to_string(get_item board 2 4)) (int_to_string(get_item board 3 4)) (int_to_string(get_item board 4 4)) (int_to_string(get_item board 5 4)) (int_to_string(get_item board 6 4));
  Printf.printf "+-----+%s%s%s+-----+\n" (int_to_string(get_item board 2 5)) (int_to_string(get_item board 3 5)) (int_to_string(get_item board 4 5));
  Printf.printf "      |%s%s%s|\n"       (int_to_string(get_item board 2 6)) (int_to_string(get_item board 3 6)) (int_to_string(get_item board 4 6));
  Printf.printf "      +---------+\n";    
  flush stdout;;

let apply_move board x1 y1 x2 y2 =
  let new_board = ref [] in
  let new_row = ref [] in
  for y = 6 downto 0 do 
    for x = 6 downto 0 do
      new_row := (get_item board x y) :: (!new_row);
    done;
    new_board := (!new_row) :: (!new_board);
    new_row := [];
  done;
  new_board;;
  
let make_move board x1 y1 x2 y2 = 
  let move_piece = get_item board x1 y1 in
  let target_pos = get_item board x2 y2 in
  if (move_piece != _MARBLE_) then (raise (SolitaireException ("(" ^ string_of_int(x1) ^ ", " ^ string_of_int(y1) ^ ") is not a marble" ))) else (
    if (target_pos != _EMPTY__) then (raise (SolitaireException ("(" ^ string_of_int(x2) ^ ", " ^ string_of_int(y2) ^ ") is not empty" ))) else (
      apply_move board x1 y1 x2 y2;
    );
  );;

draw_board (!(make_move start_board 3 1 3 3));;