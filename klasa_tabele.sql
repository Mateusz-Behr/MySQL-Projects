CREATE DATABASE klasa;
USE klasa;
	
CREATE TABLE uczniowie
(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    imiona VARCHAR(50) NOT NULL,
    nazwisko VARCHAR(50) NOT NULL,
    data_ur DATE NOT NULL,
    miejsce_ur VARCHAR(255) NOT NULL,
    pesel CHAR(11),
    email VARCHAR(255) NOT NULL,
    telefon INT(9),
    plec VARCHAR(9) NOT NULL
);

LOAD DATA INFILE
"C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Projekt klasy MySQL\\klasa_csv\\Uczniowie_2.0.csv"
INTO TABLE uczniowie
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(imiona, nazwisko, @data_ur, miejsce_ur, pesel, email, telefon, plec)
SET data_ur = STR_TO_DATE(@data_ur, '%d.%m.%Y');

UPDATE uczniowie SET pesel = LPAD(pesel, 11, 0);



CREATE TABLE adres
(
	id_ucznia INT NOT NULL PRIMARY KEY,
    adres VARCHAR(255) NOT NULL,
    kod_pocztowy VARCHAR(6) NOT NULL,
    miejscowosc VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_ucznia) REFERENCES uczniowie(id)
);

LOAD DATA INFILE
"C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Projekt klasy MySQL\\klasa_csv\\Adresy_2.0.csv"
INTO TABLE adres
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(id_ucznia, adres, kod_pocztowy, miejscowosc);



CREATE TABLE rodzina
(
	id_ucznia INT NOT NULL PRIMARY KEY,
    matka VARCHAR(100),
    telefon_matki INT(9),
    email_matki VARCHAR(255),
    ojciec VARCHAR(100),
    telefon_ojca INT(9),
    email_ojca VARCHAR(255),
    liczba_rodzenstwa TINYINT,
    inny_adres_rodzica VARCHAR(255),
    FOREIGN KEY (id_ucznia) REFERENCES uczniowie(id)
);

LOAD DATA INFILE
"C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Projekt klasy MySQL\\klasa_csv\\Rodzina_2.0.csv"
INTO TABLE rodzina
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(id_ucznia, matka, telefon_matki, email_matki, ojciec, telefon_ojca, email_ojca, liczba_rodzenstwa, inny_adres_rodzica);



CREATE TABLE klasyfikacja
(
	id_ucznia INT NOT NULL PRIMARY KEY,
    religia TINYINT NULL,
    polski TINYINT,
    angielski TINYINT,
    niemiecki TINYINT,
    historia TINYINT,
    matematyka TINYINT,
    fizyka TINYINT,
    chemia TINYINT,
    biologia TINYINT,
    geografia TINYINT,
    wf TINYINT NULL,
    informatyka TINYINT,
    przedsiębiorczość TINYINT,
    zachowanie VARCHAR(14),
    FOREIGN KEY (id_ucznia) REFERENCES uczniowie(id)
);

LOAD DATA INFILE
"C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Projekt klasy MySQL\\klasa_csv\\Klasyfikacja_2.0.csv"
INTO TABLE klasyfikacja
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(id_ucznia, @religia, polski, angielski, niemiecki, historia, matematyka, fizyka, chemia, biologia, geografia, @wf, informatyka, przedsiębiorczość, zachowanie)
SET
religia = NULLIF(@religia,''),
wf = NULLIF(@wf,'');



CREATE TABLE frekwencja
(
	id_ucznia INT NOT NULL PRIMARY KEY,
    usprawiedliwione SMALLINT,
    nieusprawiedliwione SMALLINT,
    spoznienia SMALLINT,
    procent_frekwencji DECIMAL(4,2),
    FOREIGN KEY (id_ucznia) REFERENCES uczniowie(id)
);

LOAD DATA INFILE
"C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Projekt klasy MySQL\\klasa_csv\\Frekwencja_2.0.csv"
INTO TABLE frekwencja
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(id_ucznia, usprawiedliwione, nieusprawiedliwione, spoznienia, @procent_frekwencji)
SET procent_frekwencji = REPLACE(@procent_frekwencji, ',', '.');



CREATE TABLE zaleglosci
(
	id_ucznia INT NOT NULL PRIMARY KEY,
    biblioteka TINYINT,
    pielegniarka TINYINT,
    sport TINYINT,
    szafka TINYINT,
    FOREIGN KEY (id_ucznia) REFERENCES uczniowie(id)
);

LOAD DATA INFILE
"C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Projekt klasy MySQL\\klasa_csv\\Zaleglosci_2.0.csv"
INTO TABLE zaleglosci
FIELDS TERMINATED BY ';'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(id_ucznia, biblioteka, pielegniarka, sport, szafka);


