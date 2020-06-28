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
let large_solution = [(3,1,3,3);
                      (1,2,3,2);
                      (2,0,2,2);
                      (4,0,2,0);
                      (3,2,1,2);
                      (0,2,2,2);
                      (4,2,4,0);
                      (6,2,4,2);
                      (2,3,2,1);
                      (2,0,2,2);
                      (0,3,2,3);
                      (2,3,2,1);
                      (4,3,4,1);
                      (4,0,4,2);
                      (6,3,4,3);
                      (4,3,4,1);
                      (2,5,2,3);
                      (0,4,2,4);
                      (2,4,2,2);
                      (2,1,2,3);
                      (2,3,4,3);
                      (4,4,4,2);
                      (4,1,4,3);
                      (6,4,4,4);
                      (3,4,5,4);
                      (4,6,4,4);
                      (4,3,4,5);
                      (2,6,4,6);
                      (4,6,4,4);
                      (5,4,3,4);
                      (3,5,3,3)];;

(********************************************************************************)

let medium_board_width = 5;;
let medium_board_height = 5;;
let medium_board = [[void;   marble; marble; marble; void];
                    [marble; marble; marble; marble; marble];
                    [marble; marble; empty;  marble; marble];
                    [marble; marble; marble; marble; marble];
                    [void;   marble; marble; marble; void]];;

(********************************************************************************)

let small_board_width = 3;;
let small_board_height = 4;;
let small_board = [[marble; marble; marble];
                   [marble; marble; marble];
                   [marble; marble; marble];
                   [marble; marble; empty]];;

(********************************************************************************)

let int_to_string i =
  if (i == marble) then  " O " else (
    if (i == empty) then " - " else "   "
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

let one_if_marble board x y =
  if ((get_item board x y) == marble) then 1 else 0;;

(********************************************************************************)
                                                                                 
let rec is_complete board width height x y n =
  if (n > 1) then (
    false;
  ) else (
    if ((x + 1) == width) then (
      if ((y + 1) == height) then (
        true
      ) else (
        is_complete board width height 0 (y + 1) (n + (one_if_marble board x y))
      )
    ) else (
      is_complete board width height (x + 1) y (n + (one_if_marble board x y))
    )
  )


(********************************************************************************)
                                                                                 
let is_complete board width height =
  is_complete board width height 0 0 0;;
  
(********************************************************************************)

let apply_move board width height x1 y1 x2 y2 =
  Printf.printf "(%d, %d) -> (%d, %d)\n" x1 y1 x2 y2;
  let new_board = ref [] in
  let new_row = ref [] in
  let middle_x = ((x1 + x2) / 2) in
  let middle_y = ((y1 + y2) / 2) in
  
  let move_piece = get_item board x1 y1 in
  let middle_piece = get_item board middle_x middle_y in
  let target_pos = get_item board x2 y2 in
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

(*
let rec solve board width height =
  draw_board board width height;
  if (is_complete board width height) then (
    print_endline "Success!";
    true;
  ) else (
    for y = 0 to (height - 1) do 
      for x = 0 to (width - 1) do
        let possible_moves = get_moves board width height x y in
        for i = 0 to ((List.length (!possible_moves)) - 1) do
          let (x2, y2) = List.nth (!possible_moves) i in
          let new_board = apply_move board width height x y x2 y2 in
          solve (!new_board) width height
        done
      done
    done;
    false;
  );;
*)
  
  
(*
let rec do_stuff board width height x y possible_moves = 
  match possible_moves with
  | [] -> false;
  | head::tail -> let (x2, y2) = head in
      let new_board = apply_move board width height x y x2 y2 in
      if(solve (!new_board) width height 0 0) then true
      else do_stuff board width height x y tail
  
  
and solve board width height x y = 
    draw_board board width height;
  if (is_complete board width height) then (
    print_endline "Success!";
true;
) else (
  let possible_moves = get_moves board width height x y in
  do_stuff board width height x y !possible_moves    
)
  *)
  
(********************************************************************************)

(*
let solve_large =
  draw_board large_board large_board_width large_board_height;
  solve large_board large_board_width large_board_height;;
*)

(********************************************************************************)

(*
let solve_medium =
  draw_board medium_board medium_board_width medium_board_height;
  solve medium_board medium_board_width medium_board_height;;
*)

(********************************************************************************)
(*  
let solve_small =
  draw_board small_board small_board_width small_board_height;
  solve small_board small_board_width small_board_height 0 0;;
*)
(********************************************************************************) 

let rec apply_move_list board width height solution_list =
  match solution_list with
  | [] ->
      draw_board board width height;
      is_complete board width height;
  | head::tail -> 
      draw_board board width height;
      let _ = input_line stdin in
      let (x1,y1,x2,y2) = head in
      let new_board = apply_move board width height x1 y1 x2 y2 in
      apply_move_list (!new_board) width height tail;;

let cheat_large =  
  apply_move_list large_board large_board_width large_board_height large_solution;; 