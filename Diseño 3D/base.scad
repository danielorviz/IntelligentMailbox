    anchoBuzon=196;
    fondoBuzon=180;
    altoBuzon =196;
    anchoPared=5;
    anchoPuerta=140;
    altoPuerta=180;
    margen=20;
    margenAlto=55;
    
// TAPA BUZON


//LECTOR
    anchoLector =45;
    altoLector = 90;
    grosorLector = 5;
// AGUJERO ALIMENTACION
diametroAlimentacion = 14;
module base(){

    difference(){
        cube([anchoBuzon,fondoBuzon,altoBuzon]);
        translate([anchoPared,anchoPared,anchoPared])
            cube([anchoBuzon-anchoPared*2,fondoBuzon-anchoPared*2,altoBuzon]);
        translate([anchoBuzon-(anchoBuzon-margen),0,altoBuzon-(altoBuzon-margenAlto)])
            #cube([anchoPuerta,50,altoPuerta]);
            
    }
        
        difference(){
            translate([anchoPared,anchoPared,0])
                cube([anchoBuzon-anchoPared*2,fondoBuzon-anchoPared*2,margenAlto]);
            translate([anchoPared*2,anchoPared*2,0])
                cube([anchoBuzon-anchoPared*4,fondoBuzon-anchoPared*4,margenAlto]);
        }

        
        
    
    translate([anchoBuzon-40,anchoPared,altoBuzon-80])
        cerradura();
    translate([anchoBuzon/4,anchoPared+1,margenAlto])
        cube([100,anchoPared-1,anchoPared-1]);    
}
module baseConLectorYCerradura(){
    difference(){
        base();
        translate([(anchoBuzon/2)-2,anchoPared,anchoLector+anchoPared])
                lector();
    }
}


//cerradura();
module lector(){

    
    rotate([0,90,0])
        union(){
            translate([0,-3.5,34])
                cube([4,5,10]);
            cube([anchoLector,grosorLector,altoLector]);
        }
}

altoCerradura = 70;
module cerradura(){
    difference(){

        difference(){
            
            cube([20,25,altoCerradura]);
                translate([0,0,altoCerradura])
                    rotate([0,90,0])
                        cube([20,20,40]);

        }
            rotate([45,0,0])
                translate([0,0,-20])
                    cube([200,250,20]);
    }
}
module baseCompleta(){
    difference(){
        baseConLectorYCerradura();
        rotate([0,90,90])
            translate([-20,-anchoBuzon/2,fondoBuzon/2])
                #cylinder(r = diametroAlimentacion/2, h = 100, $fn=200);
    }
}
//************************ TAPA *******************************************

baseCompleta();
translate([0,0,altoBuzon])
tapa();


altoTapa = 140;
anchoRanura = 140;
fondoRanura = 30;
desplazamientoRanura = 60;
module tapa(){
    difference(){
        cube([anchoBuzon,fondoBuzon,altoTapa]);
        translate([anchoPared,anchoPared,0])
            cube([anchoBuzon-anchoPared*2,fondoBuzon-anchoPared*2,altoTapa-anchoPared]);
        translate([anchoBuzon/8,desplazamientoRanura,altoTapa-anchoPared])
            cube([anchoRanura,fondoRanura,100]);
        translate([anchoBuzon-(anchoBuzon-margen),0,0])
            cube([anchoPuerta,anchoPared*2,(margenAlto+altoPuerta)-altoBuzon]);
    }
}



