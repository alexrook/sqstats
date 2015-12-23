

function formatNumbers(){
    
    numeral.language('ru');
    
    $(".bytes").text(function(index,text) {
          return numeral(text).format('0.0 b');
    });
    
    $(".duration, .conn_count").text(function(index,text) {
          return numeral(text).format('0,0');
    });
    
}

function punycodeIt(args) {
   
    $("a.out-link").each(function(index,element) {
        
          var txt=$(this).text();
          txt=punycode.toUnicode(txt);
          $(this).text(txt);
          $(this).attr('title','перейти к '+txt);
          
    });
    
}


$(function() {
    
    formatNumbers();
    punycodeIt();
    
});