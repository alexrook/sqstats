

function formatNumbers(){
    
    numeral.language('ru');
    
    $( ".bytes" ).text(function( index,text ) {
          return numeral(text).format('0.0 b');
    });
    
    $( ".duration, .conn_count" ).text(function( index,text ) {
          return numeral(text).format('0,0');
    }); 
}


$(function() {
    formatNumbers();  
});