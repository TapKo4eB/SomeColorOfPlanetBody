/datum/holiday
	var/name = "If you see this the holiday calendar code is broken"

	var/begin_day = 1
	var/begin_month = 0
	var/end_day = 0 // Default of 0 means the holiday lasts a single day
	var/end_month = 0
	var/always_celebrate = FALSE // for christmas neverending, or testing.
	var/current_year = 0
	var/year_offset = 0
	var/obj/item/drone_hat //If this is defined, drones without a default hat will spawn with this one during the holiday; check drones_as_items.dm to see this used

// This proc gets run before the game starts when the holiday is activated. Do festive shit here.
/datum/holiday/proc/celebrate()
	return

// When the round starts, this proc is ran to get a text message to display to everyone to wish them a happy holiday
/datum/holiday/proc/greet()
	return "Да это же [name]!"

// Returns special prefixes for the station name on certain days. You wind up with names like "Christmas Object Epsilon". See new_station_name()
/datum/holiday/proc/getStationPrefix()
	//get the first word of the Holiday and use that
	var/i = findtext(name, "  Сектор |")
	return copytext(name, 1, i)

// Return 1 if this holidy should be celebrated today
/datum/holiday/proc/shouldCelebrate(dd, mm, yyyy, ddd)
	if(always_celebrate)
		return TRUE

	if(!end_day)
		end_day = begin_day
	if(!end_month)
		end_month = begin_month
	if(end_month > begin_month) //holiday spans multiple months in one year
		if(mm == end_month) //in final month
			if(dd <= end_day)
				return TRUE

		else if(mm == begin_month)//in first month
			if(dd >= begin_day)
				return TRUE

		else if(mm in begin_month to end_month) //holiday spans 3+ months and we're in the middle, day doesn't matter at all
			return TRUE

	else if(end_month == begin_month) // starts and stops in same month, simplest case
		if(mm == begin_month && (dd in begin_day to end_day))
			return TRUE

	else // starts in one year, ends in the next
		if(mm >= begin_month && dd >= begin_day) // Holiday ends next year
			return TRUE
		if(mm <= end_month && dd <= end_day) // Holiday started last year
			return TRUE

	return FALSE

// The actual holidays

/datum/holiday/new_year
	name = NEW_YEAR
	begin_day = 29
	begin_month = DECEMBER
	end_day = 3
	end_month = JANUARY
	drone_hat = /obj/item/clothing/head/festive

/datum/holiday/new_year/getStationPrefix()
	return pick("Праздничный Сектор |","Новый Сектор |","Похмельный Сектор |","Новогодний Сектор |")

/datum/holiday/groundhog
	name = "День Сурка"
	begin_day = 2
	begin_month = FEBRUARY
	drone_hat = /obj/item/clothing/head/helmet/space/chronos

/datum/holiday/groundhog/getStationPrefix()
	return pick("Deja Vu Сектор |") //I have been to this place before

/datum/holiday/valentines
	name = VALENTINES
	begin_day = 13
	end_day = 15
	begin_month = FEBRUARY

/datum/holiday/valentines/getStationPrefix()
	return pick("Любовный Сектор |","Аморный Сектор |","Одинокий Сектор |","Легкосердечный Сектор |","Обнимашковый Сектор |")

/// Garbage DAYYYYY
/// Huh?.... NOOOO
/// *GUNSHOT*
/// AHHHGHHHHHHH
/datum/holiday/garbageday
	name = GARBAGEDAY
	begin_day = 17
	end_day = 17
	begin_month = JUNE

/datum/holiday/birthday
	name = "День рождения Space Station 13"
	begin_day = 16
	begin_month = FEBRUARY
	drone_hat = /obj/item/clothing/head/festive

/datum/holiday/birthday/greet()
	var/game_age = text2num(time2text(world.timeofday, "YYYY Сектор |")) - 2003
	var/Fact
	switch(game_age)
		if(16)
			Fact = " SS13 сейчас достаточно взрослый, чтобы водить!"
		if(18)
			Fact = " SS13 сейчас легален!"
		if(21)
			Fact = " SS13 теперь может пить!"
		if(26)
			Fact = " SS13 теперь может арендовать машину!"
		if(30)
			Fact = " SS13 теперь может возвращаться домой к семье!"
		if(35)
			Fact = " SS13 теперь может быть президентом США!"
		if(40)
			Fact = " SS13 теперь может страдать от кризиса среднего возраста!"
		if(50)
			Fact = " Счастливая золотая годовщина!"
		if(65)
			Fact = " SS13 теперь можно начать думать о выходе на пенсию!"
	if(!Fact)
		Fact = " SS13 теперь на [game_age] лет старее!"

	return "Скажи 'С Днём Рождения' Space Station 13, первой версии от 16 Февраля, 2003 года![Fact]"

