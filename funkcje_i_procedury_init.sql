SET GLOBAL log_bin_trust_function_creators = 1;

DROP FUNCTION IF EXISTS ObliczCeneBiletu;
DROP FUNCTION IF EXISTS GodnoscPracownika;
DROP FUNCTION IF EXISTS LokalizacjaPomieszczenia;
DROP PROCEDURE IF EXISTS StatusKonserwatora;
DROP PROCEDURE IF EXISTS SprawdzCeneBiletu;

DELIMITER //
-- Oblicza cenę biletu z ulgą
CREATE FUNCTION ObliczCeneBiletu(cena INT, ulga INT) RETURNS INT
BEGIN
	DECLARE price INT;
    SET price = cena-(cena*ulga);
    RETURN price;
END; //
DELIMITER //

DELIMITER //
-- Łączy imię i nazwisko
CREATE FUNCTION GodnoscPracownika(first VARCHAR(50), last VARCHAR(50)) RETURNS VARCHAR(50)
BEGIN
	DECLARE name VARCHAR(50);
	SET name = CONCAT(first,' ',last);
    RETURN name;
END; //
DELIMITER ;

DELIMITER //
-- Łączy piętro i pomieszczenie
CREATE FUNCTION LokalizacjaPomieszczenia(pietro VARCHAR(50), pomieszczenie VARCHAR(50)) RETURNS VARCHAR(50)
BEGIN
	DECLARE lokalizacja VARCHAR(50);
	SET lokalizacja = CONCAT(pietro,'/',pomieszczenie);
    RETURN lokalizacja;
END; //
DELIMITER ;

DELIMITER //
-- Sprawdzenie czy konserwator jest aktualnie zajęty
CREATE PROCEDURE StatusKonserwatora(IN id VARCHAR(50))
BEGIN
	SELECT id_pracownika 'ID PRACOWNIKA', GodnoscPracownika(imie,nazwisko) 'PRACOWNIK', (CASE WHEN id_pracownika NOT IN (SELECT id_pracownika FROM konserwacja) 
																						THEN 'wolny' ELSE 'zajety' END) AS 'STAN PRACY'
    FROM pracownicy
	WHERE stanowisko = 'konserwator' AND id_pracownika = id;
END; //
DELIMITER ;

CALL StatusKonserwatora(2);

DELIMITER //
-- Sprawdzenie ceny wybranego biletu
CREATE PROCEDURE SprawdzCeneBiletu(IN bilet VARCHAR(50))
BEGIN
	SELECT rodzaj_biletu 'RODZAJ BILETU', ROUND(cena-(cena*ulga),2) CENA 
	FROM bilety
    WHERE rodzaj_biletu = bilet;
END; //
DELIMITER ;

CALL SprawdzCeneBiletu('ulgowy');