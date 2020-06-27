# coding: utf-8
require 'cgi'
require 'json'
require 'nokogiri'

# Supraj valoroj ===================================

@literoj = {}
@esperantaj = []
@fakvortoj = {}

# dumprogramaj

@indikiloDeMarko = {}

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
eldir = nil
aldir = "./datumoj"

if ARGV.count > 0
  eldir = ARGV[0]
end

if ARGV.count > 1
  aldir = ARGV[1]
end

# === Kontroli chu la dosierujo ekzistas, kaj havas ĝustan strukturon
unless File.exists?(eldir) and File.exists?(eldir+"/grundo") and File.exists?(eldir+"/revo")
   puts "Eraro: bezonataj doserujoj ne trovitas"
end

# === Fari listojn de lingvoj kaj iliaj literoj

komentoRegesp = /\s*<!--.*-->˜\s*/

# -- lingvolisto

puts "=== Legante lingvojn ==="
lingvoDos = File.open(eldir+"/grundo/lingvoj.xml", "r")
lingvoj = []
tradukoj = {}

if lingvoDos
   linio = ""
   lingvoRegesp = /\s*<lingvo kodo="([[:alpha:]]+)">(.+)<\/lingvo>\s*/
   while linio = lingvoDos.gets
      #if komentoRegesp.match(linio) then next end
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

lingvoDos.close

# -- fakolisto

def korektiFakKodon(kodo)
     case kodo
        when "POSX"
            return "POŜ"
        when "SHI"
            return "ŜIP"
        when "MAS"
            return "MAŜ"
        when "AUT"
            return "AŬT"
        else
            return kodo
     end
end
    
puts "=== Legante fakojn ==="
fakoDos = File.open(eldir+"/grundo/fakoj.xml", "r")
fakoj = []

if fakoDos
   linio = ""
   fakoRegesp = /\s*<fako kodo="([[:alpha:]]+)" vinjeto="([.\/[[:alpha:]]]+)">([\s,[[:alpha:]]]+)<\/fako>\s*/
   while linio = fakoDos.gets

      if komentoRegesp.match(linio) then next end
      rezulto = fakoRegesp.match(linio)
      if rezulto and rezulto.size == 4
          
         # Specialaj korektoj
         kodo = korektiFakKodon(rezulto[1])
          
         fakoj << [kodo, rezulto[3], rezulto[2]]
         @fakvortoj[kodo] = {}
      end
   end
else
   puts "Fako-lista dosiero ne troveblas"
end

# -- literoj
#    Kodoj por neASCII literoj

fakoDos.close

puts "=== Legante literojn ==="
literoDos = File.open(eldir+"/grundo/literoj.xml", "r")
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

literoDos.close

# ripari kelkajn mankantajn literojn

if @literoj["a_a"] == nil then @literoj["a_a"] = @literoj["a_A"] end
if @literoj["a_fatha_a"] == nil then @literoj["a_fatha_a"] = @literoj["a_fatha_A"] end

# -- literordolisto
#    Ŝajne ne bezonata

# -- mallongigoj

puts "=== Legante mallongigojn ==="
mallongigDos = File.open(eldir+"/grundo/mallongigoj.xml", "r")
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

mallongigDos.close

# -- Stiloj

puts "=== Legante stilojn ==="
stilojDos = File.open(eldir+"/grundo/stiloj.xml", "r")
@stiloj = []

if stilojDos
   linio = ""
   stilojRegesp = /<stilo kodo=\"(.*)\">(.*)<\/stilo>/
   while linio = stilojDos.gets

      trovo = stilojRegesp.match(linio)
      if trovo != nil and trovo.size == 3
         @stiloj << [trovo[1], trovo[2]]
      end
   end
else
   puts "Stiloj dosiero netroveblas"
end

stilojDos.close

# === Trakti vort-dosierojn

artikoloj = []

# Trakti la artikolojn kaj kunigi ilin en unu granda dosiero. ===================
# Kelkaj helpaj funkcioj estos uzata por legi kaj disdividi kaj registri la XML
# ===============================================================================