/datum/holiday/random_kindness
	name = "Случайные Акты Дня Доброты"
	begin_day = 17
	begin_month = FEBRUARY

/datum/holiday/random_kindness/greet()
	return "Пойди сделай несколько случайных актов доброты для незнакомца!" //haha yeah right

/datum/holiday/leap
	name = "Високосный день"
	begin_day = 29
	begin_month = FEBRUARY

/datum/holiday/pi
	name = "День Пи"
	begin_day = 14
	begin_month = MARCH

/datum/holiday/pi/getStationPrefix()
	return pick("Синусоидный Сектор |","Косинусоидный Сектор |","Тангенсный Сектор |","Пересекающий Сектор |", "Не пересекающий Сектор |", "Котангенсный Сектор |")

/datum/holiday/no_this_is_patrick
	name = "День Святого Патрика"
	begin_day = 17
	begin_month = MARCH
	drone_hat = /obj/item/clothing/head/soft/green

/datum/holiday/no_this_is_patrick/getStationPrefix()
	return pick("Лестный Сектор |","Зелёный Сектор |","Лепреконовский Сектор |","Пьяный Сектор |")

/datum/holiday/no_this_is_patrick/greet()
	return "Счастливый Национальный день Опьянения!"

/datum/holiday/april_fools
	name = APRIL_FOOLS
	begin_day = 1
	begin_month = APRIL

/datum/holiday/april_fools/celebrate()
	SSjob.set_overflow_role("Clown Сектор |")
	SSticker.login_music = 'sound/ambience/clown.ogg'
	for(var/mob/dead/new_player/P in GLOB.mob_list)
		if(P.client)
			P.client.playtitlemusic()

/datum/holiday/spess
	name = "День Космонавта"
	begin_day = 12
	begin_month = APRIL
	drone_hat = /obj/item/clothing/head/syndicatefake

/datum/holiday/spess/greet()
	return "В этот день более 600 лет назад товарищ Юрий Гагарин впервые отправился в космос!"

/datum/holiday/fourtwenty
	name = "День Четыре Двадцать"
	begin_day = 20
	begin_month = APRIL

/datum/holiday/fourtwenty/getStationPrefix()
	return pick("Шпионский Сектор |","Туповатый Сектор |","Затяжной Сектор |","Промозглый Сектор |","Чичевый Сектор |","Чонговый Сектор |")

/datum/holiday/tea
	name = "Национальный День Чая"
	begin_day = 21
	begin_month = APRIL

/datum/holiday/tea/getStationPrefix()
	return pick("Пышечный Сектор |","Ассамский Сектор |","Улунгский Сектор |","Пу-эрский Сектор |","Сладкочаевый Сектор |","Зелёный Сектор |","Чёрный Сектор |")

/datum/holiday/earth
	name = "День Земли"
	begin_day = 22
	begin_month = APRIL

/datum/holiday/labor
	name = "День Труда"
	begin_day = 1
	begin_month = MAY
	drone_hat = /obj/item/clothing/head/hardhat

/datum/holiday/firefighter
	name = "День Пожарника"
	begin_day = 4
	begin_month = MAY
	drone_hat = /obj/item/clothing/head/hardhat/red

/datum/holiday/firefighter/getStationPrefix()
	return pick("Горящий Сектор |","Пылающий Сектор |","Плазменный Сектор |","Огненный Сектор |")

/datum/holiday/pobeda
	name = "День Победы"
	begin_day = 9
	begin_month = MAY

/datum/holiday/pobeda/getStationPrefix()
	return pick("Ветеранский Сектор |","Победный Сектор |","Ряженый Сектор |","Окопный Сектор |","Дедовский Сектор |")

/datum/holiday/bee
	name = "День пчёл"
	begin_day = 20
	begin_month = MAY
	drone_hat = /obj/item/clothing/mask/rat/bee

