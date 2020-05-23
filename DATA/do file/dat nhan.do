 foreach var1 of varlist  cmttm cmstm nghmutm  rlkg nhdautm dytaiptm dytaittm dytaipttm dichkhgptmns dichkhgttmns dichkhgpttmns phnekhgptmns phnekhgttmns phnekhgpttmns vegavn cgkhcong dichlvnptmns dichlvnttmns dichlvnpttmns {
  label value `var1' cokhong
  }
label define tacthong 1 "thong" 0 "tac" 
 foreach var1 of varlist  toynbeeptm valsalvaptm toynbeettm valsalvattm {
   label value `var1' tacthong
  }

 foreach var1 of varlist  toynbeepsm1 valsalvapsm1 toynbeetsm1 valsalvatsm1
  label value `var1' tacthong
  }


 foreach var1 of varlist  toynbeepsm3 valsalvapsm3 toynbeetsm3 valsalvatsm3
  label value `var1' tacthong
  }

 foreach var1 of varlist     dytaipsm1 dytaitsm1 dytaipsm2 dytaitsm2 dytaipsm3 dytaitsm3 dytaipsm dytaitsm {
 label value `var1' cokhong
  }

 
 