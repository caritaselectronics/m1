open List;;

(* fonction qui teste si une liste contient un nombre négatif*)
let rec contains_neg l =
  match l with
  |[]-> (false,0)
  |[a] -> (a<=0,a)

  |a::l' -> begin
	    if a<0 then (true,a) else
	      contains_neg l'
	  end
  	      
;;
(*retrouve dans une liste un composition gagnante pour le predeceuseur le coût est 0(n) *)

  
(* fontiion qui calcule le max dans une liste coût =O(n) 
elle est recursive terminale*)  
let rec  max_l l =
  match l with
  | [x] -> x
   |x::l' -> (max x (max_l l'))
(* |_ -> failwith "this case should never happen possible calculating max on empty list"*)
;;
  
let rec sum_l l =
  match l with
  |[] -> 0
  |_ -> (hd l) + sum_l (tl l)
;;
let rec  min_l l =
  match l with
  | [x] -> x
   |x::l' -> (min x (min_l l'))
   |[] -> failwith "this case should never happen possible calculating max on empty list"
;;

	       
let change_pos_to a b = if (b > 0) then a else  b 
;;
  


(*fonction qui calcule le max parmis les negatifs d'une liste le premier parametre entier doit etre un entier negatif de cette même liste que l'on a recuperer lors du contain_neg*)
  
  let rec max_negatif l a = 
  match l with
  |[b] -> begin
	  if (b<0 )then
	    max a b
	  else
	    a
	end
	    
  |b::l ->begin
	if (b < 0) then
	  max_negatif l (max b a)
	else
	  max_negatif l a
	 end

  |[]-> failwith "this case should never happen "

		 
  let mat_formule l =
    match l with
    |[] -> failwith "function mat_frormule : th function is colled on a empty list\n"
    |_ -> begin
	  let p = contains_neg l in 
  if (not (fst(p)))then (-1)*(1+max_l l)
  else
    (abs (max_negatif l  (snd p)))+1
	end
	    
;;
let poss_adv (m,n,t,s) =
  if (m,n,t,s) = (1,1,1,1) then [(m,n,t,s)]
  else
    begin   
  let l = ref  []
  and j = t
  and k = s
    
and  i = ref 1 in 
  while (!i<j )do
    l := ((m -(!i)),n,(j-(!i)),k)::!l ;
    i:= !i+1;
  done;
  i:= 1;
  while (!i<= (m-j))do
    l:=((m-(!i)),n,(j),k)::!l;
    i:= !i+1;
		       
  done;
  i:=1;
  while (!i<k) do
    l := (m,(n-(!i)),j,k-(!i))::!l ;
    i:= !i+1;
  done;
  i :=1 ;
   while (!i<= (n-k))do
     l:=(m,(n-(!i)),j,(k))::!l;
     i:=!i+1;
			       
  done;
   !l
    end
      
  ;;
    
  		    
		    
    
let rec f_n (m,n,i,j) =
  match (m,n,i,j)with
  |(1,1,1,1) -> 0
  |(2,1,2,1) -> (1)
  |(1,2,1,2) ->(1)
  (*  |(m,n,1,j) -> (mat_formule [(f(1,n,1,j));(f(m,j,1,j));(f(m,n-j,1,1))])*)
  |(m,n,i,j)->  begin print_string "f()";
		      mat_formule (map (f_n) (poss_adv (m,n,i,j)))
				  
		end
		  
;;
 
let matrix_index t (m,n,j,k) =
  let t' = t.(m).(n) in
  t'.(j).(k)

;;
  
  

(*parcourir toute la matrice en faisan make matrix pour chaque celulle*)
  

  
  

let  f_d (m,n,i,j)=
  let t = ref (Hashtbl.create ~random:false (m*n)) in
   Hashtbl.add (!t) (1,1,1,1) 0 ;
  let rec f (m,n,j,k)  =  
  begin print_string "f()";
		      try (Hashtbl.find (!t) (m,n,j,k)) with
			not_found -> begin
			  Hashtbl.add (!t) (m,n,j,k) (mat_formule (map (f) (poss_adv (m,n,i,j))));
			  0 
			end
				       
		end
	      
		
  in
  
 
  f (m,n,i,j) ;
 (Hashtbl.find (!t) (m,n,i,j))   
;;
  
