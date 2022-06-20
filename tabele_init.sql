DROP TABLE IF EXISTS archiwum_biletow;
DROP TABLE IF EXISTS bilety;
DROP TABLE IF EXISTS klienci;
DROP TABLE IF EXISTS archiwum_renowacji;
DROP TABLE IF EXISTS konserwacja;
DROP TABLE IF EXISTS eksponaty;
DROP TABLE IF EXISTS wystawy_stale;
DROP TABLE IF EXISTS wystawy_czasowe;
DROP TABLE IF EXISTS pomieszczenia;
DROP TABLE IF EXISTS dzialy_tematyczne;
DROP TABLE IF EXISTS pracownicy;


-- Tabela pracownicy -- 
CREATE TABLE pracownicy (
  id_pracownika int NOT NULL AUTO_INCREMENT,
  imie varchar(50) NOT NULL,
  nazwisko varchar(50) NOT NULL,
  stanowisko varchar(50) NOT NULL,
  pensja decimal(11,2) NOT NULL,
  id_kierownika int DEFAULT -1,
  plec char(1) NOT NULL, CHECK(plec IN('M','F')),
  PRIMARY KEY (id_pracownika),
  KEY (id_kierownika)
);

INSERT INTO pracownicy VALUES 
(-1,'BIG','BOSS','kustosz',100000000.99,DEFAULT,'M'),
(DEFAULT,'Carleton','Baumbach','przewodnik',3310.00,5,'M'),
(DEFAULT,'Monique','Kris','konserwator',1868.60,5,'F'),
(DEFAULT,'Paxton','Medhurst','ochroniarz',3313.35,5,'M'),
(DEFAULT,'Marjorie','Bartell','sprzedawca',3087.75,5,'F'),
(DEFAULT,'Bennie','Nolan','kierownik',1909.62,DEFAULT,'M'),
(DEFAULT,'Frank','Turner','konserwator',2773.52,10,'M'),
(DEFAULT,'Kristoffer','Bailey','sprzedawca',1938.03,10,'M'),
(DEFAULT,'Jaqueline','Block','wozny',3572.66,10,'F'),
(DEFAULT,'Alvena','O\'Conner','wozny',3444.80,10,'F'),
(DEFAULT,'Gabriella','Kunde','kierownik',2691.02,DEFAULT,'F');


-- Tabela działy tematyczne -- 
CREATE TABLE dzialy_tematyczne (
  id_dzialu int NOT NULL AUTO_INCREMENT,
  nazwa_dzialu varchar(50) NOT NULL,
  id_kierownika int NOT NULL,
  PRIMARY KEY (id_dzialu),
  FOREIGN KEY (id_kierownika) REFERENCES pracownicy(id_pracownika)
);

INSERT INTO dzialy_tematyczne VALUES 
(-1,'NULL',-1),
(DEFAULT,'Daleki wschod',5),
(DEFAULT,'Ameryki',5),
(DEFAULT,'Europa',10);

-- Tabela pomieszczenia -- 
CREATE TABLE pomieszczenia (
  id_pomieszczenia int NOT NULL AUTO_INCREMENT,
  pietro int NOT NULL,
  id_dzialu int NOT NULL,
  PRIMARY KEY (id_pomieszczenia),
  FOREIGN KEY (id_dzialu) REFERENCES dzialy_tematyczne(id_dzialu)
);

INSERT INTO pomieszczenia VALUES 
(DEFAULT,1,1),
(DEFAULT,1,1),
(DEFAULT,1,1),
(DEFAULT,1,2),
(DEFAULT,1,2),
(DEFAULT,2,2),
(DEFAULT,2,3),
(DEFAULT,2,3);


-- Tabela wystawy czasowe -- 
CREATE TABLE wystawy_czasowe (
  id_wystawy_cz int NOT NULL AUTO_INCREMENT,
  nazwa_wystawy varchar(50) NOT NULL,
  data_rozpoczecia date NOT NULL,
  data_zakonczenia date NOT NULL,
  id_dzialu int NOT NULL,
  PRIMARY KEY (id_wystawy_cz),
  FOREIGN KEY (id_dzialu) REFERENCES dzialy_tematyczne(id_dzialu)
);

INSERT INTO wystawy_czasowe VALUES 
(-1,'NULL','0000-00-00','0000-00-00',-1),
(DEFAULT,'Sztuka uzytkowa dynastii Ming','2022-04-16','2022-06-24',1),
(DEFAULT,'Numizmatyka europejska XVII wieku','2022-05-19','2022-11-10',2),
(DEFAULT,'Historia alkoholu','2021-01-14','2021-07-03',3);


