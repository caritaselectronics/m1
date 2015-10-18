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
 |[] -> failwith "this case should never happen possible calculating max on empty list"
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
let poss_adv (m,n,j,k) =
  if (m,n,j,k) = (1,1,1,1) then [(m,n,j,k)]
  else
    begin   
  let l = ref  []
  
    
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
  

(*q4 programmation dynamique


 
une version utilisant les tables de hachage de caml*)  
  

let  f_d (o,p,s,v)=
  let t = ref (Hashtbl.create ~random:false (o*p)) in
   Hashtbl.add (!t) (1,1,1,1) 0 ;
  let rec f (m,n,j,k)  =  
   
    
	try (Hashtbl.find (!t) (m,n,j,k)) with
	|not_found -> begin
		      	
			
		      Hashtbl.add (!t) (m,n,j,k) (mat_formule (map (f) (poss_adv (m,n,j,k))));
		      
			Hashtbl.find (!t) (m,n,j,k)
			end
				       
				       
	       
	      
		
  in
  f (o,p,s,v)    
;;
  
let f_d_2 (o,p,s,v) =
  let t = Array.make_matrix o p (Array.make_matrix s v 0) in
  for i=0 to o-1 do
    for j = 0 to p-1 do
      t.(i).(j)<- Array.make_matrix s v 0
    done
  done
  ;
    t.(0).(0).(0).(0) <- 0 ;
  
let rec f (m,n,j,k) =
  match (m,n,j,k) with
  |(1,1,1,1) -> 0
  |_  -> begin
	
      if(t.(m-1).(n-1).(j-1).(k-1) == 0) then
	begin
	  t.(m-1).(n-1).(j-1).(k-1)<- (mat_formule (map (f) (poss_adv (m,n,j,k))));
	  t.(m-1).(n-1).(j-1).(k-1)
	end
	  
      else
	t.(m-1).(n-1).(j-1).(k-1)
       end
       ;
	 

in 			      
    f(o,p,s,v)
;;

  (*accelleration*)


let f_d_2_a (o,p,s,v) =
  let x = max o p
  and y = max s v in 
  let t = Array.make_matrix x x (Array.make_matrix y y 0) in
  for i=0 to x-1 do
    for j = 0 to x-1 do
      t.(i).(j)<- Array.make_matrix y y 0
    done
  done
  ;
    t.(0).(0).(0).(0) <- 0 ;
  
  
let rec f (m,n,j,k) =
  match (m,n,j,k) with
  |(1,1,1,1) -> 0
  |_  -> begin
	
      if(t.(m-1).(n-1).(j-1).(k-1) == 0) then
	begin
	  let r = (mat_formule (map (f) (poss_adv (m,n,j,k)))); in
	  t.(m-1).(n-1).(j-1).(k-1)<- r ;
	  t.(m-1).(n-1).(j-1).(n-k)<- r ;
	  t.(m-1).(n-1).(m-j).(k-1)<- r ;
	  t.(m-1).(n-1).(m-j).(n-k)<- r ;
	  t.(n-1).(m-1).(k-1).(j-1)<- r ;
	t.(n-1).(m-1).(k-1).(m-j)<- r ;
	  t.(n-1).(m-1).(n-k).(j-1)<- r ;
	  t.(n-1).(m-1).(n-k).(m-j)<- r ;				
	  t.(m-1).(n-1).(j-1).(k-1)
	end
	  
      else
	t.(m-1).(n-1).(j-1).(k-1)
       end
       ;
	 

in 			      
    f(o,p,s,v)
;;
 

let  f_d_a (o,p,s,v)=
  let t = ref (Hashtbl.create ~random:false (o*p)) in
   Hashtbl.add (!t) (1,1,1,1) 0 ;
  let rec f (m,n,j,k)  =  
   
    
	try (Hashtbl.find (!t) (m,n,j,k)) with
	|not_found -> begin
		      let r = (mat_formule (map (f) (poss_adv (m,n,j,k)))) in 
			
		      Hashtbl.add (!t) (m,n,j,k) r;
		      Hashtbl.add (!t) (m,n,(m-j+1),k) r;
		      Hashtbl.add (!t) (m,n,j,(n-k+1)) r;
		      Hashtbl.add (!t) (m,n,(m-j+1),(n-k+1)) r;
		      Hashtbl.add (!t) (n,m,k,j) r;
		      Hashtbl.add (!t) (n,m,(n-k+1),j) r;
		      Hashtbl.add (!t) (n,m,k,(m-j+1)) r;
		      Hashtbl.add (!t) (n,m,(n-k+1),(m-j+1)) r;
		      


		      
			Hashtbl.find (!t) (m,n,j,k)
			end
				       
				       
	       
	      
		
  in
  f (o,p,s,v)    
;;





(*moteur du jeu*)

(*adapatation de la fonction pour la decision du moteur 
in : une composition 
out: couple  valeur de la composition et tableau ayant servi pour le calcul *)
  
