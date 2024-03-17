USE ksiegarnia;
SELECT * FROM magazyn;
SELECT
	ksiazki.tytul,
    COUNT(*) AS 'Liczba sprzedanych książek',
    CASE
		WHEN magazyn.hurtownia = 0 THEN 'Niedostępna w hurtowni'
        ELSE 'Dostępna w hurtowni'
	END AS Dostępność
FROM koszyk
LEFT JOIN ksiazki ON ksiazki_id = koszyk.ksiazki_id
LEFT JOIN magazyn ON ksiazki.id = magazyn.ksiazki_id
GROUP BY koszyk.ksiazki_id
ORDER BY 2 DESC;
## być może trzeba to odpalić  --SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));-- ##

## ---------------------------- ##
SELECT
	ksiazki.tytul,
    magazyn.stan_magazynowy
FROM ksiazki
LEFT JOIN koszyk ON ksiazki.id = koszyk.ksiazki_id
JOIN magazyn ON ksiazki.id = magazyn.ksiazki_id
WHERE hurtownia = 0
ORDER BY 2 DESC
LIMIT 5;
## ------------------------------------------- ##

SELECT
	DISTINCT
    ksiazki.tytul,
    magazyn.stan_magazynowy
FROM koszyk
	JOIN ksiazki ON koszyk.ksiazki_id = ksiazki.id
    LEFT JOIN magazyn ON ksiazki.id = magazyn.ksiazki_id
LIMIT 0, 500;

SELECT
	ksiazki.tytul,
    zamowienia.id,
    magazyn.stan_magazynowy
FROM ksiazki
JOIN koszyk ON ksiazki.id = koszyk.ksiazki_id
JOIN zamowienia ON zamowienia.id = koszyk.zamowienia_id
JOIN magazyn ON ksiazki.id = magazyn.ksiazki_id
ORDER BY 3 DESC;

## ----------------------------- ##

SELECT
	DISTINCT
    uzytkownicy.email AS 'mail użytkownika',
    zamowienia.id AS 'ID zamówienia',
    CASE
		WHEN ksiazki.tytul LIKE '%Harry Potter%' THEN 'Wróc do Hogwartu! Kontynuuj przygody razem z Harrym i przyjaciółmi i wykorzystaj swój kupon rabatowy na książki o Harrym już dziś!'
        WHEN ksiazki.tytul NOT LIKE '%Harry Potter%' THEN 'Dołącz do uczniów Hogwartu i odkryj fascynujący świat czarów i magii. Poznaj Harry\'ego i jego przyjaciół, kupuj książki z serii taniej z kodem rabatowym!'
        WHEN zamowienia.id IS NULL THEN 'Witaj mugolu! Nie miałeś jeszcze okazji poznać naszego magicznego świata? Poznaj magię już dziś z kodem rabatowym na Twoje pierwsze zamówienie. Dodaj do koszyka książki z serii o Harrym Potterze i korzystaj z magicznych rabatów!'
	END AS 'wiadomość',
    CASE
		WHEN ksiazki.tytul LIKE '%Harry Potter%' THEN 'BACKTOHARRY | [10%]'
        WHEN ksiazki.tytul NOT LIKE '%Harry Potter%' THEN 'DISCOVERHARRY | [15%]'
        WHEN zamowienia.id IS NULL THEN 'FIRSTTIME | [25%]'
	END AS 'Kupon rabatowy | Przysługująca zniżka'
FROM uzytkownicy
	LEFT JOIN zamowienia ON uzytkownicy.id = zamowienia.uzytkownicy_id
    LEFT JOIN koszyk ON zamowienia.id = koszyk.zamowienia_id
    LEFT JOIN ksiazki ON ksiazki.id = koszyk.ksiazki_id
ORDER BY 4 ASC;

## -------------------------- ##
## kolejne JOINY ##
SELECT
	uzytkownicy.imie,
    uzytkownicy.nazwisko,
    ksiazki.tytul
FROM uzytkownicy
	JOIN zamowienia ON uzytkownicy.id = zamowienia.uzytkownicy_id
    JOIN koszyk ON zamowienia.id = koszyk.zamowienia_id
    JOIN ksiazki ON koszyk.ksiazki_id = ksiazki.id;
##------------------------------ ##

SELECT * FROM zamowienia
RIGHT JOIN uzytkownicy ON uzytkownicy_id = uzytkownicy.id
WHERE uzytkownicy.adres_miasto LIKE 'Warszawa';

## ----------------------------- ##

SELECT
	zamowienia.id,
    uzytkownicy.adres_ulica,
    uzytkownicy.adres_miasto,
    uzytkownicy.adres_kod
FROM zamowienia
LEFT JOIN uzytkownicy
ON zamowienia.uzytkownicy_id = uzytkownicy.id;

## --------------------------- ##

SELECT * FROM zamowienia, koszyk WHERE zamowienia_id = zamowienia.id AND uzytkownicy_id = 1;

## --------------------------- ##

