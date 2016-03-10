require 'cgi'
require 'json'
require 'nokogiri'

# Supraj valoroj ===================================

@literoj = {}
@esperantaj = []

# Funkcioj Gheneralaj  =============================

# Anstatauigi la HTML-kodojn, incluzivante tiujn listigitajn en "literoj.xml",
# per veraj, unicod-aj literoj

def anstatauKodo(teksto)

     trovoj = teksto.scan(/&(.*?);/)
     if trovoj == nil or trovoj.size <= 0 then return teksto end

     for i in 0..trovoj.size do
        
	trov = trovoj[i].to_s[2..-3]
        if @literoj[trov] != nil
	   teksto.sub!("&#{trov};", @literoj[trov])
	else
	   #puts "Eraro! Ne trovis [#{trov}]"
	end
     end

     teksto = CGI::unescapeHTML(teksto)
     return teksto
end

def anstatauTildo(teksto, vorto)

   teksto = teksto.gsub("<tld/>", vorto)
   teksto = teksto.gsub(/<tld>.*?<\/tld>/, vorto)
   teksto = teksto.gsub(/<tld lit=\"(.*?)\"\/>/, '\1' + "#{vorto[1..-1]}")
   teksto = teksto.gsub(/<tld lit=\"(.*?)\">.*?<\/tld>/, '\1' + "#{vorto[1..-1]}") 
   return teksto  

end

def uziTildon(teksto)

   teksto = teksto.gsub("<tld/>", "~")
   teksto = teksto.gsub(/<tld>.*?<\/tld>/, "~")
   return teksto  

end

def prepariTilde(teksto)

    return prepariTekston(uziTildo(teksto))

end

def prepariVorte(teksto, vorto)

    return prepariTekston(anstatauTildo(teksto, vorto))

end

def prepariTekston(teksto)

    teksto2 = teksto.gsub("\n", " ").gsub("\r", " ").gsub("\t", "").squeeze(" ")
    teksto2.gsub("...", "…")
    return anstatauKodo(teksto2)

end

# Por konstrui la traduk-indeksojn - intermeti en traduk-array vorton kaj ĝian
#  destino-markon
def alfameti(arr, vorto, mark)
    
    min = 0, maks = arr.size
    prov = 0

    while min != maks

       prov = ((min + maks)/2).floor
       nuna = arr[prov][0]
       if vorto < nuna
          maks = prov
       elsif vorto < nuna
       	  min = prov
       elisf vorto == nuna
          min = maks = prov
       end
    end

    arr.insert(min, [vorto, mark])
end

# Legu subtenajn dosierojn =======================
# Tiuj faros la pli simplajn datumarojn pri lingvoj, mallongigoj, ktp.
# ================================================

# === Legi la parametrojn
dir = nil

if ARGV.count > 0
   dir = ARGV[0]
end

# === Kontroli ke la dosierujo ekzistas, kaj havas ĝustan strukturon
unless File.exists?(dir) and File.exists?(dir+"/cfg") and File.exists?(dir+"/xml")
   puts "Eraro: bezonataj doserujoj ne trovitas"
end


# === Fari listojn de lingvoj kaj iliaj literoj

komentoRegesp = /\s*<!--.*-->˜\s*/

# -- lingvolisto

puts "=== Legante lingvojn ==="
lingvoDos = File.open(dir+"/cfg/lingvoj.xml", "r")
lingvoj = []
tradukoj = {}

if lingvoDos
   linio = ""
   lingvoRegesp = /\s*<lingvo kodo="([[:alpha:]]+)">(.+)<\/lingvo>\s*/
   while linio = lingvoDos.gets

      if komentoRegesp.match(linio) then next end
      rezulto = lingvoRegesp.match(linio)
      if rezulto and rezulto.size == 3
      	 lingvoj << [rezulto[1], rezulto[2]]
	 tradukoj[rezulto[1]] = []
         tradukoj[rezulto[1]] = []
      end
   end
else
   puts "Lingvo-lista dosiero ne troveblas"
end

# -- fakolisto

puts "=== Legante fakojn ==="
fakoDos = File.open(dir+"/cfg/fakoj.xml", "r")
fakoj = []

if fakoDos
   linio = ""
   fakoRegesp = /\s*<fako kodo="([[:alpha:]]+)" vinjeto="([.\/[[:alpha:]]]+)">([\s,[[:alpha:]]]+)<\/fako>\s*/
   while linio = fakoDos.gets

      if komentoRegesp.match(linio) then next end
      rezulto = fakoRegesp.match(linio)
      if rezulto and rezulto.size == 4
         fakoj << [rezulto[1], rezulto[3], rezulto[2]]
      end
   end
else
   puts "Fako-lista dosiero ne troveblas"
end

# -- literoj
#    Kodoj por neASCII literoj

puts "=== Legante literojn ==="
literoDos = File.open(dir+"/cfg/literoj.xml", "r")
atendLiteroj = {}

if literoDos
   linio = ""
   literojRegesp = /<l\s*nomo=\"(.*)\"\s*kodo=\"(.*)\"\/>/

   while linio = literoDos.gets
      trovo = literojRegesp.match(linio)
      if trovo != nil and trovo.size == 3
         
	 kodo = trovo[1].strip
      	 if rez = /#x(.*)/.match(trovo[2])

	    @literoj[kodo] = [rez[1].to_s.hex].pack("U")

	    if atendLiteroj[kodo] != nil
	       @literoj[atendLiteroj[kodo]] = @literoj[trovo[1]]
	       atendLiteroj[kodo] = nil
	    end
	 else
	    ampArr = trovo[2].split(";")

	    if ampArr.size == 1
	       atendLiteroj[trovo[2]] = kodo
	    elsif ampArr.size > 1
	       sumo = ""
	       for val in ampArr
	          if val == "&amp" then next end
		  if @literoj[val] != nil
	             sumo = sumo + @literoj[val]
		  end
	       end
	       @literoj[kodo] = sumo
	    end
	 end
      end
   end

end

# ripari kelkajn mankantajn literojn

if @literoj["a_a"] == nil then @literoj["a_a"] = @literoj["a_A"] end
if @literoj["a_fatha_a"] == nil then @literoj["a_fatha_a"] = @literoj["a_fatha_A"] end

# -- literordolisto
#    Ŝajne ne bezonata

# -- mallongigoj

puts "=== Legante mallongigojn ==="
mallongigDos = File.open(dir+"/cfg/mallongigoj.xml", "r")
mallongigoj = []

if mallongigDos
   linio = ""
   mallongigRegesp = /<mallongigo mll=\"(.*)\">(.*)<\/mallongigo>/
   while linio = mallongigDos.gets

      trovo = mallongigRegesp.match(linio)
      if trovo != nil and trovo.size == 3
        mallongigoj << [trovo[1], trovo[2]]
      end
   end
end

# -- Stiloj

puts "=== Legante stilojn ==="
stilojDos = File.open(dir+"/cfg/stiloj.xml", "r")
stiloj = []

if stilojDos
   linio = ""
   stilojRegesp = /<stilo kodo=\"(.*)\">(.*)<\/stilo>/
   while linio = stilojDos.gets

      trovo = stilojRegesp.match(linio)
      if trovo != nil and trovo.size == 3
         stiloj << [trovo[1], trovo[2]]
      end
   end
else
   puts "Stiloj dosiero netroveblas"
end

# === Trakti vort-dosierojn

vortoDos = File.open(dir+"/xml/")

artikoloj = []

# Trakti la artikolojn kaj kunigi ilin en unu granda dosiero. ===================
# Kelkaj helpaj funkcioj estos uzata por legi kaj disdividi kaj registri la XML
# ===============================================================================

# Nod-traktado ===========================

def traktiNodon(nod, stato)

   objekto = {"tipo" => nod.name, "filoj" => [], "tradukoj" => {}, "filNombro" => 0}
   stato["super"] << nod.name
   if nod["mrk"] != nil
      objekto["mrk"] = nod["mrk"]
      stato["marko"] = nod["mrk"]
   end

   teksto = ""
   
   nod.children().each do |fil|

      if fil.name == "kap"
         novaKapo = traktiKapon(fil, stato)
         objekto["nomo"] = novaKapo["nomo"]
         objekto["tildo"] = novaKapo["tildo"]
         objekto["kapo"] = novaKapo
         if nod.name == "drv"
            # Registri tradukojn en esperanton
	    for nom in objekto["nomo"].split(", ")
	       @esperantaj << fariSerchTradukon(nom, stato["artikolo"]["indekso"], stato["marko"], 0)
	    end
         end
      elsif fil.name == "uzo"
         novaUzo = traktiUzon(fil, stato)
      	 if objekto["uzoj"] == nil
	    objekto["uzoj"] = []
	 end
	 objekto["uzoj"] << novaUzo
      elsif fil.name == "gra"
         fil.children().each do |fil2|
            if fil2.name == "vspec"
               objekto["vspec"] = fil2.text
            end
         end
      elsif fil.name == "subart"
         objekto["filNombro"] += 1
         objekto["filoj"] << traktiNodon(fil, stato)
      elsif fil.name == "drv"
         objekto["filNombro"] += 1
         objekto["filoj"] << traktiNodon(fil, stato)
      elsif fil.name == "subdrv"
         objekto["filNombro"] += 1
         objekto["filoj"] << traktiNodon(fil, stato)
      elsif fil.name == "snc"
         stato["senco"] = objekto["filNombro"]
         objekto["filNombro"] += 1
         objekto["filoj"] << traktiNodon(fil, stato)
      elsif fil.name == "subsnc"
         objekto["filNombro"] += 1
         objekto["filoj"] << traktiNodon(fil, stato)
      elsif fil.name == "dif"
         novaDifino = traktiDifinon(fil, stato)
         objekto["filoj"] << novaDifino
      elsif fil.name == "rim"
         novaRimarko = traktiRimarkon(fil, stato)
         objekto["filoj"] << novaRimarko
      elsif fil.name == "ref"
         stato["refspac"] = objekto["filoj"].count > 0
         novaRefo = traktiRefon(fil, stato)
         objekto["filoj"] << novaRefo
      elsif fil.name == "refgrp"
         stato["refspac"] = objekto["filoj"].count > 0
         novaRefgrupo = traktiRefgrupon(fil, stato)
         objekto["filoj"] << novaRefgrupo
      elsif fil.name == "ekz"
         novaEkzemplo = traktiEkzemplon(fil, stato)
         #teksto += novaEkzemplo["teksto"]
	 objekto["filoj"] << novaEkzemplo
      elsif fil.name == "trd"
         traktiTradukon(fil, stato)
      elsif fil.name == "trdgrp"
         traktiTradukGrupon(fil, stato)
      elsif fil.name == "text"
         #puts "teksto: " + fil.text + "|"
         #objekto["filoj"] << {"tipo" => "teksto", "teksto" => fil.text}
      else
         objekto["filoj"] << traktiNodon(fil, stato)
      end
   end

   for fil in objekto["filoj"]
      if fil["teksto"] != nil
         if fil["tipo"] == "refo" or fil["tipo"] == "refgrupo"
	    teksto += " "
	 end
         teksto += fil["teksto"]
      end
   end

   #objekto["teksto"] = teksto
   stato["super"].pop
   return objekto
end

def tekstoPorNodo(nodo, stato)

   teksto = ""
   if nodo.name == "text"
      teksto = nodo.text
   elsif nodo.name == "tld"
      teksto += traktiTildon(nodo, stato)
   end

   nodo.children().each do |filo|

      teksto += tekstoPorNodo(filo, stato)
   end

   return teksto
end

def traktiKapon(kap, stato)

   objekto = {"tipo" => kap.name}
   teksto = ""
   nomo = ""
   tildo = ""

   kap.children().each do |fil|

      if fil.name == "ofc"
         objekto["ofc"] = fil.text
      elsif fil.name == "rad"
         objekto["rad"] = fil.text
	 stato["radiko"] = fil.text
         stato["artikolo"]["radiko"] = fil.text
         teksto += fil.text
      elsif fil.name == "fnt"
         # fari nenion
      elsif fil.name == "tld"
         teksto += traktiTildon(fil, stato)
         nomo += traktiTildon(fil, stato)
         tildo += "~"
      elsif fil.name == "text"
         teksto += fil.text
         nomo += fil.text
         tildo += fil.text
      elsif fil.name == "var"
         fil.children().each do |fil2|
            if fil2.name == "kap"
               subkapo = traktiKapon(fil2, stato)
               teksto += subkapo["teksto"]
               nomo += subkapo["nomo"]
               tildo += subkapo["tildo"]
            end
         end
      end
      
   end

   
   objekto["teksto"] = teksto.gsub("\n", "").gsub("\r", "").squeeze(" ").strip
   if stato["super"][-1] == "art"
      stato["artikolo"]["titolo"] = objekto["teksto"]
   end
   stato["nomo"] = objekto["nomo"] = nomo.strip
   stato["tildo"] = objekto["tildo"] = tildo.strip
   return objekto
end

def traktiUzon(uzo, stato)

   objekto = {"tipo" => uzo.name}
   uzo.each do |a, b|
      objekto[a] = b
   end

   objekto["teksto"] = uzo.text
   return objekto
end

def traktiDifinon(dif, stato)

   stato["super"] << "dif"
   objekto = {"tipo" => dif.name}
   teksto = ""

   dif.children().each do |fil|

      if fil.name == "text"
         teksto += prepariTekston(fil.text)
      elsif fil.name == "ekz"
         novaEkzemplo = traktiEkzemplon(fil, stato)
         teksto += novaEkzemplo["teksto"]
      elsif fil.name == "trd"
         novaTraduko = traktiTradukon(fil, stato)
         teksto += "<i>#{novaTraduko["teksto"]}</i>"
      elsif fil.name == "ref"
         stato["refspac"] = (teksto == "")
         novaRefo = traktiRefon(fil, stato)
         teksto += " " + novaRefo["teksto"]
      elsif fil.name == "refgrp"
         stato["refspac"] = (teksto == "")
         novaRefgrupo = traktiRefgrupon(fil, stato)
         teksto += " " + novaRefgrupo["teksto"]
      elsif fil.name == "tld"
         teksto += traktiTildon(fil, stato)
      else
         
      end
   end

   teksto.gsub!("</i><i>", "")
   objekto["teksto"] = teksto.squeeze(" ").strip
   stato["super"].pop
   return objekto
end

def traktiRimarkon(rim, stato)

   stato["super"] << "rim"
   objekto = {"tipo" => rim.name}
   teksto = ""

   rim.children().each do |fil|

      if fil.name == "text"
         teksto += prepariTekston(fil.text)
      elsif fil.name == "ekz"
         novaEkzemplo = traktiEkzemplon(fil, stato)
         teksto += novaEkzemplo["teksto"]
      elsif fil.name == "trd"
         novaTraduko = traktiTradukon(fil, stato)
         teksto += "<i>#{novaTraduko["teksto"]}</i>"
      elsif fil.name == "ref"
         stato["refspac"] = (teksto == "")
         novaRefo = traktiRefon(fil, stato)
         teksto += " " + novaRefo["teksto"]
      elsif fil.name == "refgr"
         stato["refspac"] = (teksto == "")
         novaRefgrupo = " " + traktiRefgrupon(fil, stato)
         teksto += novaRefgrupo["teksto"]
      elsif fil.name == "tld"
         teksto += traktiTildon(fil.text, stato)
      elsif fil.name == "em"
         teksto += "<b>" + tekstoPorNodo(fil, stato) + "</b>"
      else
         
      end
   end

   teksto.gsub!("</i><i>", "")
   teksto = "\n<b>Rim.</b>: " + teksto.squeeze(" ").strip
   objekto["teksto"] = teksto
   stato["super"].pop
   return objekto
end

def traktiEkzemplon(ekz, stato)

   stato["super"] << "ekz"
   objekto = {"tipo" => ekz.name}
   teksto = ""
   miaIndekso = false

   ekz.children().each do |fil|
      
      if fil.name == "text"
         teksto += fil.text
      elsif fil.name == "ind"
         novaIndekso = traktiIndekson(fil, stato)
         stato["indekso"] = novaIndekso["teksto"]
         miaIndekso = true
         teksto += novaIndekso["teksto"]
      elsif fil.name == "klr"
         teksto += "</i>" + prepariVorte(fil.text, stato["radiko"]) + "<i>"
      elsif fil.name == "trd"
         traktiTradukon(fil, stato)
      elsif fil.name == "tld"
         teksto += traktiTildon(fil, stato)
      elsif fil.name == "fnt"
         #trakti fonton
         teksto.gsub!(/\s*$/, "")
      elsif fil.name == "ref"
         novaRefo = traktiRefon(fil, stato)
         teksto += novaRefo["teksto"]
      elsif fil.name == "em"
         teksto += "<b>" + tekstoPorNodo(fil, stato) + "</b>"
      else

      end
   end

   if miaIndekso then stato["indekso"] = nil end

   teksto = " <i>" + teksto.gsub(/[\n\r\t\s]*;[\n\r\t\s]*$/, ";").squeeze(" ").strip + "</i>"
   objekto["teksto"] = prepariTekston(teksto)
   stato["super"].pop
   return objekto
end

def traktiIndekson(ind, stato)

   objekto = {"tipo" => "indekso"}
   teksto = ""   

   ind.children().each do |fil|
      if fil.name == "text"
         teksto += fil.text
      elsif fil.name == "tld"
         teksto += traktiTildon(fil, stato)
      end
   end

   objekto["teksto"] = teksto
   return objekto
end

def traktiRefon(ref, stato)

   objekto = {"tipo" => "refo"}
   teksto = ""

   ref.each do |a,b|
      objekto[a] = b
   end

   sup = stato["super"][-1]
   if sup != "dif" and sup != "rim" and sup != "ekz"
      simbolo = refSimbolo(ref["tip"])
      if stato["refspac"]
         teksto += " "
      end
      if simbolo != ""
         teksto += simbolo + " "
      end
   end
   teksto += "<a href=\"#{objekto["cel"]}\">"
   ref.children().each do |fil|
      if fil.name == "tld"
         teksto += traktiTildon(fil, stato)
      elsif fil.name == "text"
         teksto += prepariTekston(fil.text)
      end
   end

   teksto += "</a>"
   objekto["teksto"] = teksto

   return objekto
end

def traktiRefgrupon(refgrp, stato)

   objekto = {"tipo" => "refgrupo"}
   teksto = ""

   refgrp.each do |a,b|
      objekto[a] = b
   end

   sup = stato["super"][-1]
   if sup != "dif" and sup != "rim" and sup != "ekz"
      simbolo = refSimbolo(refgrp["tip"])
      if stato["refspac"]
         teksto += " "
      end
      if simbolo != ""
         teksto += simbolo + " "
      end
   end

   refgrp.children().each do |ref|
      if ref.name == "ref"
         novaRefo = traktiRefon(ref, stato)
         teksto += novaRefo["teksto"]
      elsif ref.name == "text"
         teksto += ref.text
      end
      
   end

   objekto["teksto"] = teksto.squeeze(" ").gsub(/\s*$/, "")
   return objekto
end

def refSimbolo(tip)

   case tip
      when "sin"
         return "⇒"
      when "dif"
         return "="
      when "super"
         return "⇗"
      when "sub"
         return "⇘"
      when "vid"
         return "➞"
      else
         return ""
    end

end

def traktiTildon(tld, stato)

   if tld["lit"] == nil
      return stato["radiko"]
   else
      return tld["lit"] + stato["radiko"][1, stato["radiko"].length]
   end

end

def traktiTradukon(trd, stato)

   objekto = {"tipo" => "traduko", "lingvo" => trd["lng"]}
   lingvo = trd["lng"]
   teksto = ""

   trd.children().each do |fil|

      if fil.name == "text"
         teksto += fil.text
      elsif fil.name == "ind"
         novaIndekso = traktiIndekson(fil, stato)
         teksto += novaIndekso["teksto"]
         # Fakte, ni ignoras indeksojn trovitajn en la traduko. La retejo shajne ne zorgas pri ili
      elsif fil.name == "klr"
         teksto += anstatauTildo(fil.text, stato["radiko"])
      else
     
      end
   end

   indekso = teksto
   if stato["indekso"] != nil and stato["indekso"] != "" then indekso = stato["indekso"] end

   if stato["artikolo"]["tradukoj"][lingvo] == nil then stato["artikolo"]["tradukoj"][lingvo] = [] end
   stato["artikolo"]["tradukoj"][lingvo] << fariArtikolTradukon(stato["tildo"], teksto, stato["marko"], stato["senco"])
   stato["tradukoj"][lingvo] << fariSerchTradukon(indekso, stato["artikolo"]["indekso"], stato["marko"], stato["senco"])

   objekto["teksto"] = teksto
   return objekto   
end

def traktiTradukGrupon(trdgrp, stato)

   objekto = {"tipo" => "trdgrp", "lingvo" => trdgrp["lng"]}
   teksto = ""

   trdgrp.children() do |trd|

      if trd.name == "trd"
         traktiTradukon(trd, stato)
      end
   end

   return objekto
end

def fariArtikolTradukon(nomo, teksto, marko, senco)

   return {"nomo" => nomo, "teksto" => teksto,  "indekso" => marko, "senco" => senco}

end

def fariSerchTradukon(teksto, indekso, marko, senco)

   return {"teksto" => teksto, "indekso" => indekso, "marko" => marko, "senco" => senco}

end

def provi(nodo)

   if nodo["vspec"] != nil
      print nodo["vspec"] + "\n"
   end

   if nodo["uzoj"] != nil and nodo["uzoj"].count > 0
      for uzo in nodo["uzoj"]
         if nodo["tipo"] == "snc"
            print uzo["teksto"] + " "
         else
            print uzo["teksto"] + "\n"
         end
      end
   end

   if nodo["teksto"] != nil and nodo["teksto"] != ""
      print nodo["teksto"]
   end

   if nodo["filoj"] == nil then return end

   filNombro = 1

   for fil in nodo["filoj"]

      if fil["tipo"] == "subart"
         if nodo["filNombro"] != nil and nodo["filNombro"] > 1
           for i in 1..filNombro
              print "I"
           end
           filNombro += 1
           print ".\n"
         end
         provi(fil)
      elsif fil["tipo"] == "drv"
         puts "=== " + fil["nomo"] + " ==="
         provi(fil)
         puts "====================="
      elsif fil["tipo"] == "subdrv"
         if nodo["filNombro"] != nil and nodo["filNombro"] > 1
            print ("A".."Z").to_a[filNombro-1] + ".\n"
            filNombro += 1
         end
         provi(fil)
         print "\n"
      elsif fil["tipo"] == "snc"
	 print "\n"
         if nodo["filNombro"] != nil and nodo["filNombro"] > 1
            print filNombro.to_s + ".\n"
            filNombro += 1
         end
         provi(fil)
         print "\n"
      elsif fil["tipo"] == "subsnc"
         if nodo["filNombro"] != nil and nodo["filNombro"] > 1
            print ("a".."z").to_a[filNombro-1] + ")\n"
            filNombro += 1
         end
         provi(fil)
      else
         provi(fil)
      end

   end

end

if vortoDos and File.directory?(dir+"/xml/")

   Dir.foreach(dir+"/xml/") do |artikolDosiero|
      next if artikolDosiero == '.' or artikolDosiero == '..'

      #artikolDosiero = "kontrol.xml"
      puts "-legante #{artikolDosiero}"
      dosiero = File.open(dir + "/xml/" + artikolDosiero, "r")
      enhavo = dosiero.read
      dosiero.close()
      
      xml = Nokogiri::XML(prepariTekston(enhavo))

      artikolo = {"indekso" => artikolDosiero.gsub(".xml", ""), "tradukoj" => {}}
      stato = {"artikolo" => artikolo, "tradukoj" => tradukoj, "super" => [], "senco" => 0}
      objekto = traktiNodon(xml, stato)
      artikolo["objekto"] = objekto

      artikoloj << artikolo
      #provi(objekto)
      #puts objekto
      #exit
   end
end

# ============================

Dir.mkdir("preparita") unless File.exists?("preparita")

LingvojElDos = File.open("preparita/lingvoj.dat", "w")

LingvojElDos.print JSON.generate(lingvoj)

LingvojElDos.close

# ---

FakojElDos = File.open("preparita/fakoj.dat", "w")

FakojElDos.print JSON.generate(fakoj)

FakojElDos.close

# ---

MallongigElDos = File.open("preparita/mallongigoj.dat", "w")

MallongigElDos.print JSON.generate(mallongigoj)

MallongigElDos.close

# ---

StilojElDos = File.open("preparita/stiloj.dat", "w")

StilojElDos.print JSON.generate(stiloj)

StilojElDos.close

# ---

VortojElDos = File.open("preparita/vortoj.dat", "w")

VortojElDos.print JSON.generate(artikoloj)

VortojElDos.close

# ---
# Registri tradukojn po lingvo

Dir.mkdir("preparita/indeksoj") unless File.exists?("preparita/indeksoj")

for lingvo in tradukoj.each_key
    
    miaDos = File.open("preparita/indeksoj/indekso_#{lingvo}.dat", "w")

    miaDos.print JSON.generate(tradukoj[lingvo])

    miaDos.close
end

# Registri esperantajn vortojn

miaDos = File.open("preparita/indeksoj/indekso_eo.dat", "w")
miaDos.print JSON.generate(@esperantaj)
miaDos.close

# === Fino ===