# Nod-traktado ===========================

def traktiNodon(nod, stato)

   objekto = {"tipo" => nod.name, "filoj" => [], "tradukoj" => {}, "filNombro" => 0}
   stato["super"] << nod.name

   miaMarko = false

   if nod["mrk"] != nil
      objekto["mrk"] = nod["mrk"]
      stato["marko"] << nod["mrk"]
      miaMarko = true
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
	       @esperantaj << fariSerchTradukon(nom, nom, stato["nomo"], stato["artikolo"]["indekso"], stato["marko"].last, 0)
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
         objekto["filNombro"] += 1
         stato["senco"] = objekto["filNombro"]
         novaSenco = traktiNodon(fil, stato)
         objekto["filoj"] << novaSenco
         if novaSenco["mrk"] != nil
             @indikiloDeMarko[novaSenco["mrk"]] = objekto["filNombro"].to_s
         end
         stato["senco"] = 0
      elsif fil.name == "subsnc"
         objekto["filNombro"] += 1
         novaSubSenco = traktiNodon(fil, stato)
         objekto["filoj"] << novaSubSenco
         if novaSubSenco["mrk"] != nil
             litero = ("a".."z").to_a[objekto["filNombro"]-1]
             numero = stato["senco"].to_s + litero
             @indikiloDeMarko[novaSubSenco["mrk"]] = numero
         end
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
      elsif fil.name == "frm"
         novaFormulo = traktiFormulon(fil, stato)
	 teksto += novaFormulo["teksto"]
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

   # atendu ghis la fino de drv antau enmeti tradukojn el ekzemploj -
   # tiuj ghenerale rilatas al dirajhoj, ke ne estas baza vortoj por serchi
   if stato["super"].count == 1 and stato["ekzTradukoj"] != []
      for lng, tradoj in stato["ekzTradukoj"]
         for trad in tradoj
	    stato["artikolo"]["tradukoj"][lng] << trad
	 end
      end

      stato["ekzTradukoj"] = {}
   end	       	  

   if miaMarko then stato["marko"].pop end

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
         # Nur uzu unuan "ofc"-on
         if objekto["ofc"] == nil
             objekto["ofc"] = fil.text
         end
      elsif fil.name == "rad" and stato["radiko"] == nil
         # Nur registru unuan "rad"-on, tamen ja aldoni la tekston de sekvaj
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
      else
         teksto += fil.text 
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

    objekto = {"tipo" => uzo.name, "teksto" => uzo.text}
    
    if uzo["tip"] == "fak"
        
        # registi fakvorton se cheestas
        for nomo in stato["nomo"].split(", ")
            kodo = korektiFakKodon(uzo.text)
            if not @fakvortoj[kodo].include?(nomo)
                @fakvortoj[kodo][nomo] = []
            end
            
            fakVorto = fariFakVorton(nomo, stato["artikolo"]["indekso"], stato["marko"][2], stato["senco"], nomo)
            @fakvortoj[kodo][nomo] << fakVorto
        end
        
        # Uzu korektitan kodon kiel teksto
        objekto["teksto"] = kodo
    end
    
    uzo.each do |a, b|
        objekto[a] = b
    end

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
      elsif fil.name == "trdgrp"
         novaTradukGrupo = traktiTradukGrupon(fil, stato)
	 teksto += "<i>#{novaTradukGrupo["teksto"]}</i>"
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
      elsif fil.name == "ctl"
         teksto += "„" + prepariVorte(fil.inner_html, stato["radiko"]) + "“"
      elsif fil.name == "frm"
         novaFormulo = traktiFormulon(fil, stato)
	 teksto += novaFormulo["teksto"]
      elsif fil.name == "sncref"
          teksto += prepariTekston(fil.to_s)
      else
         if fil != nil and fil.text != nil
	    subdifino = traktiDifinon(fil, stato)
	    teksto += subdifino["teksto"]
	 end
      end
   end

   teksto.gsub!("</i><i>", "")
   objekto["teksto"] = teksto.gsub(/\n\r\t/, " ").squeeze(" ").strip
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
      elsif fil.name == "ctl"
         teksto += "„" + prepariVorte(fil.inner_html, stato["radiko"]) + "“"
      elsif fil.name == "frm"
         novaFormulo = traktiFormulon(fil, stato)
         teksto += novaFormulo["teksto"]
      elsif fil.name == "sncref"
          teksto += prepariTekston(fil.to_s)
      elsif fil.name == "esc"
          teksto += tekstoPorNodo(fil, stato)
      else

      end
   end

   teksto.gsub!("</i><i>", "")
   teksto = "<b>Rim.</b>: " + teksto.squeeze(" ").strip
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
         stato["indekso"] = novaIndekso["tildo"]
         miaIndekso = true
         teksto += novaIndekso["teksto"]
      elsif fil.name == "klr"
         subEkzemplo = traktiDifinon(fil, stato)
         teksto += "</i>" + prepariVorte(subEkzemplo["teksto"], stato["radiko"]) + "<i>"
      elsif fil.name == "trd"
         traktiTradukon(fil, stato)
      elsif fil.name == "trdgrp"
         traktiTradukGrupon(fil, stato)
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
      elsif fil.name == "ctl"
         teksto += "„" + prepariVorte(fil.inner_html, stato["radiko"]) + "“"
      elsif fil.name == "frm"
         novaFormulo = traktiFormulon(fil, stato)
         teksto += novaFormulo["teksto"]
      elsif fil.name == "sncref"
          teksto += prepariTekston(fil.to_s)
      elsif fil.name == "nom"
          teksto += tekstoPorNodo(fil, stato)
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
   tildo = ""

   ind.children().each do |fil|
      if fil.name == "text"
         teksto += fil.text
	 tildo += fil.text
      elsif fil.name == "tld"
         teksto += traktiTildon(fil, stato)
	 tildo += uziTildon(fil.to_s)
      end
   end

   objekto["teksto"] = teksto
   objekto["tildo"] = tildo
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
      elsif fil.name == "ctl"
         teksto += "„" + prepariVorte(fil.inner_html, stato["radiko"]) + "“"         
      elsif fil.name == "text"
         teksto += prepariTekston(fil.text)
      elsif fil.name == "sncref"
          teksto += prepariTekston(fil.to_s)
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
      when "ant"
         return "⇝"
      when "dif"
         return "="
      when "super"
         return "⇗"
      when "sub"
         return "⇘"
      when "vid"
         return "➞"
      when "ekz"
         return "⇉"
      when "prt"
         return ""
      when "malprt"
         return ""
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

