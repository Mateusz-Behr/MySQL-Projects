USE klasa;
SHOW TABLES;

SELECT * FROM uczniowie;
SELECT * FROM adres;
SELECT * FROM rodzina;
SELECT * FROM klasyfikacja;
SELECT * FROM frekwencja;
SELECT * FROM zaleglosci;

## -- Średnia ocen uczniów -- ##
# -------------------------------------------------------------------------------------------------- #

SELECT 
    uczniowie_t.imiona,
    uczniowie_t.nazwisko,
    uczniowie_t.srednia_ocen,
    uczniowie_t.zachowanie,
    IF((uczniowie_t.zachowanie = 'wzorowe' OR uczniowie_t.zachowanie = 'bardzo dobre') AND uczniowie_t.srednia_ocen >= 4.75, "Świadectwo z wyróżnieniem", "Świadectwo bez wyróżnienia")
    AS "Świadectwo"
 FROM
(
    SELECT 
        imiona,
        nazwisko,
        ROUND((COALESCE(religia, 0)
                + COALESCE(polski, 0)
                + COALESCE(angielski, 0)
                + COALESCE(niemiecki, 0)
                + COALESCE(historia, 0)
                + COALESCE(matematyka, 0)
                + COALESCE(fizyka, 0)
                + COALESCE(chemia, 0)
                + COALESCE(biologia, 0)
                + COALESCE(geografia, 0)
                + COALESCE(wf, 0)
                + COALESCE(informatyka, 0)
                + COALESCE(przedsiębiorczość, 0)
            ) / (13 - (COALESCE(religia - religia, 1)
                + COALESCE(polski - polski, 1)
                + COALESCE(angielski - angielski, 1)
                + COALESCE(niemiecki - niemiecki, 1)
                + COALESCE(historia - historia, 1)
                + COALESCE(matematyka - matematyka, 1)
                + COALESCE(fizyka - fizyka, 1)
                + COALESCE(chemia - chemia, 1)
                + COALESCE(biologia - biologia, 1)
                + COALESCE(geografia - geografia, 1)
                + COALESCE(wf - wf, 1)
                + COALESCE(informatyka - informatyka, 1)
                + COALESCE(przedsiębiorczość - przedsiębiorczość, 1))
            ), 2) AS srednia_ocen,
        zachowanie
    FROM uczniowie
    JOIN klasyfikacja ON uczniowie.id = klasyfikacja.id_ucznia
    ) AS uczniowie_t
ORDER BY uczniowie_t.srednia_ocen DESC;

# -------------------------------------------------------------------------------------------------- #
## zachowanie ##
    
SELECT
	imiona,
	nazwisko,
	zachowanie
FROM
	uczniowie
JOIN klasyfikacja ON uczniowie.id = klasyfikacja.id_ucznia
ORDER BY 3 DESC;

## zaleglosci ##

SELECT
	imiona,
	nazwisko,
	CASE
		WHEN 1 NOT IN(biblioteka, pielegniarka, sport, szafka) THEN 'Świadectwo do odbioru'
		ELSE 'Nie może odebrać świadectwa'
	END AS 'Świadectwo'
FROM
	uczniowie
JOIN zaleglosci ON uczniowie.id = zaleglosci.id_ucznia
ORDER BY 3;

## cząstkowe zachowanie z frekwencji ##

SELECT
	imiona,
	nazwisko,
    procent_frekwencji,
	IF(procent_frekwencji >= 90, 'wzorowe',
		IF(procent_frekwencji >= 80, 'bardzo dobre',
			IF(procent_frekwencji >= 70, 'dobre',
				IF(procent_frekwencji >= 60, 'poprawne',
					IF(procent_frekwencji >= 50 , 'nieodpowiednie', 'nieklasyfikowany')
				)
			)
		)
	) AS 'Cząstkowa ocena zachowania'
FROM uczniowie
JOIN frekwencja ON uczniowie.id = frekwencja.id_ucznia
ORDER BY 3 DESC;

## ----------------- ##
