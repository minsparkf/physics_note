printf("freq.,Plank,Wien,Rayliegh=Jeans\n");
for($i=10**8; $i<(10**16/2); $i+=10**14){
    printf("$i,");


    $T=20000;
    $Ap = (8*3.1415*6.63*(10**(-10))*($i**3))/27;
    $Bp = exp((6.63*(10**(-11))*$i)/(1.38 * $T));
    $Cp = $Ap/($Bp - 1);
    printf("$Cp,");

    $Xa = 50*3.1415*6.63*(10**(-11))/20;
    $Xb = 6.43*(10**(-11));
    $Xc = 1.3601;
    $Aw = $Xa*($i**3)*exp((-1*$Xb*$i)/($Xc*$T));
    printf("$Aw,");

    $Arj = (8*3.14*($i**2))/27;
    $Brj = 13.8*$T;
    $Crj = $Arj*$Brj;
    if($Crj < (7*10**(34))){
        printf("$Crj,");
    }


    printf("\n");
}

