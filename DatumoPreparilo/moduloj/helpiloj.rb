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

def prepariVorte(teksto, vorto)

    return prepariTekston(anstatauTildo(teksto, vorto))

end

def prepariTekston(teksto)

    teksto2 = teksto.gsub("\n", " ").gsub("\r", " ").gsub("\t", "").squeeze(" ")
    teksto2 = teksto2.gsub("...", "…")
    teksto2 = teksto2.gsub("<em>", "<b>").gsub("</em>", "</b>")

    return anstatauKodo(teksto2)

end

# Por konstrui la traduk-indeksojn - intermeti en traduk-array vorton kaj ĝian
# destino-markon
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
    
# Trovi Romian version de nombro (por listado)
def alRomia(nombro)

    arabajLiteroj = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
    romiajLiteroj = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        
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

# Simboloj kiuj aperas en etikedoj <ref>
    
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