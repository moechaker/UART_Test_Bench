class transaction;
  bit rx;
  rand bit [7:0] dintx;
  bit send;
  bit tx;
  bit [7:0] doutrx;
  bit donetx;
  bit donerx;
  
  typedef enum bit [1:0] {write = 2'b00, read = 2'b01} oper_type;
  randc oper_type oper;
  
  
  function void display (input string tag);
    $display("[%0s] : oper : %0s send : %0b TX_DATA : %b RX_IN : %0b TX_OUT : %0b RX_OUT : %b DONE_TX : %0b DONE_RX : %0b", tag, oper.name(), send, dintx, rx, tx, doutrx, donetx, donerx); 
  endfunction
  
  
  function transaction copy(); 
    copy = new();
    copy.rx = this.rx;
    copy.dintx = this.dintx;
    copy.send = this.send;
    copy.tx = this.tx;
    copy.doutrx = this.doutrx;
    copy.donetx = this.donetx;
    copy.donerx = this.donerx;
    copy.oper = this.oper;
  endfunction
  
endclass