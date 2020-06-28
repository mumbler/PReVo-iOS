# Lingvoj kaj tradukoj

@komentoRegesp = /\s*<!--.*-->˜\s*/

def legiLingvojn(dosierujo)
    lingvoDos = File.open(dosierujo+"/grundo/lingvoj.xml", "r")
    lingvoj = []

    if lingvoDos
        linio = ""
        lingvoRegesp = /\s*<lingvo kodo="([[:alpha:]]+)">(.+)<\/lingvo>\s*/
        while linio = lingvoDos.gets
            if @komentoRegesp.match(linio) then next end
            rezulto = lingvoRegesp.match(linio)
            if rezulto and rezulto.size == 3
                lingvoj << [rezulto[1], rezulto[2]]
            end
        end

        lingvoDos.close
    else
        puts "Lingvo-lista dosiero ne troveblas"
    end
    
    return lingvoj
end

def starigiTradukojn(lingvoj)
   tradukoj = {}
    
   for lingvo in lingvoj 
       tradukoj[lingvo[0]] = []
   end
    
   return tradukoj
end
    
def skribiLingvojn(lingvoj, dosierujo)
    Dir.mkdir(dosierujo) unless File.exists?(dosierujo)
    lingvojDosiero = File.open(dosierujo + "/lingvoj.json", "w")
    lingvojDosiero.print JSON.generate(lingvoj)
    lingvojDosiero.close 
end

# Fakoj

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
    
def legiFakojn(dosierujo)
    fakoDos = File.open(dosierujo+"/grundo/fakoj.xml", "r")
    fakoj = []

    if fakoDos
        linio = ""
        fakoRegesp = /\s*<fako kodo="([[:alpha:]]+)" vinjeto="([.\/[[:alpha:]]]+)">([\s,[[:alpha:]]]+)<\/fako>\s*/
        while linio = fakoDos.gets
            if @komentoRegesp.match(linio) then next end
            rezulto = fakoRegesp.match(linio)
            if rezulto and rezulto.size == 4

                kodo = korektiFakKodon(rezulto[1])
                fakoj << [kodo, rezulto[3]]
            end
        end
            
        fakoDos.close
    else
       puts "Fako-lista dosiero ne troveblas"
    end

    return fakoj
end
    
def starigiFakVortojn(fakoj)
    fakvortoj = {}
    
    for fako in fakoj
        fakvortoj[fako[0]] = {}
    end
    
    return fakvortoj
end

def skribiFakojn(fakoj, dosierujo)
    Dir.mkdir(dosierujo) unless File.exists?(dosierujo)
    fakojDosiero = File.open(dosierujo + "/fakoj.json", "w")
    fakojDosiero.print JSON.generate(fakoj)
    fakojDosiero.close 
end

def skribiFakVortojn(fakVortoj, dosierujo)
    Dir.mkdir(dosierujo) unless File.exists?(dosierujo)
    fakVortojDosiero = File.open(dosierujo + "/fakvortoj.json", "w")    
    fakVortojDosiero.print JSON.generate(fakVortoj)
    fakVortojDosiero.close
end
# Literoj

def legiLiterojn(dosierujo)
    literoDos = File.open(dosierujo+"/grundo/literoj.xml", "r")
    literoj = {}
    atendLiteroj = {}

    if literoDos
        linio = ""
        literojRegesp = /<l\s*nomo=\"(.*)\"\s*kodo=\"(.*)\"\/>/

        while linio = literoDos.gets
            trovo = literojRegesp.match(linio)

            if trovo != nil and trovo.size == 3
                kodo = trovo[1].strip
                if rez = /#x(.*)/.match(trovo[2])
                    literoj[kodo] = [rez[1].to_s.hex].pack("U")

                    if atendLiteroj[kodo] != nil
                        literoj[atendLiteroj[kodo]] = literoj[trovo[1]]
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
                            if literoj[val] != nil
                                sumo = sumo + literoj[val]
                            end
                        end
                        literoj[kodo] = sumo
                    end
                end
            end
        end
        literoDos.close
            
        # ripari kelkajn mankantajn literojn
        if literoj["a_a"] == nil then literoj["a_a"] = literoj["a_A"] end
        if literoj["a_fatha_a"] == nil then literoj["a_fatha_a"] = literoj["a_fatha_A"] end
    else
        puts "Litero-lista dosiero ne troveblas"    
    end

    return literoj
end

# Mallongigoj

def legiMallongigojn(dosierujo)
    mallongigDos = File.open(dosierujo+"/grundo/mallongigoj.xml", "r")
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
        mallongigDos.close
    else
        puts "Mallongigo-lista dosiero ne troveblas"    
    end

    return mallongigoj
end

def skribiMallongigojn(mallongigoj, dosierujo)
    Dir.mkdir(dosierujo) unless File.exists?(dosierujo)
    mallongigojDosiero = File.open(dosierujo + "/mallongigoj.json", "w")
    mallongigojDosiero.print JSON.generate(mallongigoj)
    mallongigojDosiero.close 
end

# Stiloj

def legiStilojn(dosierujo)
    stilojDos = File.open(dosierujo+"/grundo/stiloj.xml", "r")
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
        stilojDos.close
    else
        puts "Stilo-lista dosiero netroveblas"
    end

    return stiloj
end

def skribiStilojn(stiloj, dosierujo)
    Dir.mkdir(dosierujo) unless File.exists?(dosierujo)
    stilojDosiero = File.open(dosierujo + "/stiloj.json", "w")
    stilojDosiero.print JSON.generate(stiloj)
    stilojDosiero.close 
end