def traktiFormulon(frm, stato)

    objekto = {"tipo" => "frm"}
    teksto = ""
    frm.children().each do |fil|

    	if fil.name == "k"
	   teksto += fil.text
	elsif fil.name == "g"
	   teksto += "<b>" + fil.text + "</b>"
	elsif fil.name == "sup"
	   teksto += "<sup>" + fil.text + "</sup>"
	elsif fil.name == "sub"
	   teksto += "<sub>" + fil.text + "</sub>"
        elsif fil.name == "deg"
          teksto += "°"
        elsif fil.name == "minute"
          teksto += "′"
        elsif fil.name == "second"
          teksto += "″"
	else
	   if fil.text == nil
	      puts stato["radiko"]
 	   end
	   teksto += fil.text
	end
    end

    objekto["teksto"] = teksto
    return objekto
end

def traktiTradukon(trd, stato)

   objekto = {"tipo" => "traduko", "lingvo" => trd["lng"]}
   lingvo = trd["lng"]
   teksto = ""
   indekso = nil

   trd.children().each do |fil|

      if fil.name == "text"
         teksto += fil.text
      elsif fil.name == "ind"
         novaIndekso = traktiIndekson(fil, stato)
         teksto += novaIndekso["teksto"]
	 indekso = novaIndekso["teksto"]
      elsif fil.name == "klr"
         klarigaTeksto = prepariVorte(fil.inner_html, stato["radiko"])
         # Ne montru <em>-ojn en traduko (ekz. "Banderolo - en)
         klarigaTeksto = klarigaTeksto.gsub("<em>", "").gsub("</em>" ,"")
         teksto += klarigaTeksto
      elsif fil.name == "em"
          teksto += fil.teksto
      end
   end

   if stato["artikolo"]["tradukoj"][lingvo] == nil then stato["artikolo"]["tradukoj"][lingvo] = [] end
   if stato["indekso"] != nil and stato["indekso"] != ""
      if stato["ekzTradukoj"][lingvo] == nil then stato["ekzTradukoj"][lingvo] = [] end
      stato["ekzTradukoj"][lingvo] << fariArtikolTradukon(stato["indekso"], teksto, stato["marko"].last, stato["senco"])
   else
      if indekso == nil then indekso = teksto end
      stato["artikolo"]["tradukoj"][lingvo] << fariArtikolTradukon(stato["tildo"], teksto, stato["marko"].last, stato["senco"])
      stato["tradukoj"][lingvo] << fariSerchTradukon(teksto, indekso, stato["nomo"], stato["artikolo"]["indekso"], stato["marko"].last, stato["senco"])
   end



   objekto["teksto"] = teksto
   return objekto   