let f_d_2_a_m (o,p,s,v) =
  let x = max o p
  and y = max s v in 
  let t = Array.make_matrix x x (Array.make_matrix y y 0) in
  for i=0 to x-1 do
    for j = 0 to x-1 do
      t.(i).(j)<- Array.make_matrix y y 0
    done
  done
  ;
    t.(0).(0).(0).(0) <- 0 ;
  
  
let rec f (m,n,j,k) =
  match (m,n,j,k) with
  |(1,1,1,1) -> 0
  |_  -> begin
	
      if(t.(m-1).(n-1).(j-1).(k-1) == 0) then
	begin
	  let r = (mat_formule (map (f) (poss_adv (m,n,j,k)))); in
	  t.(m-1).(n-1).(j-1).(k-1)<- r ;
	  t.(m-1).(n-1).(j-1).(n-k)<- r ;
	  t.(m-1).(n-1).(m-j).(k-1)<- r ;
	  t.(m-1).(n-1).(m-j).(n-k)<- r ;
	  t.(n-1).(m-1).(k-1).(j-1)<- r ;
	t.(n-1).(m-1).(k-1).(m-j)<- r ;
	  t.(n-1).(m-1).(n-k).(j-1)<- r ;
	  t.(n-1).(m-1).(n-k).(m-j)<- r ;				
	  t.(m-1).(n-1).(j-1).(k-1)
	end
	  
      else
	t.(m-1).(n-1).(j-1).(k-1)
       end
       ;
	 

in 			      
((f(o,p,s,v)),(t))

;;
 

  
 let coup l =
    match l with
    |[] -> failwith "function mat_frormule : th function is colled on a empty list\n"
    |_ -> begin
	  let p = contains_neg l in 
  if (not (fst(p)))then max_l l
  else
     (max_negatif l  (snd p))
	end
	    
 ;;

   
 (*trouve un coup  dont la valeur associé est donnée en paramettre
in : une liste de couple composition valeur
     une valeur dont l'on cherche la composition(m,n,j,k)    
out : une composition (m,n,j,k) associé à cette valeur *) 
   
 let rec find_coup l i =
   match l with
   |[] -> failwith "composition not found reaching the end of a list with out anny matching pattern"
   |a::l' ->begin
	     if ((snd a) == i) then
	       fst a
	     else
	       find_coup l' i
	   end
 ;;
 (*retourne le coup jouer par le moteur = la nouvelle composition de la tablette *)
   
 let coup (m,n,j,k)=
   let l = poss_adv (m,n,j,k) 
   and c = f_d_2_a_m (m,n,j,k)
   in
   
   let  f  t  (o,p,q,r) = ((o,p,q,r),(t.(o).(p).(q).(r)))
   in
   let ll = map (f (snd c)) l in
   if ((fst c) >0) then
     find_coup ll ((-1)*((fst c)-1))
   else
     find_coup ll (abs ((fst c)+1))
 ;;
   
 (*imprime sur la sortie standard une composition sur forme de o et la case empoisonée une étoile*)   
   
let print_conf (m,n,j,k) =
  print_char '(' ;
  print_int m ;
  print_char ',' ;
  print_int n;
  print_char ',' ;
  print_int j;
  print_char ',';
  print_int k;
  print_char ')' ;
  print_endline "" ;


  let t =  Array.make_matrix n m 'o' in
  t.(k-1).(j-1)<- '*' ;
  for i = 0 to (n-1) do
    for v = 0 to (m-1) do
      print_char (t.(i).(v))
    done ;
      print_endline "" ;
  done;
    print_endline
;;
  
    
let main () =
  let m = ref 0
  and n = ref 0
  and j =ref 0
  and k = ref 0
  and fini = ref true ;
  and rbt = ref (0,0,0,0)
  and jr = ref (0,0,0,0)
    
  in
  while (!fini) do
    
  print_endline " une compsotion (m,n,j,k) sous forme de quatre entier succesisif et appuyer sur enter " ;
  
  print_endline " m => ";
  m:= read_int () ;
print_endline " n => ";
  n:= read_int ();
		
print_endline " j => ";
  j:= read_int ();
      
print_endline " k => ";
  k:= read_int ();
  rbt := ((!m),(!n),(!j),(!k));
  print_endline "joueur : Vous avez joué " ;
  print_conf(!rbt) ;
		
  print_endline "robot : j'ai joué " ;
  jr := coup (!rbt);
  print_conf (!jr)  ;
  if (!rbt == (1,1,1,1))then
    
    fini := false ;
  print_endline  "felicitation vous avez gagné je vais m'entrainner pour m'ameliorer" ;
  
  if (!jr == (1,1,1,1)) then
     fini := false ;
    print_endline " dommage vous avez perdu mais Robot s'est bien amusé ";
		   
  done ;

 
    