/datum/holiday/bee/getStationPrefix()
	return pick("Пчёлочный Сектор |","Медовый Сектор |","Роевой Сектор |","Бжжжжжж Сектор |","Медовуховый Сектор |","Жужжащий Сектор |")

/datum/holiday/summersolstice
	name = "День Летнего Солнцестояния"
	begin_day = 21
	begin_month = JUNE

/datum/holiday/doctor
	name = "День Доктора"
	begin_day = 1
	begin_month = JULY
	drone_hat = /obj/item/clothing/head/nursehat

/datum/holiday/ufo
	name = "День НЛО"
	begin_day = 2
	begin_month = JULY
	drone_hat = /obj/item/clothing/mask/facehugger/dead

/datum/holiday/ufo/getStationPrefix() //Is such a thing even possible?
	return pick("Ayy Сектор |","Правдивый Сектор |","Цукалосный Сектор |","Малдеровый Сектор |","Скаллевый Сектор |") //Yes it is!

/datum/holiday/usa
	name = "День Независимости США"
	begin_day = 4
	begin_month = JULY

/datum/holiday/usa/getStationPrefix()
	return pick("Независимый Сектор |","Американский Сектор |","Бургеровый Сектор |","Белоголово-орланский Сектор |","Настроенный Шовинистически Сектор |", "Фейерверковый Сектор |")

/datum/holiday/nz
	name = "Waitangi Day"
	begin_day = 6
	begin_month = FEBRUARY

/datum/holiday/nz/getStationPrefix()
	return pick("Aotearoa Сектор |","Kiwi Сектор |","Fish 'n' Chips Сектор |","Kākāpō Сектор |","Southern Cross Сектор |")

/datum/holiday/nz/greet()
	var/nz_age = text2num(time2text(world.timeofday, "YYYY Сектор |")) - 1840 //is this work
	return "On this day [nz_age] years ago, New Zealand's Treaty of Waitangi, the founding document of the nation, was signed!" //thus creating much controversy

/datum/holiday/anz
	name = "ANZAC Day"
	begin_day = 25
	begin_month = APRIL
	drone_hat = /obj/item/reagent_containers/food/snacks/grown/poppy

/datum/holiday/anz/getStationPrefix()
	return pick("Australian Сектор |","New Zealand Сектор |","Poppy Сектор |", "Southern Cross Сектор |")

/datum/holiday/writer
	name = "День Писателя"
	begin_day = 8
	begin_month = JULY

/datum/holiday/france
	name = "День взятия Бастилии"
	begin_day = 14
	begin_month = JULY
	drone_hat = /obj/item/clothing/head/beret

/datum/holiday/france/getStationPrefix()
	return pick("Французский Сектор |","Fromage Сектор |", "Zut Сектор |", "Merde Сектор |")

/datum/holiday/france/greet()
	return "Ты слышишь, как люди поют?"

/datum/holiday/friendship
	name = "День дружбы"
	begin_day = 30
	begin_month = JULY

/datum/holiday/friendship/greet()
	return "Есть волшебный [name]!"

/datum/holiday/pirate
	name = "День Говорения-как-пират"
	begin_day = 19
	begin_month = SEPTEMBER
	drone_hat = /obj/item/clothing/head/pirate

/datum/holiday/pirate/greet()
	return "Ye be talkin' like a pirate today or else ye'r walkin' tha plank, matey!"

/datum/holiday/pirate/getStationPrefix()
	return pick("Yarr Сектор |","Scurvy Сектор |","Yo-ho-ho Сектор |")

/datum/holiday/programmers
	name = "День Программиста"

/datum/holiday/programmers/shouldCelebrate(dd, mm, yyyy, ddd) //Programmer's day falls on the 2^8th day of the year
	if(mm == 9)
		if(yyyy/4 == round(yyyy/4)) //Note: Won't work right on September 12th, 2200 (at least it's a Friday!)
			if(dd == 12)
				return TRUE
		else
			if(dd == 13)
				return TRUE
	return FALSE

/datum/holiday/programmers/getStationPrefix()
	return pick("</span> |","DEBUG |","NULL |","/list |","EVENT PREFIX NOT FOUND |") //Portability

/datum/holiday/questions
	name = "День Глупых Вопросов"
	begin_day = 28
	begin_month = SEPTEMBER

/datum/holiday/questions/greet()
	return "Имеете [name]?"

