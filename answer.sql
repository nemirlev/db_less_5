-- а) Какие фамилии читателей в Москве?
SELECT "ID", "LastName"
FROM "Reader"
WHERE "Address" LIKE '%Москва%';

-- б) Какие книги (author, title) брал Иван Иванов?
SELECT "Author", "Title"
FROM "Book"
         JOIN "Borrowing" B on "Book"."ISBN" = B."ISBN"
         JOIN "Reader" R on B."ReaderNr" = R."ID"
WHERE R."FirstName" = 'Иванов'
  AND R."LastName" = 'Иван'

-- в) Какие книги (ISBN) из категории "Горы" не относятся к категории "Путешествия"? Подкатегории не обязательно принимать во внимание!

SELECT "ISBN"
FROM public."BookCat"
WHERE "CategoryName" = 'Горы'
EXCEPT
SELECT "ISBN"
FROM public."BookCat"
WHERE "CategoryName" = 'Путешествия';

SELECT "ISBN"
FROM public."BookCat"
WHERE "CategoryName" = 'Горы' AND "CategoryName" != 'Путешествия';

-- г) Какие читатели (LastName, FirstName) вернули копию книги?

SELECT "FirstName", "LastName"
FROM public."Reader"
         JOIN "Borrowing" ON "Reader"."ID" = "Borrowing"."ReaderNr"
WHERE "Borrowing"."ReturnDate" IS NOT NULL;

-- Вернуть только уникальных читателей
SELECT DISTINCT "FirstName", "LastName"
FROM public."Reader"
         JOIN "Borrowing" ON "Reader"."ID" = "Borrowing"."ReaderNr"
WHERE "Borrowing"."ReturnDate" IS NOT NULL;

-- Какие читатели (LastName, FirstName) брали хотя бы одну книгу (не копию), которую брал также Иван Иванов (не включайте Ивана Иванова в результат)?

SELECT "LastName", "FirstName"
FROM public."Reader" R
         JOIN "Borrowing" B ON R."ID" = B."ReaderNr"
WHERE "ISBN" IN
      (SELECT "ISBN"
       FROM "Borrowing" B2
                JOIN "Reader" R ON R."ID" = B2."ReaderNr"
       WHERE R."LastName" = 'Иван'
         AND R."FirstName" = 'Иванов'
      )
EXCEPT
SELECT "LastName", "FirstName"
FROM public."Reader" R
         JOIN "Borrowing" B ON R."ID" = B."ReaderNr"
WHERE (R."LastName" = 'Иван' AND R."FirstName" = 'Иванов');

-- Найдите все прямые рейсы из Москвы в Тверь.

SELECT trainnr
FROM trains.connection
WHERE connection.fromstation IN (SELECT fromstation
                                 FROM trains.connection AS c
                                          JOIN trains.station ON station.name = c.tostation
                                 WHERE cityname = 'Тверь')
  AND connection.tostation IN (SELECT tostation
                               FROM trains.connection AS c
                                        JOIN trains.station ON station.name = c.fromstation
                               WHERE cityname = 'Москва');

SELECT conn.TrainNr,conn.Departure,conn.Arrival
FROM Train AS train
         JOIN Connection AS conn
              ON Connection.TrainNr = TrainNr
WHERE conn.FromStation = 'Moscow'
  AND conn.ToStation = 'Tver'
  AND NOT EXISTS(
        SELECT 1
        FROM Connection sconn
        WHERE sconn.TrainNr = conn.TrainNr
          AND sconn.FromStation = 'Moscow'
          AND sconn.ToStation <> 'Tver');

-- Найдите все многосегментные маршруты, имеющие точно однодневный трансфер из Москвы в Санкт-Петербург (первое отправление и прибытие в конечную точку должны быть в одну и ту же дату). Вы можете применить функцию DAY () к атрибутам Departure и Arrival, чтобы определить дату.

SELECT trainnr
FROM trains.connection
WHERE connection.fromstation IN (SELECT fromstation
                                 FROM trains.connection AS c
                                          JOIN trains.station ON station.name = c.tostation
                                 WHERE cityname = 'Санкт-Петербург')
  AND connection.tostation IN (SELECT tostation
                               FROM trains.connection AS c
                                        JOIN trains.station ON station.name = c.fromstation
                               WHERE cityname = 'Москва')
  AND DATE(departure) = DATE(arrival);

SELECT conn.TrainNr,conn.Departure,sconn.Arrival
FROM Connection AS conn
         JOIN Connection AS sconn
              ON conn.TrainNr = sconn.TrainNr
WHERE conn.FromStation = 'Moscow'
          AND sconn.FromStation <> 'Moscow'
          AND sconn.ToStation = 'St.Petersburg'
          AND DAY (conn.Departure) = DAY (conn.Arrival);

SELECT Conn1.Departure,
       Conn1.TrainNr,
       Conn2.Arrival
FROM Connection AS Conn1
         JOIN Connection AS Conn2 ON Conn1.TrainNr = Conn2.TrainNr
WHERE (DAY (Conn1.Departure) = DAY (Conn2.Arrival) AND
          (Сonn2.ToStation = 'Санкт-Петербург' AND Conn1.FromStation = 'Москва'));