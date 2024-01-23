<?php

    $query_db = array(
        "0"  => 'CALL sp_login("x00","x01");',
        "1"  => 'CALL sp_setUser("x00","x01","x02","x03");',
        "2"  => 'CALL sp_do("x00",x01,x02,"x03");',
        "3"  => 'CALL sp_view_do("x00",x01,x02);',        
        "4"  => 'CALL sp_addBebe("x00",x01,"x02","x03",x04);',
        "5"  => 'CALL sp_viewBebe("x00")',
        "6"  => 'CALL sp_view_dia("x00",x01,x02,"x03");',
        
    );

 
?>