/datum/holiday/animal
	name = "День Животных"
	begin_day = 4
	begin_month = OCTOBER

/datum/holiday/animal/getStationPrefix()
	return pick("Parrot Сектор |","Corgi Сектор |","Cat Сектор |","Pug Сектор |","Goat Сектор |","Fox Сектор |")

/datum/holiday/smile
	name = "День Улыбок"
	begin_day = 7
	begin_month = OCTOBER
	drone_hat = /obj/item/clothing/head/papersack/smiley

/datum/holiday/boss
	name = "День Босса"
	begin_day = 16
	begin_month = OCTOBER
	drone_hat = /obj/item/clothing/head/that

/datum/holiday/halloween
	name = HALLOWEEN
	begin_day = 28
	begin_month = OCTOBER
	end_day = 2
	end_month = NOVEMBER

/datum/holiday/halloween/greet()
	return "Жуткий Хэллоуин!"

/datum/holiday/halloween/getStationPrefix()
	return pick("Bone-Rattling Сектор |","Mr. Bones' Own Сектор |","2SPOOKY Сектор |","Spooky Сектор |","Scary Сектор |","Skeletons Сектор |")

/datum/holiday/vegan
	name = "День Вегана"
	begin_day = 1
	begin_month = NOVEMBER

/datum/holiday/vegan/getStationPrefix()
	return pick("Tofu Сектор |", "Tempeh Сектор |", "Seitan Сектор |", "Tofurkey Сектор |")

/datum/holiday/october_revolution
	name = "День, когда ебанные коммунисты взяли эту страну."
	begin_day = 6
	begin_month = NOVEMBER
	end_day = 7

/datum/holiday/october_revolution/getStationPrefix()
	return pick("Коммунистический Сектор |", "Советский Сектор |", "Большевиковский Сектор |", "Социалистический Сектор |", "Красный Сектор |", "Рабочий Сектор |")

/datum/holiday/kindness
	name = "День доброты"
	begin_day = 13
	begin_month = NOVEMBER

/datum/holiday/flowers
	name = "День цветов"
	begin_day = 19
	begin_month = NOVEMBER
	drone_hat = /obj/item/clothing/head/peaceflower

/datum/holiday/hello
	name = "'Привет' День"
	begin_day = 21
	begin_month = NOVEMBER

/datum/holiday/hello/greet()
	return pick("Aloha Сектор |", "Bonjour Сектор |", "Hello Сектор |", "Hi Сектор |", "Greetings Сектор |", "Salutations Сектор |", "Bienvenidos Сектор |", "Hola Сектор |", "Howdy Сектор |", "Ni hao Сектор |", "Guten Tag Сектор |", "Konnichiwa Сектор |", "G'day cunt Сектор |")

/datum/holiday/human_rights
	name = "День прав человека"
	begin_day = 10
	begin_month = DECEMBER

/datum/holiday/monkey
	name = MONKEYDAY
	begin_day = 14
	begin_month = DECEMBER
	drone_hat = /obj/item/clothing/mask/gas/monkeymask

/datum/holiday/islamic
	name = "Islamic calendar code broken"

/datum/holiday/islamic/ramadan
	name = "Начало Рамадана"
	begin_month = 9
	begin_day = 1
	end_day = 3

/datum/holiday/islamic/ramadan/getStationPrefix()
	return pick("Вредный Сектор |","Халяльный Сектор |","Джихадный Сектор |","Мусульманский Сектор |")

/datum/holiday/islamic/ramadan/end
	name = "Конец Рамадана"
	end_month = 10
	begin_day = 28
	end_day = 1

/datum/holiday/lifeday
	name = "День Жизни"
	begin_day = 17
	begin_month = NOVEMBER

/datum/holiday/lifeday/getStationPrefix()
	return pick("Зудящий Сектор |", "Комковатый Сектор |", "Маллайий Сектор |", "Казучий Сектор |") //he really pronounced it "Kazook Сектор |", I wish I was making shit up

/datum/holiday/doomsday
	name = "Годовщина Судного Дня Майя"
	begin_day = 21
	begin_month = DECEMBER
	drone_hat = /obj/item/clothing/mask/rat/tribal

/datum/holiday/xmas
	name = CHRISTMAS
	begin_day = 22
	begin_month = DECEMBER
	end_day = 3
	end_month = JANUARY
	drone_hat = /obj/item/clothing/head/santa

