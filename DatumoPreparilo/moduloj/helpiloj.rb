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
    teksto2 = teksto2.gsub("...", "…")
    teksto2 = teksto2.gsub("<em>", "<b>").gsub("</em>", "</b>")

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