(defmodule MAIN (export ?ALL))

;;;***************
;;;DEFINE FUNCTIONS
;;;****************

(deffunction MAIN::ask-question (?question ?allowed-values)
   (print ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) then (bind ?answer (lowcase ?answer)))
   (while (not (member$ ?answer ?allowed-values)) do
      (print ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) then (bind ?answer (lowcase ?answer))))
   ?answer)
   
   
;;;***********
;;;START
;;;***********

(deftemplate MAIN::attribute
   (slot name)
   (slot value))
   
(defrule MAIN::start
  (declare (salience 10000))
  =>
  (set-fact-duplication TRUE)
  (focus QUESTIONS CHOOSE-QUALITIES RESTAURANTS PRINT-RESULTS))

;;;***********
;;;QUESTION RULES
;;;***************

(defmodule QUESTIONS (import MAIN ?ALL) (export ?ALL))

(deftemplate QUESTIONS::question
	(slot attribute (default ?NONE))
	(slot the-question (default ?NONE))
	(multislot valid-answers (default ?NONE))
	(slot already-asked (default FALSE))
)

(defrule QUESTIONS::ask-a-question
   ?f <- (question (already-asked FALSE)
                   (the-question ?the-question)
                   (attribute ?the-attribute)
                   (valid-answers $?valid-answers))
   =>
   (modify ?f (already-asked TRUE))
   (assert (attribute (name ?the-attribute)
                      (value (ask-question ?the-question ?valid-answers)))))
					  
;;;******************
;;;QUESTIONS
;;;******************


(defmodule GET-PREFERENCES (import QUESTIONS ?ALL))

(deffacts GET-PREFERENCES::question-preference
	(question (attribute price)
				(the-question "what is your budget like?")
				(valid-answers low medium high))
	(question (attribute place)
				(the-question "where would you like to eat?")
				(valid-answers outskirts cbd))
	(question (attribute food)
				(the-question "what cuisine would you like to eat?")
				(valid-answers international ethiopian sandwiches indian african))
	(question (attribute ambience)
				(the-question "what sort of dining experience are you looking for?")
				(valid-answers fine-dining casual fast-food))
	(question (attribute delivery)
				(the-question "would you like your food to be delivered?")
				(valid-answers true false))
	(question (attribute alcohol)
				(the-question "would you like to be served alcohol?")
				(valid-answers true false))
	(question (attribute vegetarian)
				(the-question "would you like a vegetarian friendly menu?")
				(valid-answers true false))
)

;;;***********
;;;RULES
;;;***********

(defmodule RULES (import MAIN ?ALL) (export ?ALL))

(deftemplate RULES::rule
  (multislot if)
  (multislot then))

(defrule RULES::throw-away-ands-in-antecedent
  ?f <- (rule (if and $?rest))
  =>
  (modify ?f (if ?rest)))

(defrule RULES::throw-away-ands-in-consequent
  ?f <- (rule (then and $?rest))
  =>
  (modify ?f (then ?rest)))
  
(defrule RULES::remove-is-condition-when-satisfied
  ?f <- (rule  
              (if ?attribute is ?value $?rest))
  (attribute (name ?attribute) 
             (value ?value))
  =>
  (modify ?f (if ?rest)))

(defrule RULES::remove-is-not-condition-when-satisfied
  ?f <- (rule  
              (if ?attribute is-not ?value $?rest))
  (attribute (name ?attribute) (value ~?value))
  =>
  (modify ?f (if ?rest)))
  
;;;**************
;;;CHOOSE-QUALITIES
;;;**************

(defmodule CHOOSE-QUALITIES (import RULES ?ALL)
                            (import QUESTIONS ?ALL)
                            (import MAIN ?ALL))
	
(defrule CHOOSE-QUALITIES::startit => (focus RULES))
	
(deffacts user-choices 
	(rule (if price is low)
		(then budget is low))
	(rule (if price is medium)
		(then budget is medium))
	(rule (if price is high)
		(then budget is high))
	(rule (if place is outskirts)
		(then location is outskirts))
	(rule (if place is cbd)
		(then location is cbd))
	(rule (if food is international)
		(then cuisine is international))
	(rule (if food is indian)
		(then cuisine is indian))
	(rule (if food is african)
		(then cuisine is african))
	(rule (if food is ethiopian)
		(then cuisine is ethiopian))
	(rule (if food is sandwiches)
		(then cuisine is sandwiches))
	(rule (if ambience is casual)
		(then experience is casual))
	(rule (if ambience is fine-dining)
		(then experience is fine-dining))
	(rule (if ambience is fast-food)
		(then experience is fast-food))
	(rule (if alcohol is true)
		(then has-alcohol is TRUE))
	(rule (if alcohol is false)
		(then has-alcohol is FALSE))
	(rule (if delivery is true)
		(then has-delivery is TRUE))
	(rule (if delivery is false)
		(then has-delivery is FALSE))
	(rule (if vegetarian is false)
		(then has-vegetarian is FALSE))
	(rule (if vegetarian is true)
		(then has-vegetarian is TRUE))
	

)
;;;
;;;SELECTION
;;;

