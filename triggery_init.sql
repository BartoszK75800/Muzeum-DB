SET SQL_SAFE_UPDATES = 0;
DROP TRIGGER IF EXISTS konserwowanie;
DROP TRIGGER IF EXISTS archiwizacja_renowacji;
DROP TRIGGER IF EXISTS po_renowacji;
DROP TRIGGER IF EXISTS zwolnienie_kierownika;
DROP TRIGGER IF EXISTS archiwizacja_biletow;

-- Dodanie do konserwacji --
CREATE TRIGGER konserwowanie
AFTER INSERT
ON konserwacja
FOR EACH ROW
UPDATE eksponaty
SET eksponaty.stan = 'konserwacja'
WHERE eksponaty.id_eksponatu IN (SELECT id_eksponatu FROM konserwacja);

-- Dodanie do archiwum renowacji --
CREATE TRIGGER archiwizacja_renowacji
AFTER INSERT
ON konserwacja
FOR EACH ROW
INSERT INTO archiwum_renowacji(id_konserwacji, id_pracownika, data_rozpoczecia, data_zakonczenia, id_eksponatu)
values (NEW.id_konserwacji, NEW.id_pracownika, NEW.data_rozpoczecia, NEW.data_zakonczenia, NEW.id_eksponatu);

INSERT INTO konserwacja VALUES
(DEFAULT,2,'2022-02-12','2022-10-22',1),
(DEFAULT,6,'2021-03-15','2022-12-01',3),
(DEFAULT,6,'2022-03-15','2022-12-01',5);

-- Usunięcie z konserwacji --
CREATE TRIGGER po_renowacji
AFTER DELETE
ON konserwacja
FOR EACH ROW
UPDATE eksponaty
SET eksponaty.stan = 'stabilny'
WHERE eksponaty.id_eksponatu NOT IN (SELECT id_eksponatu FROM konserwacja);

-- Wstawianie do biletów --
CREATE TRIGGER archiwizacja_biletow
AFTER INSERT
ON klienci
FOR EACH ROW
INSERT INTO archiwum_biletow(id_biletu, rodzaj_biletu)
VALUES (NEW.id_klienta, NEW.bilet);

INSERT INTO klienci VALUES 
(DEFAULT,'Stephon','Gutkowski',5,'ulgowy'),
(DEFAULT,'Rickie','Funk',22,'ulgowy'),
(DEFAULT,'Alaina','Zulauf',70,'zwykly'),
(DEFAULT,'Demario','O\'Conner',8,'ulgowy'),
(DEFAULT,'Shanie','West',68,'zwykly');