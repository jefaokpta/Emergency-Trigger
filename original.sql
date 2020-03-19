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
            duration,billsec,accountcode,uniqueid,channel,price,userfield,company_id)
              values(new.calldate,new.src,new.srcfinal,new.dstfinal,new.disposition,
                new.duration,new.billsec,new.accountcode,new.uniqueid,new.dstchannel,
                  (select tarifadorVip(new.billsec,new.accountcode,new.company_id)),new.userfield,new.company_id);
      end if;
    end if;
 END