module encaje(anchoEncaje,fondoEncaje,altoEncaje){
    difference(){
        cube([anchoEncaje,fondoEncaje,altoEncaje]);
            translate([0,10,-12])
        rotate([40,0,0])
            cube([anchoEncaje,4,altoEncaje*2]);
    }
}
 module tapaConEncajes(){
    fondoEncaje = 3;
    anchoEncaje = 40;
    // mirado dessde detras de la puerta
    // primer encaje justo encima de la puerta
    rotate([0,180,180])
        translate([anchoBuzon/2-20,-anchoPared-fondoEncaje,-margenAlto+5])
            encaje(40,fondoEncaje,15);

    // encaje alante a la derecha
    rotate([0,180,180])
        translate([anchoBuzon-anchoPared-fondoEncaje,-anchoPared,-20])
            rotate([0,0,-90])
                    encaje(40,fondoEncaje,30);
    // encaje atras a la derecha
    rotate([0,180,180])
        translate([anchoBuzon-anchoPared-fondoEncaje,-fondoBuzon+anchoEncaje+anchoPared,-20])
            rotate([0,0,-90])
                    encaje(40,fondoEncaje,30);

    // encaje alante a la izquierda
    rotate([0,180,180])
        translate([fondoEncaje+anchoPared,-anchoPared-anchoEncaje,-20])
            rotate([0,0,90])
                    encaje(anchoEncaje,fondoEncaje,30);
                    
    // encaje atras a la izquierda                
    rotate([0,180,180])
        translate([fondoEncaje+anchoPared,-fondoBuzon+anchoPared,-20])
            rotate([0,0,90])
                    encaje(anchoEncaje,fondoEncaje,30);

    // encaje de atras central
    anchoEncaje2=50;
    rotate([0,180,180])
        translate([anchoBuzon/2+30,-fondoBuzon+anchoPared+fondoEncaje,-20])
                rotate([0,0,180])
                    encaje(anchoEncaje2,fondoEncaje,30);
    tapa();

}
// ****************** PUERTA ************************
tecladoDistIzq = 45;
tecladoAltura = 35;
module puerta(){
    difference(){
        cube([anchoPuerta-2,altoPuerta-2,anchoPared-1]);

        translate([tecladoDistIzq,tecladoAltura,-10])
        rotate([-15,0,0])
        cube([24,4,20]);

        translate([anchoPuerta-cerraduraDistanciaDerecha-4.5,cerraduraAltura+20,-10])
        cube([10,3.5,20]);



        cerraduraDistanciaDerecha = 30;
        cerraduraAltura = 120.5;

        translate([anchoPuerta-cerraduraDistanciaDerecha,cerraduraAltura,-10])
        cylinder(h = 50,r=13/2, $fn=200);
    }
}

// ******************** CERROJO *************
module cerrojo(){
    largoCerrojo = 50;
    anchoCerrojo = 25;
    altoCerrojo = 5;

    diametroCerrojo = 20;
    difference(){
        difference(){
            union(){
                cube([largoCerrojo,anchoCerrojo,altoCerrojo]);
                translate([largoCerrojo-10,0,3])
                cube([10,anchoCerrojo,altoCerrojo+4]);

                translate([diametroCerrojo/2,diametroCerrojo/2+2,0])
                    cylinder(r = diametroCerrojo/2,$fn=200, h = 8);


            }
        translate([diametroCerrojo/2,diametroCerrojo/2+2,0])
            #cylinder(r = 5/2,$fn=200, h = 20);
        }

        translate([22,0,0])
        cube([30,17,30]);
    }
}

anchoTapaBase = anchoBuzon-(anchoPared*2)-2;
fondoTapaBase = fondoBuzon-(anchoPared*2)-5;
module tapaMicrocontroladores(){
    difference(){
        cube([anchoTapaBase,fondoTapaBase,2]);
            translate([42,0,-1])
                cube([110,anchoPared+1,20]);
            
            translate([10,15,-1])
            #cube([10,5,50]);
            
            translate([15,30,-1])
            #cube([30,8,50]);
            
             translate([15,30,-1])
            #cube([30,8,50]);
            
            translate([60,40,-1])
            cylinder(h=200,r=17/2,$fn=200);
            
             translate([anchoTapaBase-20,20,-1])
            #cube([10,8,50]);
            
            translate([fondoTapaBase-50,anchoTapaBase-70,-1])
            #cylinder(h=200,r=17/2,$fn=200);
       }
}
