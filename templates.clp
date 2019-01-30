;;Templates to represent...

;;each restaurant
(deftemplate restaurant
	(slot ID (type NUMBER))
	(slot name (type STRING))
	(slot budget (type STRING))
	(slot location (type STRING))
	(slot cuisine (type STRING))
	(slot experience (type STRING))
	(slot rating(type NUMBER))
	(slot has-delivery (type STRING))
	(slot has-alcohol (type STRING))
	(slot has-vegetarian (type STRING))
)

;;each user's search preferences
(deftemplate preferences
	(slot budget (type STRING))
	(slot location (type STRING))
	(slot cuisine (type STRING))
	(slot experience (type STRING))
	(slot rating(type NUMBER))
	(slot has-delivery (type STRING))
	(slot has-alcohol (type STRING))
	(slot has-vegetarian (type STRING))

)
