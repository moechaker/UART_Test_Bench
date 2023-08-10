class driver;
  virtual uart_if vif;
  transaction trans;
  
  mailbox #(transaction) mbxgd;
  mailbox #(bit [7:0]) mbxds;
  
  event drvnext;
 
  
  bit wr=0;
  bit [7:0] datarx;
  
  function new(mailbox #(transaction) mbxgd, mailbox #(bit [7:0]) mbxds);
    this.mbxgd = mbxgd;
    this.mbxds = mbxds;
  endfunction
  
  task reset();
    vif.rst <= 1'b1;
    vif.rx <= 1'b1;
    vif.dintx <= 0;
    vif.send <= 0;
    vif.tx <= 1'b1;
    vif.doutrx <= 0;
    vif.donetx <= 0;
    vif.donerx <= 0;
    repeat(5) @(posedge vif.uclktx);
    vif.rst <= 1'b0;
    @(posedge vif.uclktx);
    $display("[DRV] : RESET DONE");
  endtask
  
  
  task run();
    forever begin
      mbxgd.get(trans);
      if(trans.oper == 2'b00) begin
        @(posedge vif.uclktx);
        	vif.rst <= 0;
        	vif.send <= 1;
        	vif.tx <= 0;
        	vif.dintx <= trans.dintx;
        @(posedge vif.uclktx);
        vif.send <= 0;
        mbxds.put(trans.dintx);
        $display("[DRV]: Data Sent : %0d", trans.dintx);
        wait(vif.donetx == 1'b1);  
        ->drvnext;  
      end
      else if(trans.oper == 2'b01) begin
        @(posedge vif.uclkrx);
        vif.rst <= 0;
       	vif.send <= 0;
        vif.rx <= 0;
        @(posedge vif.uclkrx);
         for(int i=0; i<=7; i++) 
                 begin   
                      @(posedge vif.uclkrx);                
                      vif.rx <= $urandom;
                      datarx[i] = vif.rx;                                      
                 end 
        
        mbxds.put(datarx);
                
        $display("[DRV]: Data RCVD : %0d", datarx); 
		wait(vif.donerx == 1'b1);
		vif.rx <= 1'b1;
		->drvnext;
        
      end
      
      
      
    end
    
    
    
  endtask
  
  
endclass