end

def traktiTradukGrupon(trdgrp, stato)

   objekto = {"tipo" => "trdgrp", "lingvo" => trdgrp["lng"]}
   teksto = ""

   trdgrp.children().each do |trd|
      if trd.name == "trd"
         trd["lng"] = trdgrp["lng"]
         novaTraduko = traktiTradukon(trd, stato)
	 teksto += novaTraduko["teksto"]
      else
         teksto += trd.text
      end
   end

   objekto["teksto"] = teksto.strip
   return objekto
end

def fariArtikolTradukon(nomo, teksto, marko, senco)

   return {"nomo" => nomo, "teksto" => teksto,  "indekso" => marko, "senco" => senco}

end

def fariSerchTradukon(videbla, teksto, nomo, indekso, marko, senco)

   return {"videbla" => videbla, "teksto" => teksto, "nomo" => nomo, "indekso" => indekso, "marko" => marko, "senco" => senco}

end
       
def fariFakVorton(nomo, indekso, marko, senco, teksto)
   
    return {"nomo" => nomo, "indekso" => indekso, "marko" => marko, "senco" => senco, "teksto" => teksto}
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

def tekstoPorUzo(kodo, tipo)

   if tipo == "fak"
      return "[" + kodo + "]"
   elsif tipo == "stl"
      for stilo in @stiloj
         if stilo[0] == kodo
            return "(" + stilo[1] + ")"
         end
      end
   end

   return kodo

end

# Trovi Romian version de nombro (por listado)
def alRomia(nombro)

   romiajLiteroj = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
   arabajLiteroj = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        
   romia = ""
   komenca = nombro
        
   for j in 0..romiajLiteroj.count - 1
    
      romiaLitero = romiajLiteroj[j]        
      arabaSumo = arabajLiteroj[j]
      div = komenca / arabaSumo
            
      if div > 0
      
         for i in 0..div-1
             romia += romiaLitero
         end
                
         komenca -= arabaSumo * div
      end
    end

    return romia
end
    
