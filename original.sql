delimiter //
BEGIN     
if new.channel != 'Console/dsp' then
  if substr(new.dcontext,1,6) = 'TRANSF' and new.accountcode >= 2 and new.billsec > 0 then
    update relcalls set duration=new.duration,billsec=new.billsec,accountcode=new.accountcode,
      price=(select tarifadorVip(new.billsec,new.accountcode,new.company_id)) 
        where calldate BETWEEN concat(substr(now(),1,10),' 00:00:00') and now()
          and channel=new.channel;
  else
    insert into relcalls (calldate,src,srcfinal,dstfinal,disposition,
      duration,billsec,accountcode,uniqueid,channel,price,userfield,company_id)
        values(new.calldate,new.src,new.srcfinal,new.dstfinal,new.disposition,
          new.duration,new.billsec,new.accountcode,new.uniqueid,new.dstchannel,
            (select tarifadorVip(new.billsec,new.accountcode,new.company_id)),new.userfield,new.company_id);
  end if;
end if;
END
delimiter ;

 update relcalls set duration=(duration+1),billsec=(billsec+1),
            price=(select tarifadorVip((billsec+1),accountcode,100))
              where calldate BETWEEN '2020-03-18 00:00:00' and now()
                and company_id = 100 and channel=''

                IAX2/Marte-13075