class monitor;
  transaction trans;
  mailbox #(bit [7:0]) mbxms;
  
  virtual uart_if vif;
  
  bit [7:0] srx; //////send
  bit [7:0] rrx; ///// recv
  
  function new(mailbox #(bit [7:0]) mbxms);
    this.mbxms = mbxms;
  endfunction
  
  task run;
    forever begin
      @(posedge vif.uclktx);
      if(vif.send == 1 && vif.tx == 0) begin
        @(posedge vif.uclktx);
        
        for(int i=0;i<=7;i++)begin
          @(posedge vif.uclktx);
          srx[i] = vif.tx;
        end
        
        $display("[MON] : DATA SEND on UART TX %0d", srx);
        
        @(posedge vif.uclktx);
        mbxms.put(srx);
      end
        
        else if(vif.send == 0 && vif.rx == 0) begin
          wait(vif.donerx == 1);
          rrx = vif.doutrx;     
          $display("[MON] : DATA RCVD RX %0d", rrx);
          @(posedge vif.uclktx); 
          mbxms.put(rrx);
          
        end
        
     end
    
  endtask
  
  
  
endclass