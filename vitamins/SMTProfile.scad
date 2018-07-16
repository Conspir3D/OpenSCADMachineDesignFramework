/*
    Vitamin: SMT Aluminium Profil

    Local Frame:
*/


// Connectors

SMTProfile_Con_Def				= [ [0,0,0], [0,0,-1], 0, 0, 0];

//Type Table: size, radius edge, centerhole,  nutsize
Profil6  =    [30,3,5,6,"PROFIL6"];
// Type Collection
Profile_Types = [
    Profil6
];

// Vitamin Catalogues
module SMTProfiles_Catalogue() {
    for (t = Profile_Types) Profile(t);
}

// default connector for screws
profileCon = [[0,0,0],[0,0,-1],0];
profile_Con_Default = profileCon;

// colors
profile_color = "silver";

module SMTProfile(type=Profil6, length=100) {

    vitamin("vitamins/SMTProfile.scad", "SMT Aluminium Profil", "SMTProfile()") {
        view(t=[6.9, 13.6, 10.3], r=[72,0,33], d=280);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(SMTProfile_Con_Def);
        }

        // parts
        SMTProfile_Body();
    }
}

module SMTProfile_Body(type=Profil6, length=100) {


    part("SMTProfile_Body", "SMTProfile_Body()");

    color(profile_color, 1) {
        if (UseVitaminSTL) {
            import(str(VitaminSTL,"SMTProfile_Body.stl"));
        }
        else
        {
            // body


            //difference () {
                union() {
                minkowski(){
                  cube([type[0]-2*type[1],type[0]-2*type[1],1]);
                  cylinder(r=type[1],h=length);
                }

                    hull () {
                            cylinder(h=length, r=type[1], center=false);

                            translate([type[0]-(type[1]*2),0,0])
                                cylinder(h=length, r=type[1], center=false);
                            translate([0,type[0]-(type[1]*2),0])
                                cylinder(h=length, r=type[1], center=false);
                            translate([type[0]-(type[1]*2),type[0]-(type[1]*2),0])
                                cylinder(h=length, r=type[1], center=false);

                    }
                }
                // center hole
                cylinder(h=length, r=type[2]/2, center=false);
            //}
        }
    }

    if($children)
        for(i=[0:$children-1])
            attach(DefConDown, DefConUp, ExplodeSpacing=ExplodeSpacing * (i+1))
            children(i);
}
