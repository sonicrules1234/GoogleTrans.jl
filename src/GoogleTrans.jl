module GoogleTrans
import HTTP
import JSON
export translate
#export batchtranslate

function package_rpc(text::String, lang_src::String, lang_tgt::String)::String
    parameter = [[text, lang_src, lang_tgt, true], [1]]
    escaped_parameter = JSON.json(parameter)
    rpc = [[["MkEWBc", escaped_parameter, nothing, "generic"]]]
    escaped_rpc = JSON.json(rpc)
    freq = "f.req=" * HTTP.escapeuri(escaped_rpc) * "&"
    return freq
end

function translate(text::String, lang_tgt="auto"::String, lang_src="auto"::String):String
    headers = Dict("Referer"=>"http://translate.google.com", "User-Agent"=>"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36", "Content-type"=>"application/x-www-form-urlencoded;charset=utf-8")
    freq = package_rpc(text, lang_src, lang_tgt)
    r = HTTP.request("POST", "https://translate.google.com/_/TranslateWebserverUi/data/batchexecute", headers, freq)
    resp = String(r.body)
    for line in split(resp, "\n")
        if occursin("MkEWBc", line)
            response = line * "]"
            parsed = JSON.parse(response)
            #println(parsed)
            goodparsed = JSON.parse(parsed[1][3])[2][1][1][6]
            translated = ""
            for sentencelist in goodparsed
                translated = translated * sentencelist[1] * " "
            end
            return translated
        end
    end
end

translate(inputstrings::AbstractVector{S}, lang_tgt="auto", lang_src="auto") where {S <: AbstractString} = translate.(inputstrings, lang_tgt, lang_src)

#function batchtranslate(inputstrings::Vector{AbstractString}, lang_tgt="auto"::String, lang_src="auto"::String)::Vector{String}
#    returnparts = Vector{String}()
#    for part in inputstrings
#        append!(returnparts, translate(part))
#    end
#    return returnparts
#end
end