-- Tabela wystawy stałe -- 
CREATE TABLE wystawy_stale (
  id_wystawy_st int NOT NULL AUTO_INCREMENT,
  nazwa_wystawy varchar(50) NOT NULL,
  id_dzialu int NOT NULL,
  PRIMARY KEY (id_wystawy_st),
  FOREIGN KEY (id_dzialu) REFERENCES dzialy_tematyczne(id_dzialu)
);

INSERT INTO wystawy_stale VALUES 
(-1,'NULL',-1),
(DEFAULT,'Kampania wrzesniowa',1),
(DEFAULT,'Front wschodni I wojny swiatowej',1),
(DEFAULT,'Bron i uzbrojenie z wojny trzydziestoletniej',2),
(DEFAULT,'Dinozaury',2),
(DEFAULT,'sztuka starozytnej grecji',3),
(DEFAULT,'Legiony rzymskie',3);

-- Tabela eksponaty -- 
CREATE TABLE eksponaty (
  id_eksponatu int NOT NULL AUTO_INCREMENT,
  nazwa_eksponatu varchar(50) NOT NULL,
  id_wystawy_st int DEFAULT -1,
  id_wystawy_cz int DEFAULT -1,
  id_pomieszczenia int NOT NULL,
  stan varchar(50) NOT NULL,
  PRIMARY KEY (id_eksponatu),
  FOREIGN KEY (id_wystawy_st) REFERENCES wystawy_stale(id_wystawy_st),
  FOREIGN KEY (id_wystawy_cz) REFERENCES wystawy_czasowe(id_wystawy_cz),
  FOREIGN KEY (id_pomieszczenia) REFERENCES pomieszczenia(id_pomieszczenia)
);

INSERT INTO eksponaty VALUES 
(DEFAULT,'waza',1,DEFAULT,1,'stabliny'),
(DEFAULT,'trex',2,DEFAULT,2,'stabilny'),
(DEFAULT,'karabin',DEFAULT,1,2,'stabilny'),
(DEFAULT,'koczkodan',3,DEFAULT,3,'stabilny'),
(DEFAULT,'czołg',4,DEFAULT,4,'stabilny'),
(DEFAULT,'hulahop',5,DEFAULT,4,'stabilny'),
(DEFAULT,'wazonik',DEFAULT,2,5,'stabilny'),
(DEFAULT,'talerz',DEFAULT,3,6,'stabilny');

-- Tabela konserwacja -- 
CREATE TABLE konserwacja (
  id_konserwacji int NOT NULL AUTO_INCREMENT,
  id_pracownika int,
  data_rozpoczecia date,
  data_zakonczenia date,
  id_eksponatu int NOT NULL,
  PRIMARY KEY (id_konserwacji),
  FOREIGN KEY (id_eksponatu) REFERENCES eksponaty(id_eksponatu),
  FOREIGN KEY (id_pracownika) REFERENCES pracownicy(id_pracownika),
  CONSTRAINT CHECK (data_rozpoczecia < data_zakonczenia)
);


-- Tabela archiwum konserwacji -- 
CREATE TABLE archiwum_renowacji (
  id_konserwacji int NOT NULL,
  id_pracownika int,
  data_rozpoczecia date,
  data_zakonczenia date,
  id_eksponatu int NOT NULL
);


-- Tabela klienci -- 
CREATE TABLE klienci (
  id_klienta int NOT NULL AUTO_INCREMENT,
  imie varchar(50) NOT NULL,
  nazwisko varchar(50) NOT NULL,
  wiek int NOT NULL,
  bilet varchar(50) NOT NULL,
  PRIMARY KEY (id_klienta)
);

-- Tabela bilety -- 
CREATE TABLE bilety (
    rodzaj_biletu VARCHAR(50) NOT NULL,
    cena DECIMAL(11,2) NOT NULL,
    ulga DECIMAL(3,2) NOT NULL,
    PRIMARY KEY (rodzaj_biletu)
);

INSERT INTO bilety VALUES 
('ulgowy',30.00,0.50),
('zwykly',30.00,0.00);

-- Tabela archiwum -- 
CREATE TABLE archiwum_biletow (
  id_biletu int NOT NULL,
  rodzaj_biletu varchar(50) NOT NULL,
  FOREIGN KEY (id_biletu) REFERENCES klienci(id_klienta),
  FOREIGN KEY (rodzaj_biletu) REFERENCES bilety(rodzaj_biletu)
);