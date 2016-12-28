set serveroutput on;

CREATE OR REPLACE PACKAGE creditCardGenerator AS
   PROCEDURE startGenerating;
   PROCEDURE splitNumberIntoArray(n in number);
   PROCEDURE varcharToArray(text in varchar2);
   PROCEDURE iterateThroughArray;
   PROCEDURE generateCard;
   
   randomNumber number;
   type numbersArrayType is varray(16) of integer;
   numbersArray numbersArrayType;
   creditCardNumber integer := 0;
END creditCardGenerator;

CREATE OR REPLACE PACKAGE BODY creditCardGenerator AS

  procedure startGenerating is 
    begin 
    SELECT dbms_random.value(1000000000000000,9999999999999) num into randomNumber FROM dual;
      splitNumberIntoArray(round(randomNumber));
      generateCard();
            
    end startGenerating;

  procedure splitNumberIntoArray(n in number) is 
    begin
     varcharToArray(to_char(n));
    end;
    
  procedure varcharToArray(text in varchar2) is 
    begin
      numbersArray := numbersArrayType(); 
      for i in 1 .. length(text) loop
       DBMS_OUTPUT.PUT_LINE(substr(text,i,1));
       numbersArray.extend();
       numbersArray(i) := (to_number(substr(text,i,1)));
      end loop;
      iterateThroughArray();
    end;
    
    
    PROCEDURE iterateThroughArray is 
      begin
       dbms_output.put_line('Array count' || numbersArray.count);
        FOR i in 1 .. numbersArray.count LOOP
        dbms_output.put_line(numbersArray(i));
       END LOOP;
      end;
    
    
    PROCEDURE generateCard is 
     type numbersArrayType is varray(17) of integer;
     numbersArray numbersArrayType;
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
        dbms_output.put_line(sumInt);
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
    dbms_output.put_line('Card ' || creditCardNumber );
  end;
    
end creditCardGenerator;


declare 
  type numbersArrayType is varray(17) of integer;
   numbersArray numbersArrayType;
   sumInt integer;
   sumOfAll integer := 0;
   numInt integer;
   checkDigit integer;
   creditCardString varchar(16);
   creditCardNumber integer := 0;
begin 
  numbersArray := numbersArrayType(4,5,0,7,9,4,2,5,7,1,6,9,3,4,5);
  for i in 1..numbersArray.count loop 
    numInt := numbersArray(i);
    sumInt := numInt + numInt; 
    if mod(i,2) = 1 or i = 0  then
    dbms_output.put_line(sumInt);
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
  dbms_output.put_line('Printing');
  dbms_output.put_line('SumOfAll ' || sumOfAll);
  dbms_output.put_line('CheckDigit ' || checkDigit);
  
  creditCardString := '';
   FOR i in 1 .. numbersArray.count LOOP
        creditCardString := creditCardString || to_char(numbersArray(i));
   END LOOP;
   creditCardNumber := to_number(creditCardString);
  dbms_output.put_line('Card ' || creditCardNumber );
end; 
/


declare 

begin 
  creditCardGenerator.startGenerating;
end;
/

