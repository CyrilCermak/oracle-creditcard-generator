set serveroutput on;

create Table Customers (
	firstName varchar2(15) not null,
	lastName varchar2(20) not null,
	address varchar2(100) not null,
	creditCard number(11) not null,
  CONSTRAINT customer_id PRIMARY KEY (creditCard)
)

CREATE OR REPLACE PACKAGE creditCardGenerator AS
   FUNCTION startGenerating RETURN integer;
   PROCEDURE splitNumberIntoArray(n in number);
   PROCEDURE varcharToArray(text in varchar2);
   PROCEDURE iterateThroughArray;
   PROCEDURE generateCard;
   randomNumber number;
   type numbersArrayType is varray(17) of integer;
   numbersArray numbersArrayType;
   creditCardNumber integer := 0;
END creditCardGenerator;

CREATE OR REPLACE PACKAGE BODY creditCardGenerator AS

  function startGenerating return integer is 
    begin 
    SELECT dbms_random.value(1000000000000000,9999999999999) num into randomNumber FROM dual;
      splitNumberIntoArray(round(randomNumber));
      generateCard;
      return creditCardNumber;
    end startGenerating;

  procedure splitNumberIntoArray(n in number) is 
    begin
     varcharToArray(to_char(n));
    end;
    
  procedure varcharToArray(text in varchar2) is 
    begin
      numbersArray := numbersArrayType(); 
      for i in 1 .. length(text) loop
       numbersArray.extend();
       numbersArray(i) := (to_number(substr(text,i,1)));
      end loop;
      --iterateThroughArray();
    end;
    
    --helper procedure
    PROCEDURE iterateThroughArray is 
      begin
        FOR i in 1 .. numbersArray.count LOOP
        dbms_output.put_line(numbersArray(i));
       END LOOP;
      end;
    
    PROCEDURE generateCard is 
     sumInt integer;
     sumOfAll integer := 0;
     numInt integer;
     checkDigit integer;
     creditCardString varchar(16);
    begin 
      for i in 1..numbersArray.count loop 
        numInt := numbersArray(i);
        sumInt := numInt + numInt; 
        if mod(i,2) = 1 or i = 0  then
          if sumInt >= 10 then
            sumOfAll := sumOfAll + (sumInt - 9);
            else 
            sumOfAll :=  sumOfAll + sumInt; 
          end if;
        else 
          sumOfAll := sumOfAll + numInt;
        end if;
      end loop;
     checkDigit := mod(sumOfAll*9, 10);
    numbersArray.extend();
    numbersArray(16) := checkDigit;     
    creditCardString := '';
     FOR i in 1 .. numbersArray.count LOOP
          creditCardString := creditCardString || to_char(numbersArray(i));
     END LOOP;
     creditCardNumber := to_number(creditCardString);
  end;
    
end creditCardGenerator;




CREATE OR REPLACE PROCEDURE data_generator (limit_number IN PLS_INTEGER DEFAULT 100) IS
    CURSOR tableCursor IS
    select first_name, last_name
    from fullname_table;
    
    first_name fullname_table.first_name%type;
    last_name fullname_table.last_name%type;
    creditCard integer := 0;
    fetchedRecords integer := 0;
BEGIN   
   OPEN tableCursor;
  
  LOOP
    FETCH tableCursor INTO first_name, last_name; 
    fetchedRecords := fetchedRecords + 1;
    EXIT WHEN tableCursor%NOTFOUND;
    EXIT WHEN fetchedRecords = limit_number;
    creditCard := creditCardGenerator.startGenerating;
    dbms_output.put_line('Jmeno: ' || last_name || ' ' || first_name || ' Card ' || creditCard);
  END LOOP;

  -- kurzor je vhodne i zavrit
  CLOSE tableCursor;
END data_generator;








declare

begin
data_generator(10);
end;















declare 
 creditCard integer := 0;
begin 
 creditCard := creditCardGenerator.startGenerating;
 dbms_output.put_line('Card ' || creditCard);
end;
/
