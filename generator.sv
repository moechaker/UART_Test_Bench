class generator;
  
	transaction trans;
  	mailbox #(transaction) mbxgd;
  	
  	event done;
  	event drvnext;
  	event sconext;
  	int count;
  
  
  function new(mailbox #(transaction) mbxgd);
    this.mbxgd = mbxgd;
    trans = new();
  endfunction
  
  
  task run();
    repeat(count) begin
      assert(trans.randomize()) else $error("Randomization Failed");
      mbxgd.put(trans.copy);
      trans.display("GEN");
      @(drvnext);
      @(sconext);
    end
     
    -> done;
    
    
  endtask
  
endclass