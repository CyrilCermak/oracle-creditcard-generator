set serveroutput on;

CREATE OR REPLACE PACKAGE creditCardGenerator AS
   FUNCTION createCreditCard(cardType in number) RETURN integer;
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

  function createCreditCard(cardType in number) return integer is 
    begin    
    case cardType 
     when 1 then -- MasterCard
        SELECT dbms_random.value(520000000000000,529999999999999) num into randomNumber FROM dual;
     when 2 then -- Visa
        SELECT dbms_random.value(453900000000000,453999999999999) num into randomNumber FROM dual;
     when 3 then -- Discovery
        SELECT dbms_random.value(601100000000000,601199999999999) num into randomNumber FROM dual;
     when 4 then -- American Express
        SELECT dbms_random.value(340000000000000,349999999999999) num into randomNumber FROM dual;
    else 
        SELECT dbms_random.value(100000000000000,999999999999999) num into randomNumber FROM dual;
      end case;
      splitNumberIntoArray(round(randomNumber));
      generateCard;
      return creditCardNumber;
    end createCreditCard;

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
     creditCardString varchar(17);
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
     creditCardString := '';
     FOR i in 1 .. numbersArray.count LOOP
          creditCardString := creditCardString || numbersArray(i);
     END LOOP;
      creditCardString := creditCardString || to_char(checkDigit);
      creditCardNumber := to_number(creditCardString);
  end;
    
end creditCardGenerator;

