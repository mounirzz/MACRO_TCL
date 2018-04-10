 	 ##############################################################################################################################################

    # Purpose: For each element in a HyperMesh model, build a list where the contents of the list are as follows 

    # Args: None

    # Returns: None

##############################################################################################################################################	   
# Demande a user le selectiooner le composents doit etre traduit 
*createmarkpanel comps 1 "Select Component";
set Select_comps [hm_getmark comps 1]
hm_markclear comps 1;
# Sur le composents selectionner récuperer les info {nom / id du composent et liste ids des elements ,
# liste ids des nodes }
foreach i $Select_comps {
	set cname [hm_entityinfo name components $i]
	set elems_list [hm_elemlist id $cname]
	eval *createmark elems 1 $elems_list
	#Rechercher les nodes dans l'element
	*findmark elems 1 1 0 nodes 0 2;
	set nodes_list [hm_getmark nodes 2]
	#Renvoir le nombre d'element & de nodes de la liste
	set num_node [llength $nodes_list]
	set num_elem [llength $elems_list]
	#Affichage du resultat ELEMENT {NODE1 , NODE2 , NODE3 ...}
	puts [format "ELEMENT= Nodes,%d,%d,%s" $i $num_elem [join $nodes_list ","]] 
	#puts [format "NODES,"]
	#"NODES,%d,%d,%s" $num_node [join $nodes_list ","]]
	#puts [format "CompID= %d CompName= %s ELEMENT=%d Nodes=%d" $i $cname $elems_list $nodes_list]
	*clearmark elems 1;
	*clearmark nodes 2;
}
set cname [hm_entityinfo name components $i]
	set elemnodes [list]
	#List des élements qui compose des ids et de nom de composent
	set elems [hm_elemlist id $cname]
	# Renvoie d'élement de la liste element 1 a une autre liste d'element 
	set num_elem [llength $elems]
	# Concatène les éléments d’une liste en une seule liste de nodes
	foreach curele $elems {	;
		set elemnodes [concat $elemnodes [hm_nodelist $curele]]
	}
	# format de node est entier -integer
	set elemnodes [  -integer -unique $elemnodes]
	set num_nods [llength $elemnodes]
	# Recupere les coordonnées x,y et z du nodes dans la liste des éléments  
	foreach nodeid $elemnodes {
		foreach {x y z} [expr [hm_nodevalue $nodeid]] {break}
		}
# recupere l'id de chaque element trouver
foreach elemid $elems {
		set elemconfig [hm_getentityvalue elems $elemid config 0 -byid]
#		puts $elemconfig
	#Détecte un autre processus lent dans la recherche de point de grille pour chaque élément
		switch $elemconfig {
			204 {
			set elem_info "TETRA  ,"
			append elem_info "[format %8i $elemid] , 1 , [hm_getentityvalue elems $elemid node3 0 -byid] , 
			[hm_getentityvalue elems $elemid node1 0 -byid] , 
			[hm_getentityvalue elems $elemid node2 0 -byid] ,
			 [hm_getentityvalue elems $elemid node4 0 -byid]   "
			}
		}
			append elem_info ", "
			append content  "\n $elem_info"
		}

	   # Créer un noeud au centroïde de l'élément. Traduire le nœud dans la direction
		# positive de l'élément normal d'une quantité égale à la plus courte diagonale
		 # d'un élément quad et au plus petit côté d'un élément tria. Créez un élément 
		  # tétra ou un élément pyramide en utilisant la liste de nœuds d'élément d'origine
		   # et le nouveau nœud créé par le script.

