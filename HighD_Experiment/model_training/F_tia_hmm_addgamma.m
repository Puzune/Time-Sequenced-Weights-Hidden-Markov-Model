function tia = F_tia_hmm_addgamma(lambda,acctable,gamma,data,i)

ns = table2array(acctable(i,["n1","n2","n3"]));
tw = table2array(acctable(i,"Tw"));
templambda = squeeze(lambda(tw,:,:));
tia = tia_hmm(templambda,ns,tw,gamma,data);