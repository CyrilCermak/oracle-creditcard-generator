set serveroutput on;

declare
-- 1->MasterCard, 2->Visa, 3->Discovery, 4->American Express
begin
  EXECUTE IMMEDIATE 'truncate table logtable';
	RANDOMDATAGENERATOR.GENERATE(limit_number => 250000, creditCardType => 1); -- generates MasterCard
	RANDOMDATAGENERATOR.GENERATE(limit_number => 250000, creditCardType => 2); -- generates Visa
  RANDOMDATAGENERATOR.GENERATE(limit_number => 250000, creditCardType => 3); -- generates Discovery
  RANDOMDATAGENERATOR.GENERATE(limit_number => 250000, creditCardType => 4); -- generates American Express
end;

select * from customers;
select count(*) from customers;
truncate table customers;

truncate table logtable;
select count(*) from logtable;
select * from logtable;