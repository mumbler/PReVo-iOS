# PoshReVo
Posha Reta Vortaro

Konstruado de la datumbazo:
- elshutu la tutan retpaghan font-kodaron de La Reta Vortaro (http://reta-vortaro.de/tgz/index.html - tion nomata "fontdosieroj")
- Rulu 'prep.rb', kun la loko de la elshutita revo doseriujo kiel parametro
  -tio kreos dosierujon "preparita"
- Movu la "preparita" dosierujon en la "Datumoj" dosierujo de la XCode projekto.
- En AppDelegate.swift, shanghi la kreiDatumbazon valoron al "true".
  - Tiustate, rulado de la iOS-programo komence konstruos Core Data datumbazon kiu enhavos la vortarajn datumojn.
- Post tio, refiksi la valoron de kreiDatumbazon kiel "false".
- Trovu la "PReVoDatumoj.sqlite" dosiero kiu kreis la programon, kaj movu ghin en la "DatumoJ" dosierujon.
- Vi povas forigi la "preparita" dosierujon
- Aldonu la "PReVoDatumoj.sqlite" dosiero al la "Copy Bundle Resources" listo sub la projektaj agordoj
- Kun "PReVoDatumoj.sqlite" en "Datumoj", kaj aldonita la bundle, la programo funkcios normale.