(defmodule RESTAURANTS (import MAIN ?ALL))

(deffacts any-attributes
  (attribute (name price) (value any))
  (attribute (name place) (value any))
  (attribute (name food) (value any))
  (attribute (name ambience) (value any))
  (attribute (name delivery) (value any))
  (attribute (name alcohol) (value any))
  (attribute (name vegetarian) (value any)))
  
(deftemplate RESTAURANTS::restaurant
  (slot name (default ?NONE))
  (multislot budget (default any))
  (multislot location (default any))
  (multislot cuisine (default any))
  (multislot experience (default any))
  (multislot has-delivery (default any))
  (multislot has-alcohol (default any))
  (multislot has-vegetarian (default any))
  (multislot rating (default any)))

(deffacts RESTAURANTS::the-restaurants
  
  (restaurant (name "About Thyme") (budget "medium") (location "outskirts") (cuisine "international") (experience "casual") (has-delivery "FALSE") (has-alcohol "TRUE") (has-vegetarian "TRUE") (rating 4))
  (restaurant (name "Abyssinia") (budget "medium") (location "outskirts") (cuisine "ethiopian") (experience "casual") (has-delivery "FALSE") (has-alcohol "FALSE") (has-vegetarian "TRUE") (rating 4))
  (restaurant (name "Absolute Juice") (budget "medium") (location "outskirts") (cuisine "sandwiches") (experience "Casual") (has-delivery "FALSE") (has-alcohol "FALSE") (has-vegetarian "TRUE") (rating 4))
  (restaurant (name "Afma Gardens") (budget "Medium") (location "outskirts") (cuisine "international") (experience "Casual") (has-delivery "TRUE") (has-alcohol "FALSE") (has-vegetarian "TRUE") (rating 5))
  (restaurant (name "AA Mithaiwalla") (budget "Low") (location "outskirts") (cuisine "indian") (experience "Casual") (has-delivery "FALSE") (has-alcohol "FALSE") (has-vegetarian "TRUE") (rating 4))
  (restaurant (name "Abondoz") (budget "Low") (location "cbd") (cuisine "african") (experience "Casual") (has-delivery "FALSE") (has-alcohol "FALSE") (has-vegetarian "TRUE") (rating 5))
  (restaurant (name "Aces Africana Bistro") (budget "medium") (location "outskirts") (cuisine "african") (experience "Casual") (has-delivery "FALSE") (has-alcohol "FALSE") (has-vegetarian "TRUE") (rating 5))
)

(defrule RESTAURANTS::pick-restaurant
  (restaurant (name ?name)
        (budget $? ?b $?)
        (location $? ?l $?)
        (cuisine $? ?c $?)
		(experience $? ?e $?)
		(has-delivery $? ?d $?)
		(has-alcohol $? ?a $?)
		(has-vegetarian $? ?v $?)
		(rating ?rating))
  (attribute (name price) (value ?b))
  (attribute (name place) (value ?l))
  (attribute (name food) (value ?c))
  (attribute (name ambience) (value ?e))
  (attribute (name has-delivery) (value ?d))
  (attribute (name has-alcohol) (value ?a))
  (attribute (name has-vegetarian) (value ?v))
  =>
  (assert (attribute (name restaurant) (value ?name)
                     )))

;;*****************************
;;* PRINT SELECTED RESTAURANTS *
;;*****************************

(defmodule PRINT-RESULTS (import MAIN ?ALL))

(defrule PRINT-RESULTS::header ""
   (declare (salience 10))
   =>
   (println)
   (println "        SELECTED RESTAURANTS" crlf)
   (println " -------------------------------")
   (assert (phase print-restaurants)))

(defrule PRINT-RESULTS::print-restaurant ""
  ?rem <- (attribute (name restaurant) (value ?name) )		  
  (not (attribute (name restaurant) ))
  =>
  (retract ?rem)
  ;(format t " %-24s %2d%%%n" ?name))
  
(defrule PRINT-RESULTS::end-spaces ""
   (not (attribute (name restaurant)))
   =>
   (println))
