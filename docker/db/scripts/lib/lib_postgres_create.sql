CREATE TABLE "Reader"
(
    "ID"        int  NOT NULL,
    "LastName"  varchar NOT NULL,
    "FirstName" varchar NOT NULL,
    "Address"   varchar NOT NULL,
    "BirthDate" DATE    NOT NULL,
    CONSTRAINT "Reader_pk" PRIMARY KEY ("ID")
) WITH (
      OIDS= FALSE
    );



CREATE TABLE "Book"
(
    "ISBN"     varchar unique NOT NULL,
    "Title"    varchar        NOT NULL,
    "Author"   varchar        NOT NULL,
    "PagesNum" int            NOT NULL,
    "PubYear"  int            NOT NULL,
    "PubName"  varchar        NOT NULL,
    CONSTRAINT "Book_pk" PRIMARY KEY ("ISBN")
) WITH (
      OIDS= FALSE
    );



CREATE TABLE "Borrowing"
(
    "ReaderNr"   int     NOT NULL,
    "ISBN"       varchar NOT NULL,
    "CopyNumber" serial  NOT NULL,
    "ReturnDate" DATE    NOT NULL,
    CONSTRAINT "Borrowing_pk" PRIMARY KEY ("ReaderNr", "ISBN", "CopyNumber")
) WITH (
      OIDS= FALSE
    );



CREATE TABLE "Copy"
(
    "CopyNumber"    int     NOT NULL,
    "ISBN"          varchar NOT NULL,
    "ShelfPosition" int     NOT NULL,
    CONSTRAINT "Copy_pk" PRIMARY KEY ("CopyNumber", "ISBN")
) WITH (
      OIDS= FALSE
    );



CREATE TABLE "Category"
(
    "CategoryName" varchar NOT NULL,
    "ParentCat"    varchar null,
    CONSTRAINT "Category_pk" PRIMARY KEY ("CategoryName")
) WITH (
      OIDS= FALSE
    );



CREATE TABLE "Publisher"
(
    "PubName"   varchar NOT NULL,
    "PubAdress" varchar NOT NULL,
    CONSTRAINT "Publisher_pk" PRIMARY KEY ("PubName")
) WITH (
      OIDS= FALSE
    );



CREATE TABLE "BookCat"
(
    "ISBN"         varchar NOT NULL,
    "CategoryName" varchar NOT NULL,
    CONSTRAINT "BookCat_pk" PRIMARY KEY ("ISBN")
) WITH (
      OIDS= FALSE
    );



ALTER TABLE "Book"
    ADD CONSTRAINT "Book_fk0" FOREIGN KEY ("PubName") REFERENCES "Publisher" ("PubName");

ALTER TABLE "Borrowing"
    ADD CONSTRAINT "Borrowing_fk0" FOREIGN KEY ("ReaderNr") REFERENCES "Reader" ("ID");
ALTER TABLE "Borrowing"
    ADD CONSTRAINT "Borrowing_fk1" FOREIGN KEY ("CopyNumber", "ISBN") REFERENCES "Copy" ("CopyNumber", "ISBN");

ALTER TABLE "Copy"
    ADD CONSTRAINT "Copy_fk0" FOREIGN KEY ("ISBN") REFERENCES "Book" ("ISBN");

ALTER TABLE "Category"
    ADD CONSTRAINT "Category_fk0" FOREIGN KEY ("ParentCat") REFERENCES "Category" ("CategoryName");


ALTER TABLE "BookCat"
    ADD CONSTRAINT "BookCat_fk0" FOREIGN KEY ("ISBN") REFERENCES "Book" ("ISBN");
ALTER TABLE "BookCat"
    ADD CONSTRAINT "BookCat_fk1" FOREIGN KEY ("CategoryName") REFERENCES "Category" ("CategoryName");