def printi(nodo)

   objekto = {"marko" => nodo["mrk"]}
   
   if nodo["tipo"] == "art"
      objekto["tipo"] = "artikolo"
      objekto["grupoj"] = []
      objekto["vortoj"] = []
   elsif nodo["tipo"] == "subart"
      objekto["tipo"] = "grupo"
      objekto["vortoj"] = []
   elsif nodo["tipo"] == "drv"
      objekto["tipo"] = "vorto"
   end

   teksto = ""

   if nodo["kapo"] != nil
      objekto["ofc"] = nodo["kapo"]["ofc"]
      if nodo["tipo"] == "art"
         objekto["titolo"] = nodo["kapo"]["teksto"]
      else 
         objekto["titolo"] = nodo["kapo"]["nomo"]
      end
   end

   if nodo["vspec"] != nil
      teksto += nodo["vspec"] + " "
   end

   if nodo["uzoj"] != nil and nodo["uzoj"].count > 0
      for uzo in nodo["uzoj"]
         teksto += tekstoPorUzo(uzo["teksto"], uzo["tip"])
         if nodo["tipo"] == "snc" or nodo["tipo"] == "subsnc"
            teksto += " "
         end
      end
   end

   if nodo["teksto"] != nil and nodo["teksto"] != ""
      teksto += nodo["teksto"]
   end

   filNombro = 1
   
   if nodo["filoj"] != nil
   for fil in nodo["filoj"]

      if fil["tipo"] == "subart"
         if nodo["filNombro"] != nil and nodo["filNombro"] > 1
           nombro = alRomia(filNombro) + ". "
           filNombro += 1
         end
         rez = printi(fil)
	 rez["teksto"] = nombro + rez["teksto"]
	 objekto["grupoj"] << rez
      elsif fil["tipo"] == "drv"
         rez = printi(fil)
	 objekto["vortoj"] << rez
      elsif fil["tipo"] == "subdrv"
         if teksto != ""
            teksto += "\n\n"
	 end
         if nodo["filNombro"] != nil and nodo["filNombro"] > 1
            teksto += ("A".."Z").to_a[filNombro-1] + ". "
            filNombro += 1
         end
         rez = printi(fil)
	 teksto += rez["teksto"]
      elsif fil["tipo"] == "snc"
         if teksto != ""
            teksto += "\n\n"
	 end
         if nodo["filNombro"] != nil and nodo["filNombro"] > 1
            teksto += filNombro.to_s + ". "
            filNombro += 1
         end
         rez = printi(fil)
	 teksto += rez["teksto"]
      elsif fil["tipo"] == "subsnc"
         if teksto != ""
            teksto += "\n\n"
	 end
         if nodo["filNombro"] != nil and nodo["filNombro"] > 1
            teksto += ("a".."z").to_a[filNombro-1] + ") "
            filNombro += 1
         end
         rez = printi(fil)
	 teksto += rez["teksto"]
      else
         rez = printi(fil)
	 if fil["tipo"] == "rim"
	    teksto += "\n"
	 end

	 teksto += rez["teksto"]

	 if rez["vortoj"] != nil
	    objekto["vortoj"] = rez["vortoj"]
	 end
	 if rez["grupoj"] != nil
	    objekto["grupoj"] = rez["grupoj"]
	 end
	 if rez["titolo"] != nil
	    objekto["titolo"] = rez["titolo"]
	 end
	 if rez["ofc"] != nil
	    objekto["ofc"] = rez["ofc"]
	 end
      end

   end
   end # Fino de filoj

    if nodo["tipo"] == "drv"
        #puts nodo 
    end
    
   objekto["teksto"] = teksto

   if nodo["tipo"] == "art" and objekto["vortoj"] != nil and objekto["grupoj"] == []
      objekto["grupoj"] = ["vortoj" => objekto["vortoj"], "teksto" => ""]
      objekto["vortoj"] = nil
   end

   return objekto

end

def postTraktiArtikolon(dosiero, teksto)
    simplaFormo = /<sncref ref=\\"(.*?)\\"\/>/
    anstatauoj = {}
    teksto.scan(simplaFormo) { |m|
        marko = m[0]
        indikilo = @indikiloDeMarko[marko]
        if indikilo != nil
            anstatauoj[marko] = indikilo
        end
    }
    
    anstatauoj.each do |marko, indikilo|
       teksto = teksto.gsub("<sncref ref=\\\"" + marko.to_s + "\\\"\/>", "<sup>" + indikilo + "</sup>") 
    end
    
    anstatauoj = {}
    aFormo = /<a href=\\"(.*?)\\">(.*?)<\/a>/
    tekstKopio = teksto
    tekstKopio.scan(aFormo) { |m|
        marko = m[0]
        interno = m[1]
        if interno.include?("<sncref\/>")
            indikilo = @indikiloDeMarko[marko]
            if indikilo == nil
                indikilo = ""
                puts "AVERTO: MANKAS INDIKILO POR " + marko + " EN ARTIKOLO " + dosiero
            end
            novaInterno = interno.gsub("<sncref\/>", "<sup>" + indikilo + "</sup>") 
            teksto = teksto.gsub("<a href=\\\"" + marko + "\\\">" + interno + "</a>", "<a href=\\\"" + marko + "\\\">" + novaInterno + "</a>")
        end
    }
    
    # kroma purigado
    if /<sncref.*?\/>/.match(teksto)
        puts "AVERTO: RESTAS sncref EN ARTIKOLO " + dosiero
        teksto = teksto.gsub(/<sncref.*?\/>/, "")
    end
    
    return teksto
