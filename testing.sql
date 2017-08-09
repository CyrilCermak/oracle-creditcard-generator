
declare 
 creditCard integer := 0;
begin 
  for i in 1..100  loop 
   creditCard := creditCardGenerator.createCreditCard;
   dbms_output.put_line('Card ' || creditCard);
  end loop;
end;
/