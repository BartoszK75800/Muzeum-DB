-- Kierownicy -- 
DROP VIEW IF EXISTS kierownicy;

CREATE VIEW kierownicy AS
	WITH kierownicy_h (id_kierownika, prac) AS (SELECT id_kierownika, COUNT(id_kierownika) prac 
												FROM pracownicy 
                                                GROUP BY id_kierownika)
SELECT CONCAT(p.imie,' ',p.nazwisko) KIEROWNIK, p.pensja PENSJA, p.plec PLEC, h.prac 'LICZBA PRACOWNIKOW'
FROM pracownicy p, kierownicy_h h
WHERE h.id_kierownika = p.id_pracownika;

-- Spis eksponatów --
DROP VIEW IF EXISTS spis_eksponatow;

CREATE VIEW spis_eksponatow AS
SELECT nazwa_eksponatu 'EKSPONAT', (CASE 
						 WHEN e.id_wystawy_cz !=-1 THEN cz.nazwa_wystawy 
						 ELSE st.nazwa_wystawy END) 'WYSTAWA', CONCAT(p.pietro,'/',p.id_pomieszczenia) 'PIETRO/POMIESZCZENIE'
FROM eksponaty e 
JOIN wystawy_czasowe cz USING (id_wystawy_cz) 
JOIN wystawy_stale st USING (id_wystawy_st)
JOIN pomieszczenia p USING(id_pomieszczenia);

-- Cennik --
DROP VIEW IF EXISTS cennik;

CREATE VIEW cennik AS
SELECT rodzaj_biletu 'RODZAJ BILETU', (cena-(cena*ulga)) CENA 
FROM bilety;


-- Wystawy trwajace --
DROP VIEW IF EXISTS wystawy;

CREATE VIEW wystawy AS
SELECT nazwa_wystawy WYSTAWA, nazwa_dzialu DZIAL, 'czasowa' AS 'RODZAJ WYSTAWY'
FROM wystawy_czasowe w, dzialy_tematyczne d
WHERE w.id_dzialu = d.id_dzialu AND w.id_dzialu !=-1 AND current_date() BETWEEN w.data_rozpoczecia AND w.data_zakonczenia
UNION 
SELECT nazwa_wystawy, nazwa_dzialu, 'stala' 
FROM wystawy_stale w, dzialy_tematyczne d
WHERE w.id_dzialu = d.id_dzialu AND w.id_dzialu !=-1;

-- Wystawy zakonczone --
DROP VIEW IF EXISTS archiwum_wystaw;

CREATE VIEW archiwum_wystaw AS
SELECT nazwa_wystawy WYSTAWA, nazwa_dzialu DZIAL, 'zakonczona' AS 'STATUS'
FROM wystawy_czasowe w, dzialy_tematyczne d
WHERE w.id_dzialu = d.id_dzialu AND w.id_dzialu !=-1 AND current_date() > w.data_zakonczenia;


-- Eksponaty w konserwacji -- 
DROP VIEW IF EXISTS konserwacje;

CREATE VIEW konserwacje AS
(SELECT e.nazwa_eksponatu EKSPONAT, (CASE 
									 WHEN e.id_wystawy_cz !=-1 THEN cz.nazwa_wystawy 
                                     ELSE st.nazwa_wystawy END) WYSTAWA, CONCAT(p.imie,' ',p.nazwisko) PRACOWNIK, k.data_rozpoczecia 'DATA ROZPOCZECIA'
FROM eksponaty e 
JOIN wystawy_czasowe cz USING (id_wystawy_cz) 
JOIN wystawy_stale st USING (id_wystawy_st)
JOIN konserwacja k USING (id_eksponatu)
JOIN pracownicy p USING (id_pracownika)
WHERE e.stan = 'konserwacja');

-- Eksponaty do konserwacji -- 
DROP VIEW IF EXISTS niestabilne;

CREATE VIEW niestabilne AS
(SELECT e.nazwa_eksponatu EKSPONAT, (CASE 
									 WHEN e.id_wystawy_cz !=-1 THEN cz.nazwa_wystawy 
									 ELSE st.nazwa_wystawy END) WYSTAWA, CONCAT(p.pietro,'/',p.id_pomieszczenia) 'PIETRO/POMIESZCZENIE'
FROM eksponaty e
JOIN wystawy_czasowe cz USING (id_wystawy_cz) 
JOIN wystawy_stale st USING (id_wystawy_st)
JOIN pomieszczenia p USING (id_pomieszczenia)
WHERE e.stan = 'niestabilny');


-- Zakupione bilety--
DROP VIEW IF EXISTS przychody;

CREATE VIEW przychody AS
SELECT COUNT(a.id_biletu) 'ILOSC BILETOW', SUM(b.cena-(b.cena*b.ulga)) PRZYCHOD, b.rodzaj_biletu 'RODZAJ BILETU' 
FROM archiwum_biletow a 
JOIN bilety b USING(rodzaj_biletu)
GROUP BY(rodzaj_biletu);


-- Wydatki na stanowiska --
DROP VIEW IF EXISTS wydatki;

CREATE VIEW wydatki AS
SELECT COUNT(id_pracownika) 'ILOSC PRACOWNIKOW', SUM(pensja) WYDATKI, stanowisko 'STANOWISKO' 
FROM pracownicy
GROUP BY stanowisko;


-- Bilans wydatków i przychodów --
DROP VIEW IF EXISTS bilans;

CREATE VIEW bilans AS
	WITH przychody_h (przychody) AS (SELECT SUM(b.cena-(b.cena*b.ulga)) 
									 FROM archiwum_biletow a 
                                     JOIN bilety b USING(rodzaj_biletu)),
		 wydatki_h (wydatki) AS (SELECT SUM(p.pensja) 
								 FROM pracownicy p)
SELECT p.przychody-w.wydatki BILANS 
FROM przychody_h p, wydatki_h w;