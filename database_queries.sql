set pagesize 300;
set linesize 300;

column name format a20;
column salary format $9999990.00;
create or replace view q1 as
	select party.givenname|| ' '|| party.familyname as NAME, employee.salary as SALARY from party 
        inner join employee on party.id=employee.id and employee.position='Underwriter';

create or replace view q2 as
	select givenname|| ' ' || familyname as NAME, street||', '||suburb || ' '  ||state|| ' ' ||POSTCODE  as address from party where id IN
        (select client from holds where policy IN(select policy from covers where coverage in
        (select coverage from ratingaction where action='D'))) order by name;

column name format a20;
create or replace view q3 as
	select givenname|| ' ' || familyname as name from party where id in 
        (select id from employee where id in(select client from policy inner join holds on policy.id=holds.policy and policy.status='OK'));

column MoneyCollected format $9999990.00
column MoneyCollected heading "Total|Money|Collected"
create or replace view q4 as
	select sum(premium) as MoneyCollected from policy;


column MoneyPaid format $9999990.00
column MoneyPaid heading "Total|Money|Paid Out"
create or replace view q5 as
	select sum(amount) as MoneyPaid from claimaction where action='PO';

column name format a20
create or replace view q6 as
	select givenname|| ' '||familyname as NAME from party where id in
        (select claim.claimant from claim inner join holds on claim.claimant=holds.client and claim.policy=holds.policy);

create or replace view q7 as
	select distinct(policy) from coverage inner join covers on coverage.id=covers.coverage 
        inner join covereditem on covers.item=covereditem.id where covervalue > marketvalue order by policy;

column make format a12
column model format a12
column NumberInsured format 999 heading "#"
create or replace view q8 as
	select make,model,count(make) as NumberInsured from covereditem group by make,model order by make;

column PolicyHolder format a20
column PolicyHolder heading "Employee|Holding|Policy"
column PolicyProcessor format a20
column PolicyProcessor heading "Employee|Processing|Policy"
create or replace view q9 as
	select prt1.givenname||' '||prt1.familyname as PolicyHolder, prt2.givenname||' '||prt2.familyname as PolicyProcessor from party prt1, party prt2, holds hld,employee emp  where 
        prt1.id= hld.client and emp.id=hld.client and emp.id=prt1.id and prt2.id IN 
        ((select ra.rater from ratingaction ra,covers cv,holds hl where ra.coverage=cv.coverage and hl.policy=cv.policy and hl.client=prt1.id ) UNION 
        (select uw.underwriter from underwritingaction uw,holds where uw.policy=holds.policy and holds.client=prt1.id))  order by PolicyHolder, PolicyProcessor;

column id heading "Policy#"
column make heading "Make"
column model heading "Model"
create or replace view q10 as
	select distinct b.policy as id,a.make,a.model from covereditem a inner join covers b on b.item=a.id where not exists
        ((select distinct(description) from coverage) MINUS 
        (select description from coverage inner join covers on covers.coverage=coverage.id where covers.policy=b.policy));


--PL/SQL;
create or replace
procedure discount
is
cursor d is select givenname|| ' '||familyname as name,policy,premium from holds 
inner join policy on holds.policy=policy.id inner join party on party.id=holds.client where client in
(select id from employee) and premium is not null;
begin 
--displaying data before update.
dbms_output.put_line('Displaying the data before update:');
dbms_output.put_line('---------------');
FOR cd in d LOOP
        dbms_output.put_line('NAME'||':'||cd.name);
        dbms_output.put_line('Policy'||':'||cd.policy);
        dbms_output.put_line('Premium'||':'||TO_CHAR(cd.premium,'$9999990.00'));
        dbms_output.put_line('---------------');
END LOOP;

--update query
        update policy set premium=premium-(premium*10)/100 where id in
        (select distinct h.policy from holds h,policy p,covers c, employee e where h.policy=c.policy and p.id=h.policy and e.id=h.client and p.status='OK');
dbms_output.put_line('Displaying data after update:');

--displaying data after update.
dbms_output.put_line('---------------');
FOR j in(select givenname|| ' '||familyname as name,policy,premium from holds inner join policy on holds.policy=policy.id inner join party on party.id=holds.client where client in(select id from employee) and premium is not null) LOOP
        dbms_output.put_line('NAME'||':'||j.name);
        dbms_output.put_line('Policy'||':'||j.policy);
        dbms_output.put_line('Premium'||':'||TO_CHAR(j.premium,'$9999990.00'));
        dbms_output.put_line('---------------');
END LOOP;
end;
/


