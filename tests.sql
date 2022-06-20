-- Spis wystaw -- 
SELECT * 
FROM wystawy;

-- Spis eksponatów --
SELECT *
FROM spis_eksponatow;

-- Kierownicy w muzeum --
SELECT * 
FROM kierownicy;

-- Najwyższa pensja pracownika na danym stanowisku --
SELECT stanowisko STANOWISKO, CONCAT(imie,' ',nazwisko) PRACOWNIK, MAX(pensja) PENSJA
FROM pracownicy
GROUP BY stanowisko;

-- Wyswietlenie eksponatu potencjalnie nadającego się do konserwacji (eksponat nie był nigdy konserwowany ani nie jest aktualnie) --
SELECT id_eksponatu 'ID EKSPONATU', nazwa_eksponatu 'NAZWA EKSPONATU'
FROM eksponaty
WHERE id_eksponatu NOT IN (SELECT id_eksponatu FROM konserwacja)
AND id_eksponatu NOT IN (SELECT id_eksponatu FROM archiwum_renowacji);

-- Wyswietlenie stanu pracy konserwatorów --
SELECT id_pracownika 'ID PRACOWNIKA', CONCAT(imie,' ', nazwisko) 'PRACOWNIK', (CASE WHEN id_pracownika NOT IN (SELECT id_pracownika FROM konserwacja) THEN 'wolny' ELSE 'zajety' END) AS 'STAN PRACY'
FROM pracownicy
WHERE stanowisko = 'konserwator';

-- Sprawdzenie czy działa trigger konserwacji --
SELECT * FROM konserwacje;
SELECT * FROM eksponaty;
SELECT * FROM archiwum_renowacji;
DELETE FROM konserwacja WHERE id_eksponatu = 1;
SELECT * FROM konserwacje;
SELECT * FROM eksponaty;

-- Sprawdzenie czy działa trigger biletów --
SELECT COUNT(*) FROM klienci;
SELECT COUNT(*) FROM archiwum_biletow;

-- Sprawdzenie bilansu kasy muzeum --
SELECT * FROM przychody;
SELECT * FROM wydatki;
SELECT ROUND(SUM(PRZYCHOD),2)
FROM przychody
UNION 
SELECT ROUND(SUM(WYDATKI),2) FROM wydatki
UNION
SELECT ROUND(BILANS,2)
FROM bilans;

-- Kalendarz wystaw czasowych --
SELECT nazwa_wystawy, data_rozpoczecia, data_zakonczenia, nazwa_dzialu, CONCAT(imie,' ',nazwisko) kierownik 
FROM pracownicy, wystawy_czasowe w
JOIN dzialy_tematyczne USING(id_dzialu)
WHERE id_dzialu != -1 AND dzialy_tematyczne.id_kierownika = pracownicy.id_pracownika AND current_date() BETWEEN w.data_rozpoczecia AND w.data_zakonczenia;
SELECT * FROM archiwum_wystaw;

-- Cennik biletów --
SELECT `RODZAJ BILETU` , ROUND(CENA,2) CENA 
FROM cennik;

-- W jakim dziale i pomieszczeniu znajdują się eksponaty, których nazwa zaczyna się na literę k lub t --
SELECT d.nazwa_dzialu DZIAL, CONCAT(p.pietro,'/',p.id_pomieszczenia) 'PIETRO/POMIESZCZENIE', e.nazwa_eksponatu EKSPONAT
FROM dzialy_tematyczne d
JOIN pomieszczenia p USING(id_dzialu)
JOIN eksponaty e USING(id_pomieszczenia)
WHERE e.nazwa_eksponatu LIKE 't%' OR e.nazwa_eksponatu LIKE 'k%';