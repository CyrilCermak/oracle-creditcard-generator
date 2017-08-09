set serveroutput on;

CREATE OR REPLACE PACKAGE RandomDataGenerator AS

  PROCEDURE generate(limit_number IN PLS_INTEGER DEFAULT 100, creditCardType in number);
  PROCEDURE makeRandomTable;
  FUNCTION createPhoneNumber return number;
  
END RandomDataGenerator;

--Package for generating random card
CREATE OR REPLACE PACKAGE BODY RandomDataGenerator AS 

  PROCEDURE generate (limit_number IN PLS_INTEGER DEFAULT 100, creditCardType in number) IS    
      firstname fakedata.firstname%type;
      lastname fakedata.lastname%type;
      address fakedata.address%type;
      creditCard integer := 0;
      insertedRecords integer := 0;
      phoneNumber integer := 0;
      randomFirstNameIndex integer := 1;
      randomLastNameIndex integer := 1;
      randomAddresssIndex integer := 1;
      
      type array IS TABLE OF fakedata%ROWTYPE;
      rowDataArray array;
            
      CURSOR tableCursor IS
      select firstname, lastname , address
      from fakedata;
  BEGIN   
    insertedRecords := 1;
    OPEN tableCursor;
      fetch tableCursor bulk collect into rowDataArray;
      --EXIT WHEN tableCursor%NOTFOUND;
      if tableCursor%NOTFOUND then 
        DBMS_OUTPUT.PUT_LINE('Cursor was not found please follow the steps in read me and try again. Program was not executed.');
        return;
      end if;
     BEGIN
       while insertedRecords <= limit_number 
          loop
          randomFirstNameIndex := round(dbms_random.value(1,rowDataArray.count));
          randomLastNameIndex := round(dbms_random.value(1,rowDataArray.count));
          randomAddresssIndex := round(dbms_random.value(1,rowDataArray.count));
          
          firstName := rowDataArray(randomFirstNameIndex).firstname;
          lastName := rowDataArray(randomLastNameIndex).lastname;
          address := rowDataArray(randomAddresssIndex).address;
          creditCard := creditCardGenerator.createCreditCard(creditCardType);
          phoneNumber:= createPhoneNumber();
          
          --dbms_output.put_line(firstname || ', '|| lastname || ', ' || address || ', ' || phoneNumber || ', ' || creditCard );
            begin 
              insertedRecords := insertedRecords + 1;
              insert into customers(firstname,lastname, address, creditcard, phonenumber) VALUES (firstname, lastname, address, creditcard,phoneNumber);
            exception
              when DUP_VAL_ON_INDEX then
                insert into logtable(created,type,text) values(sysdate,1,'Credit card was duplicated.');
                insertedRecords := insertedRecords - 1;
                commit;
              when others then 
                insertedRecords := insertedRecords - 1;
                insert into logtable(created,type,text) values(sysdate,2,'Could not insert into customers from unknown reasons.');
                commit;
            end;
            if mod(insertedRecords, 100) = 0 then -- Inserting and commiting every 100 records
              insert into logtable(created,type,text) values(sysdate,3,'Successfully commited 100 records.');
              commit;
            end if;
          end loop;
        commit; -- commiting when loop has finished
       END;
       insert into logtable(created,type,text) values(sysdate,0,'Program successfully generated ' || limit_number || ' with credit card type ' || creditCardType || '.');
      CLOSE tableCursor;
  END;
  
  --This procedure is deprecated, it is not being used in the program now
  PROCEDURE makeRandomTable IS 

    BEGIN
       EXECUTE IMMEDIATE 'truncate TABLE fakedata_unordered';
       EXECUTE IMMEDIATE 'insert into fakedata_unordered(firstname,lastname,address) select firstname,lastname,address from fakedata order by dbms_random.value'; 
    EXCEPTION
       WHEN OTHERS THEN
         IF SQLCODE != -942 THEN
             RAISE;
          END IF;
    END;
  
  FUNCTION createPhoneNumber return number IS  
    operatorType number := 0;
    phoneNumber number := 0;
  
    BEGIN 
      operatorType := round(dbms_random.value(0,3));
      
      case operatorType 
      when 0 then
        phoneNumber := round(dbms_random.value(630000000,630999999));
      when 1 then 
        phoneNumber := round(dbms_random.value(720000000,720999999));
      when 2 then 
         phoneNumber := round(dbms_random.value(777000000,777999999));
      when 3 then 
        phoneNumber := round(dbms_random.value(728000000,728999999));
      else 
         phoneNumber := 123456789;
      end case;
      return phoneNumber;
    end;
  
  
end RandomDataGenerator;