SELECT
	tytul,
    autor,
    CASE
		WHEN rating > 4.5 THEN '*****'
        WHEN rating > 4.0 AND rating <= 4.5 THEN "****'"
        WHEN rating > 3.5 AND rating <= 4.0 THEN "****"
        WHEN rating > 3.0 AND rating <= 3.5 THEN "***'"
        WHEN rating > 2.5 AND rating <= 3.0 THEN "***"
        WHEN rating > 2.0 AND rating <= 2.5 THEN "**'"
        ELSE "*"
	END AS 'ocena',
    rok_wydania,
    IF(rok_wydania <= 1492, '#średniowiecze',
		IF(rok_wydania <= 1520, '#renesans',
			IF(rok_wydania <= 1680, '#barok',
				IF(rok_wydania <= 1789, '#oświeczenie',
					IF(rok_wydania <= 1850, '#romantyzm',
						IF(rok_wydania <= 1880, '#pozytywizm',
							IF(rok_wydania <= 1918, '#modernizm',
								IF(rok_wydania <= 1939, '#literatura_międzywojenna', '#literatura_współczesna')
							)
						)
					)
				)
			)
		)
	) AS 'epoka',
    IF(star_1 > star_5 OR star_2 > star_5 OR star_3 > star_5 OR star_4 > star_5, 'przeważnie mniej niż 5 gwiazdek', 'przeważnie 5 gwiazdek') AS 'ile gwiazdek'
FROM ksiazki
ORDER BY tytul;

## --------------------------- ##

SELECT
	tytul,
    rating,
    CASE
		WHEN rating > 4.2 THEN 'bardzo dobra książka'
        WHEN rating BETWEEN 3.8 AND 4.2 THEN 'dobra książka'
        ELSE 'przeciętna książka'
	END AS rodzaj,
    autor
FROM ksiazki;

## -------------------- ##

SELECT
	autor,
    ROUND(AVG(rating), 2)
FROM ksiazki
WHERE
	SUBSTRING_INDEX(autor, ' ', 1) IN ('John', 'Dan', 'George', 'William') AND
    rok_wydania % 2 = 1
GROUP BY autor;

## --------------------- ##

SELECT
	SUBSTRING_INDEX(autor, ' ', 1) AS first_name,
    SUBSTRING_INDEX(autor, ' ', -1) AS last_name,
    tytul,
    rok_wydania
FROM ksiazki
WHERE
	SUBSTRING_INDEX(autor, ' ', -1) IN ('Tolkien', 'Rowling', 'King', 'Orwell');
    
## --------------------- ##

SELECT
	SUBSTRING_INDEX(autor, ' ', 1) AS first_name,
    SUBSTRING_INDEX(autor, ' ', -1) AS last_name,
    tytul,
    rok_wydania
FROM ksiazki
WHERE
	SUBSTRING_INDEX(autor, ' ', -1) = 'Tolkien' OR
    SUBSTRING_INDEX(autor, ' ', -1) = 'Rowling' OR
    SUBSTRING_INDEX(autor, ' ', -1) = 'King' OR
    SUBSTRING_INDEX(autor, ' ', -1) = 'Orwell';
    
## ----------------------- ##

UPDATE
	ksiazki
SET ratings_no = star_1 + star_2 + star_3 + star_4 + star_5
WHERE ratings_no != star_1 + star_2 + star_3 + star_4 + star_5;

## ----------------------- ##

SELECT
	autor,
    rok_wydania,
    SUM(reviews_no) AS 'suma komentarzy'
FROM ksiazki
WHERE ratings_no >= 600000
GROUP BY autor, rok_wydania
ORDER BY autor DESC;

## ------------------------ ##

SELECT
	autor,
    AVG(rating)
FROM ksiazki
WHERE CHAR_LENGTH(SUBSTRING_INDEX(autor, ' ', -1)) NOT BETWEEN 6 AND 10
GROUP BY autor;

## --------------------- ##

SELECT
	tytul,
    ROUND((star_5 / ratings_no) * 100, 2) AS '5 star percentage'
FROM ksiazki
WHERE rating >= 4.00;

## -------------------- ##

SELECT
	autor,
    SUM(star_1) AS 'liczba głosów 1-gwiazdkowych'
FROM ksiazki
WHERE ratings_no >= 1000000 OR
	reviews_no >= 50000
GROUP BY autor
ORDER BY autor;

## ------------------ ##

SELECT 
	tytul 
FROM ksiazki 
WHERE rok_wydania BETWEEN 2005 AND 2010;

## ----------------- ##

SELECT AVG(rating) FROM ksiazki WHERE rok_wydania BETWEEN 1990 AND 2005 ORDER BY rok_wydania ASC;

## ---------------- ##

SELECT DATE_FORMAT('2010-05-01 14:32:11', '%M-%D-%Y, %H:%i');
SELECT DATEDIFF(NOW(), '2010-05-01');
SELECT DATE_ADD(NOW(), INTERVAL 100 DAY);
SELECT DATE_ADD(NOW(), INTERVAL 23 YEAR);
SELECT TIMESTAMP('2010-05-01');
SELECT DATE_FORMAT('2010-05-01 14:32:11', '%d/%m/%y');
SELECT DAYOFYEAR(NOW());
SELECT MONTH(NOW());
SELECT MONTHNAME(NOW());
SELECT HOUR(NOW());
SELECT MINUTE(NOW());
SELECT SECOND(NOW());
SELECT CURDATE();
SELECT CURTIME();

## ----------------------------------------------- ##

SELECT
	autor,
    ROUND(AVG(star_1), 0) AS 'średnia liczba oceny 1 gwiazdka',
    ROUND(AVG(star_5), 0) AS 'średnia liczba oceny 5 gwiazdek'
FROM ksiazki
GROUP BY autor
ORDER BY SUBSTRING_INDEX(autor, ' ',-1) ASC;

## ------------------------- ##

SELECT autor, tytul, rating FROM ksiazki WHERE rating = (SELECT MIN(rating) FROM ksiazki);

## ------------------------- ##

SELECT
	rok_wydania,
    ROUND(AVG(rating), 2),
    COUNT(*)
FROM ksiazki
WHERE rok_wydania % 2 = 0
GROUP BY rok_wydania
ORDER BY rok_wydania DESC;

## -------------------------- ##