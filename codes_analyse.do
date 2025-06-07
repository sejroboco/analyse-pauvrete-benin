
*********************************
*OUVERTURE DE LA BASE DE DONNEES*
*********************************

/*LA BASE DE DONNEES EST CELLE DE L'ENQUETE HARMONISEE SUR LES CONDITIONS DE VIE DES MENAGES (EHCVM) AU BENIN REALISEE EN 2018*/

use "D:\DataScientistAccompli\projets\analyse-pauvrete-benin\BASES_PAUVRETE\BASES_EHCVM_BENIN\ehcvm_welfare_ben2018.dta" /*METTRE LE CHEMIN D'ACCES APPROPRIE



************************
*PONDERATION DE LA BASE*
************************

/*LA PONDERATION EST NECESSAIRE POUR PRENDRE EN COMPTE LES POIDS INDUITS PAR LE CHOIX DES GRAPPES ET DES UNITES D'OBSERVATION*/

gen weighti = hhweight*hhsize



*****************************************************************************************
*GENERATION DE LA VARIABLE DE CALCUL DES DIVERS INDICATEURS DE LA PAUVRETE NOTEE ICI POV*
*****************************************************************************************

/*UN MENAGE EST PAUVRE SI LA VALEUR DE SA CONSOMMATION EST INFERIEURE AU NIVEAU MINIMUM REQUIS ICI NOTE ZREF*/

gen pov = pcexp < zref



******************************************
*APPARIEMENT DES BASES MENAGE ET INDIVIDU*
******************************************

/*METTRE LE CHEMIN D'ACCES APPROPRIE*/

merge m:1 hhid using "D:\DataScientistAccompli\projets\analyse-pauvrete-benin\BASES_PAUVRETE\BASES_EHCVM_BENIN\ehcvm_welfare_ben2018.dta"    

gen nv_pw=hhweight*hhsize

svyset [pweight= nv_pw]



******************************************************************************************************
*GENERATION DES VARIABLES DE CALCUL DE LA PROFONDEUR, DE LA SEVERITE ET DE L'INTENSITE DE LA PAUVRETE*
******************************************************************************************************

gen v_profond=((1-pcexp/zref)^1)*pov

gen v_severe=((1-pcexp/zref)^2)*pov

sum pcexp if pcexp < zref, detail
gen mediane=186413.1  
gen v_intensite=((zref-mediane)*pov)/zref



*********************************************************************
*GENERATION DES VARIABLES DE CALCUL DES GAPS POUR TOUT L'ECHANTILLON*
*********************************************************************

gen gap=((1-pcexp/zref)^1)



******************************************************************************
*GENERATION DES VARIABLES DE CALCUL DES GAPS AU CARRE POUR TOUT L'ECHANTILLON*
******************************************************************************

gen gap_squared=((1-pcexp/zref)^2)



**************************************************************************************************************
*CALCUL DES TAUX DE PAUVRETE, PROFONDEUR ET SEVERITE AU NIVEAU GLOBAL, PAR MILIEU, PAR REGION ET PAR RELIGION*
**************************************************************************************************************

*Grandeurs au niveau global*

svy: mean pov
svy: mean v_profond
svy: mean v_severe

*Taux de pauvreté par milieu, région et réligion*

svy: mean pov, over(milieu)
svy: mean pov, over(region)
svy: mean pov, over(hreligion)

*Profondeur de la pauvreté par milieu, région et réligion*

svy: mean v_profond, over(milieu)
svy: mean v_profond, over(region)
svy: mean v_profond, over(hreligion)

*Sévérité de la pauvreté par milieu, région et réligion*

svy: mean v_severe, over(milieu)
svy: mean v_severe, over(region)
svy: mean v_severe, over(hreligion)



********************************************************************
*CONSTRUCTION DE LA COURBE DE LORENTZ ET CALCUL DE L'INDICE DE GINI*
********************************************************************

qui lorenz estimate pcexp, gini 
lorenz graph



*******************************************************************************
*CONSTRUCTION DE LA COURBE DE LORENTZ ET CALCUL DE L'INDICE DE GINI PAR REGION*
*******************************************************************************

qui lorenz estimate pcexp, gini over(region)
lorenz graph, over



*********************************************************************************
*CONSTRUCTION DE LA COURBE DE LORENTZ ET CALCUL DE L'INDICE DE GINI PAR RELIGION*
*********************************************************************************

*Par religion*

qui lorenz estimate pcexp, gini over(hreligion)
lorenz graph, over

*Par genre*

qui lorenz estimate pcexp, gini over(hgender)
lorenz graph, over

*Par mimieu*

qui lorenz estimate pcexp, gini over(milieu)
lorenz graph, over

*Par statut de pauvreté*

qui lorenz estimate pcexp, gini over(pov)
lorenz graph, over



*******************************************************
*calcul DES DECILES, QUARTILES ET MEDIANE DE BIEN ETRE*
*******************************************************

/*CETTE SYNTAXE PERMET DE CALCULER LES DECILES DE BIEN-ETRE*/

pctile decile_welf=pcexp, nq(10)
pctile quartile_welf=pcexp, nq(4)
pctile median_welf=pcexp, nq(2)



*****************************************************
*TABLEAU DE PRESENTATION DES PERCENTILES AVEC DETAIL*
*****************************************************

sum pcexp, detail



********************************************
*ESTIMATION DES DETERMINANTS DE LA PAUVRETE*
********************************************

/*modèle probit avec pour explicatives 'taille du menage', 'genre du chef du menage', 'consommation annuelle alimentaire du ménage', 'consommation annuelle non alimentaire du ménage*/

probit pov hhsize i.hgender dali dnal

/*modele logit avec pour explicatives 'taille du menage', 'genre du chef du menage', 'consommation annuelle alimentaire du ménage', 'consommation annuelle non alimentaire du ménage*/

logit pov hhsize hgender dali dnal

/*modele logit avec des explicatives à plus de deux modalités telles que hreligion, halfab, heduc, hcsp*/

logit pov hhsize i.hgender i.hreligion i.halfab i.heduc hage i.hcsp dali dnal



*********************************
*ESTIMATION DES EFFETS MARGINAUX*
*********************************

/*IL FAUT S'ASSURER QUE TOUTES LES VARIABLES EXPLICATIVES SONT QUANTITATIVES*/

probit pov hhsize hage dali dnal
mfx

logit pov hhsize hage dali dnal
mfx



****************************
*ESTIMATION DES ELASTICITES*
****************************

/*IL FAUT S'ASSURER QUE TOUTES LES VARIABLES EXPLICATIVES SONT QUANTITATIVES*/
/*ON FAIT L'ESTIMATION A LA MOYENNE*/

margins, eyex(hhsize hage dali dnal) atmeans



****************************
*ESTIMATION DES ODDS RATIOS*
***************************

/*L'OPTION OR A LA FIN DE LA SYNTAXE DU MODELE PERMET D'OBTENIR LES ODDS RATIOS*/
/*ATTENTION A NE INTERPRETER QUE LES ODDS RATIO POUR LES VARIABLES QUALITATIVES*/

logit pov hhsize i.hgender i.hreligion i.halfab i.heduc hage i.hcsp dali dnal, or



*********************
*TABLE DE PREDICTION*
********************

logit pov hhsize i.hgender i.hreligion i.halfab i.heduc hage i.hcsp dali dnal, or
lstat



*************************
*QUALITE DE L'AJUSTEMENT*
*************************

logit pov hhsize hgender i.hreligion i.halfab i.heduc hage i.hcsp dali dnal, or
estat gof
lroc