CREATE OR REPLACE PROCEDURE claims(policyID integer)
IS
totalclaims number:=0;  -- total count of claims
lodgeby varchar(40);  -- name of the person who lodge the claim
actor varchar(40);    --name of the person the money paid to
handler varchar(40);  --name of the person the money paid by
opener varchar(40);   --name of the person who opened the claim
closer varchar(40);  -- name of the person who closed the claim
cpol integer:=0;    -- count of the policies.
logclose  claimaction.happened%TYPE;  -- date of the claim happened.
openamt claimaction.amount%TYPE;   --total amount of the claim
i number:=1;
--cursor cid1 to fetch all the claims for the given policy.
CURSOR cid1 is select * from claim where policy=policyID order BY id desc;
BEGIN
--count to check whether the policy is present in database or not.
select count(id) into cpol from policy where id=policyID;
if(cpol = 0) then
dbms_output.put_line('There is no policy: '||policyID);
ELSE
--fetching total count of claims.
select count(id) into totalclaims from claim where policy=policyID;
dbms_output.put_line('Policy'||' '|| policyID||' '|| 'has'||' '|| totalclaims ||' '|| 'claims.');
dbms_output.put_line('---------------');
if(totalclaims > 0) then
        --looping the cursor
        FOR c in cid1 LOOP
                dbms_output.put_line(i||'.'||' '||'Claim'|| ' '||c.id);

                --fetching the name of the person who lodges the claim.
                select givenname|| ' '|| familyname as name into lodgeby from party where id=c.claimant;
                --fetching the total amount of the claim.
                select ca.amount into openamt from claimaction ca where ca.claim=c.ID and ca.action='OP';

                dbms_output.put_line('Lodged by :'||' '|| lodgeby||' '||'on'||' '||c.lodgedate);
                dbms_output.put_line('Event Date :'|| ' '||c.eventdate);
                dbms_output.put_line('Reserve at:     '||TO_CHAR(c.reserve,'$9999990.00'));

                if(c.status='A') then
                        dbms_output.put_line('Status    : open');
                else
                        --fetch the name of the person who closed the claim.
                        select givenname|| ' '|| familyname as name into closer from party where id in
                        (select handler from claimaction ca where ca.claim=c.id and ca.action='CL');
                        dbms_output.put_line('Status    : closed');
                END IF;

                dbms_output.put_line('Activity  :');
                
                --query to fetch the name of the person who opens the claim.
                select givenname|| ' '|| familyname as name into opener from party where id in
                (select handler from claimaction ca where ca.claim=c.id and ca.action='OP');
                dbms_output.put_line('...Claim opened by '|| opener || ' '||'on'||' '|| c.lodgedate||'with reserve set to     '||' '||TO_CHAR(openamt,'$9999990.00')||'.');
                
                --looping the rows for the claims that are paid out.
                FOR k in (select * from claimaction ca where ca.claim=c.id and ca.action='PO') LOOP
                        select givenname|| ' '|| familyname as name into actor from party where id=k.actor;
                        select givenname|| ' '|| familyname as name into handler from party where id=k.handler;
                        dbms_output.put_line('...    '||TO_CHAR(k.amount,'$9999990.00')||' '||'paid out to '|| actor||' '||'by '||handler||' on '||k.happened||'.');
                END LOOP;
                
                --check if claim closed or not.
                if(c.status='Z') then
                        --fetching the claim happened date.
                        select ca.happened into logclose from claimaction ca where ca.action='CL' and ca.claim=c.id;
                        dbms_output.put_line('...Claim closed by '|| closer || ' '||'on'||' '|| logclose||'.');
                END IF;
                i:=i+1;
                dbms_output.put_line('---------------');
        END LOOP;
END IF;
END IF;
END;
/


create or replace procedure policy_rework_list
is
i integer:=1;
rcheck integer:=0; --count of ratingaction policy declined.
ucheck integer:=0; --count of underwritingaction policy declined.
totalrework integer:=0; --count of policies that need to re-worked.
rerated integer:=0;  
reunderwrited integer:=0; 

--cursor rdt to fetch the policies in ratingaction that are declined by rater.
CURSOR rdt is select distinct cv.policy from covers cv,ratingaction ra where 
cv.coverage=ra.coverage and ra.action='D';
--cursor ct to fetch the policies in underwrintingaction that are declined by underwriter.
CURSOR ct is select distinct uw.policy from underwritingaction uw where uw.action='D';

BEGIN
--query to get the total number of rows that are declined by the rater or underwriter.
select count(distinct cv.policy) into totalrework from covers cv,ratingaction ra,underwritingaction uw where 
cv.coverage=ra.coverage and ra.action='D' or uw.action='D';
--query to get the total number of rows thata are declined by the underwriter.
select count(distinct uw.policy) into ucheck from underwritingaction uw where uw.action='D';
dbms_output.put_line('Total number of policies that need to be re-worked are : '||totalrework);
if(totalrework>0) then
        dbms_output.put_line('Following Policies are to be re-worked:');
        --loop to print the policies list declined by the rater.

        FOR d in rdt LOOP
                dbms_output.put_line(i||'. '||d.policy);
                i:=i+1;
                --query to count the ratingaction policies that are re-rated.
                select count(ra.coverage) into rcheck from ratingaction ra where ra.action='A' and ra.coverage in 
                (select coverage from covers cv where cv.policy=d.policy);
                if(rcheck>0) then
                        rerated:=rerated+1;
                end if;       
        END LOOP;

        --loop to print the policies list declined by the underwriter.
        FOR k in ct LOOP
                dbms_output.put_line(i||'. '||k.policy);
                i:=i+1;
                 --query to count the underwriting policies that are re-underwrited.
                select count(policy) into ucheck from underwritingaction uw where uw.action='A' and uw.policy=k.policy;
                if(ucheck>0) then
                        reunderwrited:=reunderwrited+1;
                end if;
        END LOOP;
        dbms_output.put_line('Total policies that are  re-rated : '||rerated);
        dbms_output.put_line('Total policies that are re-underwrited : '||reunderwrited);
END IF;  
end;
/



