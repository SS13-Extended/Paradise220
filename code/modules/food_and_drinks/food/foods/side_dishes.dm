
//////////////////////
//		Raw			//
//////////////////////

/obj/item/reagent_containers/food/snacks/rawsticks
	name = "raw potato sticks"
	desc = "Raw fries, not very tasty."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "rawsticks"
	list_reagents = list("plantmatter" = 3)
	tastes = list("raw potatoes" = 1)
	foodtype = VEGETABLES | RAW | GROSS


//////////////////////
//		Fried		//
//////////////////////

/obj/item/reagent_containers/food/snacks/fries
	name = "space fries"
	desc = "AKA: French Fries, Freedom Fries, etc."
	icon_state = "fries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	list_reagents = list("nutriment" = 4)
	tastes = list("fries" = 3, "salt" = 1)
	foodtype = VEGETABLES | FRIED

/obj/item/reagent_containers/food/snacks/cheesyfries
	name = "cheesy fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"
	list_reagents = list("nutriment" = 6)
	tastes = list("fries" = 3, "cheese" = 1)
	foodtype = VEGETABLES | FRIED | DAIRY

/obj/item/reagent_containers/food/snacks/tatortot
	name = "tator tot"
	desc = "A large fried potato nugget that may or may not try to valid you."
	icon_state = "tatortot"
	list_reagents = list("nutriment" = 4)
	filling_color = "FFD700"
	tastes = list("fried potato" = 3, "valids" = 1)
	foodtype = VEGETABLES | FRIED

/obj/item/reagent_containers/food/snacks/onionrings
	name = "onion rings"
	desc = "Onion slices coated in batter."
	icon_state = "onionrings"
	list_reagents = list("nutriment" = 3)
	filling_color = "#C0C9A0"
	gender = PLURAL
	tastes = list("onion" = 3, "batter" = 1)
	foodtype = VEGETABLES | FRIED

/obj/item/reagent_containers/food/snacks/carrotfries
	name = "carrot fries"
	desc = "Tasty fries from fresh carrots."
	icon_state = "carrotfries"
	trash = /obj/item/trash/plate
	filling_color = "#FAA005"
	list_reagents = list("plantmatter" = 3, "oculine" = 3, "vitamin" = 2)
	tastes = list("carrots" = 3, "salt" = 1)
	foodtype = VEGETABLES | FRIED


//////////////////////
//		Misc		//
//////////////////////

/obj/item/reagent_containers/food/snacks/beans
	name = "tin of beans"
	desc = "Musical fruit in a slightly less musical container."
	icon_state = "beans"
	list_reagents = list("nutriment" = 10, "beans" = 10, "vitamin" = 3)
	tastes = list("beans" = 1)
	foodtype = VEGETABLES

/obj/item/reagent_containers/food/snacks/mashed_potatoes //mashed taters
	name = "mashed potatoes"
	desc = "Some soft, creamy, and irresistible mashed potatoes."
	icon_state = "mashedtaters"
	trash = /obj/item/trash/plate
	filling_color = "#D6D9C1"
	list_reagents = list("nutriment" = 5, "gravy" = 5, "mashedpotatoes" = 10, "vitamin" = 2)
	tastes = list("mashed potato" = 3, "gravy" = 1)
	foodtype = VEGETABLES

/obj/item/reagent_containers/food/snacks/stuffing
	name = "stuffing"
	desc = "Moist, peppery breadcrumbs for filling the body cavities of dead birds. Dig in!"
	icon_state = "stuffing"
	filling_color = "#C9AC83"
	list_reagents = list("nutriment" = 3)
	tastes = list("bread crumbs" = 1, "herbs" = 1)
	foodtype = VEGETABLES | GRAIN

/obj/item/reagent_containers/food/snacks/loadedbakedpotato
	name = "loaded baked potato"
	desc = "Totally baked."
	icon_state = "loadedbakedpotato"
	filling_color = "#9C7A68"
	list_reagents = list("nutriment" = 6)
	tastes = list("potato" = 1, "cheese" = 1, "herbs" = 1)
	foodtype = VEGETABLES | DAIRY

/obj/item/reagent_containers/food/snacks/boiledrice
	name = "boiled rice"
	desc = "A boring dish of boring rice."
	icon_state = "boiledrice"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"
	list_reagents = list("nutriment" = 5, "vitamin" = 1)
	tastes = list("rice" = 1)
	foodtype = GRAIN

/obj/item/reagent_containers/food/snacks/roastparsnip
	name = "roast parsnip"
	desc = "Sweet and crunchy."
	icon_state = "roastparsnip"
	trash = /obj/item/trash/plate
	list_reagents = list("nutriment" = 3, "vitamin" = 4)
	filling_color = "#FF5500"
	tastes = list("parsnip" = 1)
	foodtype = VEGETABLES

/obj/item/reagent_containers/food/snacks/plov
	name = "Plov"
	desc = "Mix of rice and vegetables."
	icon_state = "plov"
	trash = /obj/item/trash/plate
	list_reagents = list("nutriment" = 6, "protein" = 6, "plantmatter" = 6)
	tastes = list("boiledrice"= 1, "rawcutlet" = 1, "onion" = 1)
	foodtype = VEGETABLES | MEAT | GRAIN
