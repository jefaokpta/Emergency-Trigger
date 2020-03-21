delimiter //
-- PRODUCAO Ast 1.8
CREATE TRIGGER `ajustTransfer` AFTER INSERT ON `cdr`
 FOR EACH ROW BEGIN
BEGIN     
if new.channel != 'Console/dsp' then
  if substr(new.dcontext,1,6) = 'TRANSF' and new.accountcode >= 2 and new.billsec > 0 then
    update relcalls set duration=(duration+new.duration),billsec=(billsec+new.billsec),
            price=(select tarifadorVip((billsec+new.billsec),accountcode,substr(new.dcontext,8)))
              where calldate BETWEEN concat(substr(now(),1,10),' 00:00:00') and now()
                and company_id = substr(new.dcontext,8) and channel=new.channel;
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
-- PRODUCAO
--   SECONCI BKP
BEGIN     declare _numcalls int;
    if new.channel != 'Console/dsp' then
      if new.lastapp = 'Transferred Call' then
        if new.dcontext = 'dialPeer' then           update relcalls set duration=new.duration,billsec=new.billsec,accountcode=new.accountcode,
            price=(select tarifadorVip(new.billsec,new.accountcode,new.company_id)) 
              where calldate like concat(substr(new.calldate,1,10),'%') 
                and channel=new.dstchannel;
        elseif new.dcontext = 'dialRoute' then           update relcalls set duration=new.duration,billsec=new.billsec,
            price=(select tarifadorVip(new.billsec,accountcode,company_id)) 
              where calldate like concat(substr(new.calldate,1,10),'%') 
                and channel=new.channel;
        elseif substr(new.dcontext,1,3) = 'VIP' then           update relcalls set duration=new.duration,billsec=new.billsec,
            price=(select tarifadorVip(new.billsec,accountcode,company_id)) 
              where calldate like concat(substr(new.calldate,1,10),'%') 
                and channel=new.channel;
        end if;
      else
          insert into relcalls (calldate,src,srcfinal,dstfinal,disposition,
            duration,billsec,accountcode,uniqueid,channel,price,userfield,cidade,estado,company_id,trunk_id)
              values(new.calldate,new.src,new.srcfinal,new.dstfinal,new.disposition,
                new.duration,new.billsec,new.accountcode,new.uniqueid,new.dstchannel,
                  (select tarifadorVip(new.billsec,new.accountcode,new.company_id)),new.userfield,(select cidade(new.dstfinal)),(select estado(new.dstfinal)),new.company_id,new.trunk_id);
      end if;
    end if;
 END
--   SECONCI


                