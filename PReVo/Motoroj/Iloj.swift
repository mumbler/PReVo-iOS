//
//  Iloj.swift
//  PReVo
//
//  Created by Robin Hill on 3/11/16.
//  Copyright © 2016 NormalSoft. All rights reserved.
//

import Foundation

let markoLigoKlavo = "ligo"
let markoAkcentoKlavo = "akcento"
let markoFortoKlavo = "forto"

class Iloj {
    
    static func chapeligi(litero: Character) -> Character? {
    
        let unua = "chgjsuCGHJSU"
        let dua  = "ĉĥĝĵŝŭĈĜĤĴŜŬ"
        
        for var i = 0; i < unua.characters.count; i += 1 {
            
            if unua[unua.startIndex.advancedBy(i)] == litero {
                return dua[dua.startIndex.advancedBy(i)]
            }
        }
        
        return nil
    }
    
    static func alLitero(nombro: Int, _ granda: Bool) -> String {
        
        let alfabeto = "abcdefghijklmnoprstuvz"
        
        if nombro < alfabeto.characters.count {
            return ""
        }
        
        let litero = alfabeto[alfabeto.startIndex.advancedBy(nombro)]

        if !granda {
            return String(litero)
        } else {
            return String(litero).uppercaseString
        }
    }
    
    static func alRomia(nombro: Int) -> String {
        
        let romiajLiteroj = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]
        let arabajLiteroj = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        
        var romia = ""
        var komenca = nombro
        
        for (index, romiaLitero) in romiajLiteroj.enumerate() {
            
            let arabaSumo = arabajLiteroj[index]
            let div = komenca / arabaSumo
            
            if (div > 0)
            {
                for var i = 0; i < div; i += 1
                {
                    romia += romiaLitero
                }
                
                komenca -= arabaSumo * div
            }
        }
        
        return romia
    }
    
    static func troviMarkojn(teksto: String) -> [String : [(Int, Int, String)]] {
        
        var rez = [String : [(Int, Int, String)]]()
        rez[markoAkcentoKlavo] = [(Int, Int, String)]()
        rez[markoFortoKlavo] = [(Int, Int, String)]()
        rez[markoLigoKlavo] = [(Int, Int, String)]()
        var ligoStako = [(Int, String)]()
        var akcentoStako = [Int]()
        var fortoStako = [Int]()
        
        var en: Bool = false
        var enhavo: String = ""
        var rubo: Int = 0
        var loko: Int = 0
        
        for litero in teksto.characters {
            
            if litero == "<" {
                
                rubo += 1
                en = true
            } else if litero == ">" {
                
                rubo += 1
                en = false
                
                if enhavo == "i" {
                    akcentoStako.append(loko)
                }
                else if enhavo == "/i" {
                    if let nombro = akcentoStako.popLast() {
                        rez[markoAkcentoKlavo]?.append((nombro, loko, ""))
                    }
                }
                else if enhavo == "b" {
                    fortoStako.append(loko)
                }
                else if enhavo == "/b" {
                    if let nombro = fortoStako.popLast() {
                        rez[markoFortoKlavo]?.append((nombro, loko, ""))
                    }
                }
                else if enhavo == "/a" {
                    if let ligo = ligoStako.popLast() {
                        let nombro = ligo.0, celo = ligo.1
                        rez[markoLigoKlavo]?.append((nombro, loko, celo))
                    }
                } else {
                    do {
                        let regesp = try NSRegularExpression(pattern: "a href=\"(.*?)\"", options: NSRegularExpressionOptions())
                        let trovoj = regesp.matchesInString(enhavo, options: NSMatchingOptions(), range: NSMakeRange(0, enhavo.characters.count))
                        if let trovo = trovoj.first {
                            let celo = (enhavo as NSString).substringWithRange(trovo.rangeAtIndex(1))
                            ligoStako.append((loko, celo))
                        }
                    } catch { }
                }
                
                enhavo = ""
                
            } else {
                
                if en {
                    rubo += 1
                    
                    enhavo.append(litero)
                } else {
                    
                    loko += 1
                }
            }
        }
        
        return rez
    }

    static func forigiAngulojn(teksto: String) -> String {
        
        var rez: String = ""
        var en: Bool = false
        for litero in teksto.characters {
            
            if litero == "<" {
                en = true
            } else if litero == ">" {
                en = false
            } else if !en {
                rez.append(litero)
            }
        }
        
        return rez
    }
}