end
    
vortoDos = File.open(eldir+"/revo/")

if vortoDos and File.directory?(eldir+"/revo/")

   puts "=== Legante artikolojn ==="
   Dir.foreach(eldir+"/revo/") do |artikolDosiero|
      next if artikolDosiero == '.' or artikolDosiero == '..' or artikolDosiero[0] == '.' or not artikolDosiero.end_with?(".xml")

      #artikolDosiero = "kasxta.xml"
      #puts "-legante #{artikolDosiero}"
      dosiero = File.open(eldir + "/revo/" + artikolDosiero, "r")
      enhavo = dosiero.read
      dosiero.close()
      xml = Nokogiri::XML(prepariTekston(enhavo))

      artikolo = {"indekso" => artikolDosiero.gsub(".xml", ""), "tradukoj" => {}}
      stato = {"artikolo" => artikolo, "tradukoj" => tradukoj, "super" => [], "senco" => 0, "ekzTradukoj" => {}, "marko" => []}
      objekto = printi(traktiNodon(xml, stato))
      artikolo["objekto"] = objekto
      artikoloj << artikolo

      #provi(objekto)
      #puts objekto
      #puts tradukoj
      #puts artikolo["tradukoj"]
      #exit
   end
end

vortoDos.close

# ============================

Dir.mkdir(aldir) unless File.exists?(aldir)

LingvojElDos = File.open(aldir + "/lingvoj.json", "w")

LingvojElDos.print JSON.generate(lingvoj)

LingvojElDos.close

# ---

FakojElDos = File.open(aldir + "/fakoj.json", "w")

FakojElDos.print JSON.generate(fakoj)

FakojElDos.close
    
# ---
    
FakVortojElDos = File.open(aldir + "/fakvortoj.json", "w")
    
FakVortojElDos.print JSON.generate(@fakvortoj)
    
FakojElDos.close
    
# ---

MallongigElDos = File.open(aldir + "/mallongigoj.json", "w")

MallongigElDos.print JSON.generate(mallongigoj)

MallongigElDos.close

# ---

StilojElDos = File.open(aldir + "/stiloj.json", "w")

StilojElDos.print JSON.generate(@stiloj)

StilojElDos.close

# ---

VortojElDos = File.open(aldir + "/vortoj.json", "w")

traktitaj = []
for artikolo in artikoloj
    teksto = JSON.generate(artikolo)
    teksto = postTraktiArtikolon(artikolo["indekso"], teksto)
    traktitaj << JSON.parse(teksto)
end
VortojElDos.print JSON.generate(traktitaj)

VortojElDos.close

# ---
# Registri tradukojn po lingvo

Dir.mkdir(aldir + "/indeksoj") unless File.exists?(aldir + "/indeksoj")

for lingvo in tradukoj.each_key
    
    miaDos = File.open(aldir + "/indeksoj/indekso_#{lingvo}.json", "w")

    miaDos.print JSON.generate(tradukoj[lingvo])

    miaDos.close
end

# Registri esperantajn vortojn

miaDos = File.open(aldir + "/indeksoj/indekso_eo.json", "w")
miaDos.print JSON.generate(@esperantaj)
miaDos.close

# === Fino ===
puts "=== Finis ElXMLigadon ==="