/datum/holiday/xmas/greet()
	return "Счастливого Рождества!"

/datum/holiday/xmas/celebrate()
	SSticker.OnRoundstart(CALLBACK(src, .proc/roundstart_celebrate))

/datum/holiday/xmas/proc/roundstart_celebrate()
	for(var/obj/machinery/computer/security/telescreen/entertainment/Monitor in GLOB.machines)
		Monitor.icon_state_on = "entertainment_xmas"

	for(var/mob/living/simple_animal/pet/dog/corgi/Ian/Ian in GLOB.mob_living_list)
		Ian.place_on_head(new /obj/item/clothing/head/helmet/space/santahat(Ian))

/datum/holiday/festive_season
	name = FESTIVE_SEASON
	begin_day = 1
	begin_month = DECEMBER
	end_day = 31
	drone_hat = /obj/item/clothing/head/santa

/datum/holiday/festive_season/greet()
	return "Приятных новогодних праздников!"

/datum/holiday/boxing
	name = "День подарков"
	begin_day = 26
	begin_month = DECEMBER

/datum/holiday/friday_thirteenth
	name = "Пятница 13-е"

/datum/holiday/friday_thirteenth/shouldCelebrate(dd, mm, yyyy, ddd)
	if(dd == 13 && ddd == FRIDAY)
		return TRUE
	return FALSE

/datum/holiday/friday_thirteenth/getStationPrefix()
	return pick("Mike Сектор |","Friday Сектор |","Evil Сектор |","Myers Сектор |","Murder Сектор |","Deathly Сектор |","Stabby Сектор |")

/datum/holiday/easter
	name = EASTER
	drone_hat = /obj/item/clothing/head/rabbitears
	var/const/days_early = 1 //to make editing the holiday easier
	var/const/days_extra = 1

/datum/holiday/easter/shouldCelebrate(dd, mm, yyyy, ddd)
	if(!begin_month)
		current_year = text2num(time2text(world.timeofday, "YYYY Сектор |"))
		var/list/easterResults = EasterDate(current_year+year_offset)

		begin_day = easterResults["day"]
		begin_month = easterResults["month"]

		end_day = begin_day + days_extra
		end_month = begin_month
		if(end_day >= 32 && end_month == MARCH) //begins in march, ends in april
			end_day -= 31
			end_month++
		if(end_day >= 31 && end_month == APRIL) //begins in april, ends in june
			end_day -= 30
			end_month++

		begin_day -= days_early
		if(begin_day <= 0)
			if(begin_month == APRIL)
				begin_day += 31
				begin_month-- //begins in march, ends in april

	return ..()

/datum/holiday/easter/celebrate()
	GLOB.maintenance_loot += list(
		/obj/item/reagent_containers/food/snacks/egg/loaded = 15,
		/obj/item/storage/bag/easterbasket = 15)

/datum/holiday/easter/greet()
	return "Привет! Счастливой Пасхи и следите за пасхальными кроликами!"

/datum/holiday/easter/getStationPrefix()
	return pick("Fluffy Сектор |","Bunny Сектор |","Easter Сектор |","Egg Сектор |")

/datum/holiday/ianbirthday
	name = "День Рождения Яна" //github.com/tgstation/tgstation/commit/de7e4f0de0d568cd6e1f0d7bcc3fd34700598acb
	begin_month = SEPTEMBER
	begin_day = 9
	end_day = 10

/datum/holiday/ianbirthday/greet()
	return "С днём рождения, Ян!"

/datum/holiday/ianbirthday/getStationPrefix()
	return pick("Ian Сектор |", "Corgi Сектор |", "Erro Сектор |")

/datum/holiday/hotdogday //I have plans for this.
	name = "Национальный день Хот-Дога!"
	begin_day = 17
	begin_month = JULY

/datum/holiday/hotdogday/greet()
	return "Национальный день Хот-Дога!"

/datum/holiday/indigenous //Indigenous Peoples' Day from Earth!
	name = "Международный День Коренных Народов Мира"
	begin_month = AUGUST
	begin_day = 9

/datum/holiday/indigenous/getStationPrefix()
	return pick("Endangered language Сектор |", "Word Сектор |", "Language Сектор |", "Language revitalization Сектор |", "Potato Сектор |", "Corn Сектор |")
